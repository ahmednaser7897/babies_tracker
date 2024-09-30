// ignore_for_file: avoid_print

import 'dart:io';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/mother/mother_state.dart';
import 'package:babies_tracker/model/doctor/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_prefs.dart';
import 'package:babies_tracker/model/mother/mother_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../app/notification/onesignal_notifications.dart';
import '../../model/baby/babies_model.dart';
import '../../model/mother/current_medications_model.dart';
import '../../model/baby/feeding_times_model.dart';
import '../../model/chat/message_model.dart';
import '../../model/baby/sleep_details_model.dart';
import '../../model/baby/vaccinations_histories_model.dart';
import '../../view/hospital/doctors/show_all_doctors.dart';
import '../../view/mother/baby/show_my_baybs.dart';
import '../../view/mother/settings_screens/mother_settings.dart';

class MotherCubit extends Cubit<MotherState> {
  MotherCubit() : super(MotherInitial());
  static MotherCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const ShowAllDoctorsScreen(),
    const ShowMyBabys(),
    const MotherSettingsScreen(),
  ];
  List titles = [
    AppStrings.doctors,
    AppStrings.babys,
    AppStrings.settings,
  ];
  void changeBottomNavBar(int index) {
    emit(LoadingChangeHomeIndex());
    currentIndex = index;
    emit(ScChangeHomeIndex());
  }

  //MOTHER FUNCTIONS AND DATA FILDES
  MotherModel? model;
  Future<void> getCurrentMotherData() async {
    emit(LoadingGetMother());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(AppPreferences.uId)
          .get();

      model = MotherModel.fromJson(value.data() ?? {});
      changeMotherOnline(model!.id ?? '', AppPreferences.hospitalUid, true);
      //get mother's doctor
      var doctor = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(model!.docyorlId)
          .get();
      model!.doctorModel = DoctorModel.fromJson(doctor.data() ?? {});

      model!.babys = [];
      model!.medications = [];
      //get evrey users medications
      await getMotherMedication(model!);

      //get evrey users babys
      await getMotherBabys(model!);

      emit(ScGetMother());
    } catch (e) {
      print('Get Mother Data Error: $e');
      emit(ErorrGetMother(e.toString()));
    }
  }

  Future<void> editMother(
      {required MotherModel model, required File? image}) async {
    try {
      emit(LoadingEditMother());
      //check if the new phone number is not used
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (model.phone != model.phone) {
        if (checkPhone(model.phone ?? '', value.docs)) {
          emit(ErorrEditMother('Phone number is already used'));
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
        email: this.model!.email!,
        password: this.model!.password!,
      );

      await currentUser!.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully');
      await currentUser.updatePassword(model.password ?? '');
      print(model.toJson());
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(AppPreferences.uId)
          .update(model.toJson());
      if (image != null) {
        await addImageSub(
          type: AppStrings.mother,
          userId: AppPreferences.uId,
          parentImageFile: image,
        );
      }
      emit(ScEditMother());
      await getCurrentMotherData();
    } catch (error) {
      print('Error: $error');
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrEditMother(
            'The email address is already in use by another account'));
      }
      print('Error: $error');
      emit(ErorrEditMother(error.toString()));
    }
  }

  Future<void> changeMotherOnline(
      String id, String hospitalUid, bool value) async {
    emit(LoadingChangeMotherOnline());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(AppPreferences.uId)
          .update({
        'online': value,
      });
      emit(ScChangeMotherOnline());
    } catch (e) {
      print('change Mother Online $e');
      emit(ErorrChangeMotherOnline(e.toString()));
    }
  }

  Future<void> getMotherMedication(MotherModel mother) async {
    var medications = await FirebaseFirestore.instance
        .collection(AppStrings.hospital)
        .doc(AppPreferences.hospitalUid)
        .collection(AppStrings.mother)
        .doc(AppPreferences.uId)
        .collection(AppStrings.medication)
        .get();

    //get evrey users medications
    for (var element in medications.docs) {
      var medication = CurrentMedicationsModel.fromJson(element.data());
      mother.medications!.add(medication);
    }
  }

  Future<void> getMotherBabys(MotherModel mother) async {
    var babys = await FirebaseFirestore.instance
        .collection(AppStrings.hospital)
        .doc(AppPreferences.hospitalUid)
        .collection(AppStrings.mother)
        .doc(AppPreferences.uId)
        .collection(AppStrings.baby)
        .get();
    //get evrey users babys

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

  //BABY FUNCTIONS AND DATA FILDES
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

  //HOME FUNCTIONS
  Future<void> getHomeData() async {
    emit(LoadingGetHomeData());
    try {
      await getCurrentMotherData();

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
      //send masage to the MOTHER
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(AppPreferences.uId)
          .collection(AppStrings.chats)
          .doc(messageModel.doctorId)
          .collection(AppStrings.messages)
          .doc();
      data['id'] = value.id;
      await value.set(data);
      //send masage to the doctor
      var value1 = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(messageModel.doctorId)
          .collection(AppStrings.chats)
          .doc(AppPreferences.uId)
          .collection(AppStrings.messages)
          .doc();
      data['id'] = value1.id;
      await value1.set(data);
      //send Notifications to the doctor
      await sendNotificationsToDoctor(messageModel.doctorId ?? '');
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
  Future<void> getMessages({required DoctorModel model}) async {
    try {
      messages = [];
      emit(LoadingGetdMessages());
      //listen to messages orderd by time stamp
      FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(AppPreferences.uId)
          .collection(AppStrings.chats)
          .doc(model.id)
          .collection(AppStrings.messages)
          .orderBy('timestamp')
          .snapshots()
          .listen((event) {
        messages = [];
        for (var element in event.docs) {
          // print('element[type]');
          // print(element['message']);
          // print(element['timestamp']);

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

  Future<void> sendNotificationsToDoctor(String docId) async {
    try {
      print('send notfi1');
      print('docId :${docId}');
      Map<String, dynamic> data = {
        'id': model!.id,
        'name': model!.name,
        'email': model!.email,
        'image': model!.image
      };
      data.addAll({'type': 'chat'});
      //send notification to mother with MOTHER info(sender)
      sendNotification(
          playerId: docId,
          message: 'A New Message',
          dis: '👋 Mother ${model!.name ?? ''} sent to you a new message',
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
