// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/model/doctor_model.dart';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:babies_tracker/model/vaccinations_histories_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../app/notification/onesignal_notifications.dart';
import '../../model/current_medications_model.dart';
import '../../model/feeding_times_model.dart';
import '../../model/message_model.dart';
import '../../model/sleep_details_model.dart';
import '../../ui/Doctor/settings_screens/Doctor_settings.dart';
import '../../ui/doctor/mother/show_doc_mothers.dart';
import '../../ui/hospital/doctors/show_all_doctors.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial());
  static DoctorCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const ShowAllDoctorsScreen(),
    const ShowALLDoctorMothersScreen(),
    const DoctorSettingsScreen(),
  ];
  List titles = [
    AppStrings.doctors,
    AppStrings.mothers,
    AppStrings.settings,
  ];
  void changeBottomNavBar(int index) {
    emit(LoadingChangeHomeIndex());
    currentIndex = index;
    emit(ScChangeHomeIndex());
  }

  //DOCTOR FUNCTIONS AND DATA FILDES
  DoctorModel? model;
  Future<void> getCurrentDoctorData({bool homeData = false}) async {
    emit(LoadingGetDoctor());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(AppPreferences.uId)
          .get();
      model = DoctorModel.fromJson(value.data() ?? {});
      changeDoctorOnline(model!.id ?? '', AppPreferences.hospitalUid, true);
      if (homeData) {
        getHomeData();
      }

      emit(ScGetDoctor());
    } catch (e) {
      print('Get Doctor Data Error: $e');
      emit(ErorrGetDoctor(e.toString()));
    }
  }

  Future<void> editDoctor(
      {required DoctorModel model, required File? image}) async {
    try {
      emit(LoadingEditDoctor());
      //check if the new phone number is not used
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (model.phone != model.phone) {
        if (checkPhone(model.phone ?? '', value.docs)) {
          emit(ErorrEditDoctor('Phone number is already used'));
          return;
        } else {
          //save the number in firebas
          await FirebaseFirestore.instance
              .collection('phoneNumbers')
              .doc()
              .update({
            'phone': model.phone,
          });
        }
      }
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: model.email!,
        password: model.password!,
      );

      await currentUser!.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully');
      await currentUser.updatePassword(model.password ?? '');
      print(model.toJson());
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(AppPreferences.uId)
          .update(model.toJson());
      if (image != null) {
        await addImageSub(
          type: AppStrings.doctor,
          userId: AppPreferences.uId,
          parentImageFile: image,
        );
      }
      emit(ScEditDoctor());
      await getCurrentDoctorData();
    } catch (error) {
      print('Error: $error');
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrEditDoctor(
            'The email address is already in use by another account'));
      }
      print('Error: $error');
      emit(ErorrEditDoctor(error.toString()));
    }
  }

  Future<void> changeDoctorOnline(
      String id, String hospitalUid, bool value) async {
    emit(LoadingChangeDoctorOnline());
    try {
      print(hospitalUid);
      print(id);
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(hospitalUid)
          .collection(AppStrings.doctor)
          .doc(id)
          .update({
        'online': value,
      });
      emit(ScChangeDoctorOnline());
    } catch (e) {
      print('change Doctor Online $e');
      emit(ErorrChangeDoctorOnline(e.toString()));
    }
  }

  Future<void> addImageSub(
      {required String type,
      required String userId,
      required File parentImageFile}) async {
    try {
      var parentImageUrl = parentImageFile.path;
      var value = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$userId')
          .putFile(parentImageFile);
      var value2 = await value.ref.getDownloadURL();
      parentImageUrl = value2;
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(type)
          .doc(userId)
          .update({
        'image': parentImageUrl,
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  //MOTHER FUNCTIONS AND DATA FILDES
  List<MotherModel> mothers = [];
  Future<void> getAllMothers() async {
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid.isEmpty
              ? AppPreferences.uId
              : AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .where('docyorlId', isEqualTo: model?.id)
          .get();
      print("value.docs");
      print(value.docs.length);
      for (var element in value.docs) {
        var mother = MotherModel.fromJson(element.data());
        //get mother's doctor
        var value = await FirebaseFirestore.instance
            .collection(AppStrings.hospital)
            .doc(AppPreferences.hospitalUid)
            .collection(AppStrings.doctor)
            .doc(mother.docyorlId)
            .get();
        mother.doctorModel = DoctorModel.fromJson(value.data() ?? {});
        print('mother.doctorModel');
        print(mother.doctorModel);
        mother.babys = [];
        mother.medications = [];
        //get evrey mother medications
        await getMotherMedication(element, mother);

        //get evrey users babys
        await getMotherBabys(element, mother);
        mothers.add(mother);
      }
    } catch (e) {
      print('Get all mothers Data Error: $e');
      emit(ErorrGetHomeData(e.toString()));
    }
  }

  Future<void> getMotherBabys(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      MotherModel mother) async {
    //get evrey users babys
    var babys = await element.reference.collection(AppStrings.baby).get();
    for (var element in babys.docs) {
      var baby = BabieModel.fromJson(element.data());
      baby.doctorModel = mother.doctorModel;
      baby.sleepDetailsModel = [];
      baby.vaccinations = [];
      baby.feedingTimes = [];
      //get   baby DATA
      await getBabyVaccination(element, baby);
      await getSleepBetails(element, baby);
      await getBabyfeedingTimes(element, baby);
      mother.babys!.add(baby);
    }
  }

  Future<void> getMotherMedication(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      MotherModel mother) async {
    //get evrey users medications
    var medications =
        await element.reference.collection(AppStrings.medication).get();
    for (var element in medications.docs) {
      var medication = CurrentMedicationsModel.fromJson(element.data());
      mother.medications!.add(medication);
    }
  }

  //BABY FUNCTIONS AND DATA FILDES
  Future<void> addBaby(
      {required BabieModel model,
      required MotherModel motherModel,
      required File? image}) async {
    try {
      emit(LoadingAddBaby());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherModel.id)
          .collection(AppStrings.baby)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      String? imageUri;
      if (image != null) {
        imageUri = await addBabyImage(
          type: AppStrings.baby,
          userId: model.id ?? '',
          motherId: motherModel.id.orEmpty(),
          parentImageFile: image,
        );
      }
      model.photo = imageUri;
      motherModel.babys!.insert(0, model);
      emit(ScAddBaby());
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddBaby(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddBaby(error.toString()));
      }
      print('Error: $error');
    }
  }

  Future<void> editBaby(
      {required BabieModel model,
      required String motherId,
      required File? image}) async {
    try {
      print(model.toJson());
      emit(LoadingEditBaby());
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(model.id)
          .update(model.toJson());
      String? imageUri;
      if (image != null) {
        imageUri = await addBabyImage(
          type: AppStrings.baby,
          userId: model.id ?? '',
          motherId: motherId,
          parentImageFile: image,
        );
      }
      model.photo = imageUri;
      MotherModel mother =
          (mothers.firstWhere((element) => (element.id == model.motherId)));
      mother.babys!.removeWhere((element) => element.id == model.id);

      print(mother.babys!.length);
      print('mother.babys!.length');
      mother.babys!.insert(0, model);
      print(mother.babys!.length);
      emit(ScEditBaby());
    } catch (error) {
      print('Error: $error');
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrEditBaby(
            'The email address is already in use by another account'));
      }
      print('Error: $error');
      emit(ErorrEditBaby(error.toString()));
    }
  }

  Future<String?> addBabyImage(
      {required String type,
      required String userId,
      required String motherId,
      required File parentImageFile}) async {
    try {
      var parentImageUrl = parentImageFile.path;
      var value = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('photo/$userId')
          .putFile(parentImageFile);
      var value2 = await value.ref.getDownloadURL();
      parentImageUrl = value2;
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(type)
          .doc(userId)
          .update({
        'photo': parentImageUrl,
      });
      return parentImageUrl;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<void> addMedications({
    required CurrentMedicationsModel model,
    required MotherModel motherModel,
  }) async {
    try {
      emit(LoadingAddMedications());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherModel.id.orEmpty())
          .collection(AppStrings.medication)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      await sendNewMedicationNotificationsMother(
          motherModel.id.orEmpty(), model);
      (motherModel.medications ?? []).insert(0, model);
      emit(ScAddMedications());
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddMedications(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddMedications(error.toString()));
      }
      print('Error: $error');
    }
  }

  Future<void> sendNewMedicationNotificationsMother(
      String motherId, CurrentMedicationsModel medicationsModel) async {
    try {
      print('send notfi1');
      print('motherId :$motherId');
      Map<String, dynamic> data = medicationsModel.toJson();
      data.addAll({'type': 'medication'});
      log('go tO medication1');
      log(data.toString());
      sendNotification(
          playerId: motherId,
          message: 'A New Medication',
          dis: 'Medication ${{medicationsModel.name}} added to you',
          data: data);
    } catch (e) {
      print("erorr $e");
    }
  }

  Future<void> addVaccination({
    required VaccinationsHistoriesModel model,
    required String motherId,
    required BabieModel baby,
  }) async {
    try {
      emit(LoadingAddVaccination());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(baby.id)
          .collection(AppStrings.vaccination)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      print(baby.vaccinations!.length);
      print('baby.vaccinations!.length');
      baby.vaccinations!.insert(0, model);
      print(baby.vaccinations!.length);
      emit(ScAddVaccination());
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddVaccination(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddVaccination(error.toString()));
      }
      print('Error: $error');
    }
  }

  Future<void> addFeedingTime({
    required FeedingTimesModel model,
    required String motherId,
    required BabieModel baby,
  }) async {
    try {
      emit(LoadingAddFeedingTime());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(baby.id)
          .collection(AppStrings.feeding)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      print(baby.feedingTimes!.length);
      print('baby.feedingTimes!.length');
      baby.feedingTimes!.insert(0, model);
      print(baby.feedingTimes!.length);
      emit(ScAddFeedingTime());
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddFeedingTime(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddFeedingTime(error.toString()));
      }
      print('Error: $error');
    }
  }

  Future<void> addSleepDetails({
    required SleepDetailsModel model,
    required String motherId,
    required BabieModel baby,
  }) async {
    try {
      emit(LoadingAddSleepDetails());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(baby.id)
          .collection(AppStrings.sleep)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      print(baby.sleepDetailsModel!.length);
      print('baby.sleepDetailsModel!.length');
      baby.sleepDetailsModel!.insert(0, model);
      print(baby.sleepDetailsModel!.length);
      emit(ScAddSleepDetails());
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddSleepDetails(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddSleepDetails(error.toString()));
      }
      print('Error: $error');
    }
  }

  Future<void> getBabyVaccination(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      BabieModel baby) async {
    var vaccinations =
        await element.reference.collection(AppStrings.vaccination).get();
    for (var element in vaccinations.docs) {
      var vaccination = VaccinationsHistoriesModel.fromJson(element.data());
      baby.vaccinations!.add(vaccination);
    }
  }

  Future<void> getBabyfeedingTimes(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      BabieModel baby) async {
    var feedingTimess =
        await element.reference.collection(AppStrings.feeding).get();
    for (var element in feedingTimess.docs) {
      var feedingTimes = FeedingTimesModel.fromJson(element.data());
      baby.feedingTimes!.add(feedingTimes);
    }
  }

  Future<void> getSleepBetails(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      BabieModel baby) async {
    var sleepDetails =
        await element.reference.collection(AppStrings.sleep).get();
    for (var element in sleepDetails.docs) {
      var sleepDetail = SleepDetailsModel.fromJson(element.data());
      baby.sleepDetailsModel!.add(sleepDetail);
    }
  }

  //HOME FUNCTIONS
  Future<void> getHomeData() async {
    mothers = [];
    emit(LoadingGetHomeData());
    try {
      await getAllMothers();
      emit(ScGetHomeData());
    } catch (e) {
      print('Get home Data Error: $e');
      emit(ErorrGetHomeData(e.toString()));
    }
  }

  //CHAT FUNCTIONS AND DATA FILDES
  Future<void> sendMessage(
      {required MessageModel messageModel, File? file}) async {
    try {
      emit(LoadingSendMessage());
      //if message has file upload it to firebase
      if (file != null) {
        messageModel.file = await uploadFile(file);
      }
      //get time as Time stamp
      var time = FieldValue.serverTimestamp();
      Map<String, dynamic> data = messageModel.toMap();
      data.addAll({'timestamp': time});
      //send masage to the doctor
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(AppPreferences.uId)
          .collection(AppStrings.chats)
          .doc(messageModel.motherId)
          .collection(AppStrings.messages)
          .doc();

      data['id'] = value.id;
      await value.set(data);
      //send masage to the mother
      var value1 = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(messageModel.motherId)
          .collection(AppStrings.chats)
          .doc(AppPreferences.uId)
          .collection(AppStrings.messages)
          .doc();

      data['id'] = value1.id;
      await value1.set(data);
      //send Notifications to the MOTHER
      await sendNotificationsMother(messageModel.motherId ?? '');
      emit(ScSendMessage());
    } catch (error) {
      emit(ErorrSendMessage(error.toString()));
      print('Error: $error');
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      emit(LoadingUploadFile());
      var value = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files/${file.path.split('/').last}')
          .putFile(file);
      emit(ScUploadFile());
      return value.ref.getDownloadURL();
    } catch (e) {
      emit(ErorrUploadFile(e.toString()));
      return null;
    }
  }

  List<MessageModel> messages = [];
  Future<void> getMessages({required MotherModel model}) async {
    try {
      messages = [];
      //listen to messages orderd by time stamp
      emit(LoadingGetdMessages());
      FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(AppPreferences.uId)
          .collection(AppStrings.chats)
          .doc(model.id)
          .collection(AppStrings.messages)
          .orderBy('timestamp')
          .snapshots()
          .listen((event) {
        messages = [];
        for (var element in event.docs) {
          MessageModel messageModel = MessageModel.fromJson(element.data());
          messageModel.dateTime =
              (element['timestamp'] as Timestamp).toDate().toLocal().toString();
          messages.add(messageModel);
        }
        emit(ScGetdMessages());
      });
      emit(ScGetdMessages());
    } catch (error) {
      emit(ErorrGetdMessages(error.toString()));
      print('Error: $error');
    }
  }

  Future<void> sendNotificationsMother(String motherId) async {
    try {
      print('send notfi1');
      print('motherId :$motherId');

      Map<String, dynamic> data = model!.toJson();
      data.addAll({'type': 'chat'});
      //send notification to mother with doctor info(sender)
      sendNotification(
          playerId: motherId,
          message: 'A New Message',
          dis: '👋 Doctor ${model!.name ?? ''} sent to you a new message',
          data: data);
    } catch (e) {
      print("erorr $e");
    }
  }
}

bool checkPhone(String phone, List<dynamic>? documents) {
  if (documents == null) {
    return false;
  }
  for (var doc in documents) {
    if (doc.data()?['phone'] == phone) {
      return true;
    }
  }
  return false;
}
