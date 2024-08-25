import 'dart:convert';
import 'dart:io';

import 'package:babies_tracker/app/app_strings.dart';
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

import '../../model/current_medications_model.dart';
import '../../model/feeding_times_model.dart';
import '../../model/message_model.dart';
import '../../model/sleep_details_model.dart';
import '../../ui/Doctor/settings_screens/Doctor_settings.dart';
import '../../ui/doctor/mother/show_doc_mothers.dart';
import '../../ui/hospital/doctors/all_doctors.dart';
import 'package:http/http.dart' as http;

import '../auth/auth_cubit.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial());
  static DoctorCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const AllDoctorsScreen(),
    const DoctorMothersScreen(),
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

  DoctorModel? model;
  Future<void> getCurrentDoctorData() async {
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
      saveFvmToken(model!.id ?? '');
      getHomeData();
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
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (model.phone != model.phone) {
        if (checkPhone(model.phone ?? '', value.docs)) {
          emit(ErorrEditDoctor('Phone number is already used'));
          return;
        } else {
          await FirebaseFirestore.instance
              .collection('phoneNumbers')
              .doc()
              .update({
            'phone': model.phone,
          });
        }
      }
      User? currentUser = FirebaseAuth.instance.currentUser;
      await currentUser!.updatePassword(model.password ?? '');
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

  Future<void> addBabyImage(
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
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addBaby(
      {required BabieModel model,
      required String motherId,
      required File? image}) async {
    try {
      emit(LoadingAddBaby());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      if (image != null) {
        await addBabyImage(
          type: AppStrings.baby,
          userId: model.id ?? '',
          motherId: motherId,
          parentImageFile: image,
        );
      }
      emit(ScAddBaby());
      await getHomeData();
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
      if (image != null) {
        await addBabyImage(
          type: AppStrings.baby,
          userId: model.id ?? '',
          motherId: motherId,
          parentImageFile: image,
        );
      }
      emit(ScEditBaby());
      await getHomeData();
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

  Future<void> addMedications({
    required CurrentMedicationsModel model,
    required String motherId,
  }) async {
    try {
      emit(LoadingAddMedications());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.medication)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      await sendNotificationsToUser(motherId);
      emit(ScAddMedications());
      await getHomeData();
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

  Future<void> addVaccination({
    required VaccinationsHistoriesModel model,
    required String motherId,
    required String babyId,
  }) async {
    try {
      emit(LoadingAddVaccination());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(babyId)
          .collection(AppStrings.vaccination)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      emit(ScAddVaccination());
      await getHomeData();
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
    required String babyId,
  }) async {
    try {
      emit(LoadingAddFeedingTime());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(babyId)
          .collection(AppStrings.feeding)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      emit(ScAddFeedingTime());
      await getHomeData();
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
    required String babyId,
  }) async {
    try {
      emit(LoadingAddSleepDetails());
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(motherId)
          .collection(AppStrings.baby)
          .doc(babyId)
          .collection(AppStrings.sleep)
          .doc();
      model.id = value.id;
      await value.set(model.toJson());
      emit(ScAddSleepDetails());
      await getHomeData();
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

  List<MotherModel> mothers = [];
  Future<void> getAllMothers() async {
    // try {
    print('mothers');
    print(model!.id);
    var value = await FirebaseFirestore.instance
        .collection(AppStrings.hospital)
        .doc(AppPreferences.hospitalUid.isEmpty
            ? AppPreferences.uId
            : AppPreferences.hospitalUid)
        .collection(AppStrings.mother)
        .where('docyorlId', isEqualTo: model?.id)
        .get();
    for (var element in value.docs) {
      var mother = MotherModel.fromJson(element.data());

      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .collection(AppStrings.doctor)
          .doc(mother.docyorlId)
          .get();
      mother.doctorModel = DoctorModel.fromJson(value.data() ?? {});
      mother.babys = [];
      mother.medications = [];
      //get evrey users medications
      await getMotherMedication(element, mother);

      //get evrey users babys
      await getMotherBabys(element, mother);
      mothers.add(mother);
    }
    // } catch (e) {
    //   print('Get all mothers Data Error: $e');
    //   emit(ErorrGetHomeData(e.toString()));
    // }
  }

  Future<void> getMotherBabys(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      MotherModel mother) async {
    //get evrey users babys
    var babys = await element.reference.collection(AppStrings.baby).get();
    for (var element in babys.docs) {
      var baby = BabieModel.fromJson(element.data());
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

  Future<void> getHomeData() async {
    mothers = [];
    emit(LoadingGetHomeData());
    //try {
    await getAllMothers();

    emit(ScGetHomeData());
    // } catch (e) {
    //   print('Get home Data Error: $e');
    //   emit(ErorrGetHomeData(e.toString()));
    // }
  }

  Future<void> changeDoctorOnline(
      String id, String hospitalUid, bool value) async {
    emit(LoadingChangeDoctorOnline());
    try {
      print("object");
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

  Future<void> sendMessage(
      {required MessageModel messageModel, File? file}) async {
    try {
      emit(LoadingSendMessage());
      if (file != null) {
        messageModel.file = await uploadFile(file);
      }
      var value = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(AppPreferences.uId)
          .collection(AppStrings.chats)
          .doc(messageModel.motherId)
          .collection(AppStrings.messages)
          .doc();
      messageModel.id = value.id;
      await value.set(messageModel.toMap());
      var value1 = FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .doc(messageModel.motherId)
          .collection(AppStrings.chats)
          .doc(AppPreferences.uId)
          .collection(AppStrings.messages)
          .doc();
      messageModel.id = value1.id;
      await value1.set(messageModel.toMap());
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
      emit(LoadingGetdMessages());
      FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .doc(AppPreferences.uId)
          .collection(AppStrings.chats)
          .doc(model.id)
          .collection(AppStrings.messages)
          .orderBy('dateTime')
          .snapshots()
          .listen((event) {
        messages = [];
        for (var element in event.docs) {
          print('element[type]');
          print(element['type']);
          messages.add(MessageModel.fromJson(element.data()));
        }
        emit(ScGetdMessages());
      });
      emit(ScGetdMessages());
    } catch (error) {
      emit(ErorrGetdMessages(error.toString()));
      print('Error: $error');
    }
  }

  Future<void> sendNotificationsToUser(String motherId) async {
    try {
      print('send notfi1');
      print(motherId);
      var tokenDocs =
          await FirebaseFirestore.instance.collection('tokens').get();
      tokenDocs.docs.forEach((element) async {
        if (element.id == motherId) {
          print('send notfi2');
          print(element.id);
          print(element.data()['token']);
          await sendNotificationToUser(element.data()['token']);
        }
      });
    } catch (e) {
      print("erorr $e");
    }
  }

  String authorization =
      'key=BJYTZBRYLZlkE2KMI5LDKQCRZ7ExzZR0Mq2wuX45twU8WxNDs-fr8LAS8G7fp_wNY_J6aOVOeeLLKecSGeZGmTg';
  //"key=AAAAd2vXNyY:fw7DGe96Q_Ginx7elwo5Ol:APA91bEbmscJ1sVSYrvhjJGyItPiXaqCyTXBleNpuENiYbD4QHKDfBqXxf2cNNbLyCQ-jOxxm10zymF8bSF5A1AlayfEvT3aaa6OZhEwl2qziMuJ2PoJ-dNBR4N1tefL10RQru6zXv22";
  Future<void> sendNotificationToUser(String token) async {
    try {
      //String authorization = 'key=AIzaSyChO_upkbv9soEnvDpdB9WrAcVX8-WOH2Y';

      // print('send notfi3');
      // print('end now');
      // //how to get token
      // var a = FirebaseMessaging.instance;
      // await a.requestPermission();
      // var token = await a.getToken();
      // String authorization = 'key=$token';
      // print("token is $token");
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "content-type": "application/json",
          //"Authorization": authorization,
        },
        body: jsonEncode({
          "to": token,
          "notification": {
            "body":
                "👋 A new Medications has been added. Log in to your account to view the details and participate.",
            "title": "New Medications Added"
          },
        }),
      );
    } catch (e) {
      print("erorr $e");
    }
  }
//    void sendMessageToFcmTopic(String token) async {
//    String topicName = "app_promotion";
// var firebaseMessaging= FirebaseMessaging.instance;
//       await firebaseMessaging.requestPermission();
//       var token=await firebaseMessaging.getToken();
//       print(token);
//       await firebaseMessaging.subscribeToTopic(topicName);
//       firebaseMessaging.setAutoInitEnabled(true);
//        await firebaseMessaging.sendMessage(
//         collapseKey: ,
//         data: ,
//         messageId: ,
//         messageType: ,
//         to: ,
//         ttl: ,
//        );

//  }
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
