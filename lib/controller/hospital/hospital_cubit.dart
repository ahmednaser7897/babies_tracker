import 'dart:io';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/doctor_model.dart';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_prefs.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/model/hospital_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../model/babies_model.dart';
import '../../model/current_medications_model.dart';
import '../../model/feeding_times_model.dart';
import '../../model/sleep_details_model.dart';
import '../../model/vaccinations_histories_model.dart';
import '../../ui/hospital/doctors/all_doctors.dart';
import '../../ui/hospital/mother/all_mother.dart';
import '../../ui/hospital/settings_screens/hospitl_settings.dart';
import '../auth/auth_cubit.dart';

part 'hospital_state.dart';

class HospitalCubit extends Cubit<HospitalState> {
  HospitalCubit() : super(HospitalInitial());
  static HospitalCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const AllDoctorsScreen(),
    const AllMothersScreen(),
    const HospitalSettingsScreen(),
  ];
  List titles = [
    AppStrings.doctors,
    AppStrings.mother,
    AppStrings.settings,
  ];
  void changeBottomNavBar(int index) {
    emit(LoadingChangeHomeIndex());
    currentIndex = index;
    emit(ScChangeHomeIndex());
  }

  HospitalModel? hospitalModel;
  Future<void> getCurrentHospitalData() async {
    emit(LoadingGetHospital());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .get();
      hospitalModel = HospitalModel.fromJson(value.data() ?? {});
      changeHospitalOnline(hospitalModel!.id ?? '', true);
      //saveFvmToken(hospitalModel!.id ?? '');
      emit(ScGetHospital());
    } catch (e) {
      print('Get Hospital Data Error: $e');
      emit(ErorrGetHospital(e.toString()));
    }
  }

  Future<void> editHospital(
      {required HospitalModel model, required File? image}) async {
    try {
      emit(LoadingEditHospital());
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (model.phone != hospitalModel!.phone) {
        if (checkPhone(model.phone ?? '', value.docs)) {
          emit(ErorrEditHospital('Phone number is already used'));
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
      print('show user');
      print(currentUser);

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: hospitalModel!.email!,
        password: hospitalModel!.password!,
      );

      await currentUser!.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully');
      await currentUser.updatePassword(model.password.orEmpty());
      // await currentUser.verifyBeforeUpdateEmail(model.email.orEmpty());
      // await currentUser.updateEmail(model.email.orEmpty());

      print(model.toJson());
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .update(model.toJson());
      if (image != null) {
        await addImage(
          type: AppStrings.hospital,
          userId: AppPreferences.uId,
          parentImageFile: image,
        );
      }
      emit(ScEditHospital());
      await getCurrentHospitalData();
    } catch (error) {
      print('Error: $error');
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrEditHospital(
            'The email address is already in use by another account'));
      }
      print('Error: $error');
      emit(ErorrEditHospital(error.toString()));
    }
  }

  Future<void> addImage(
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
      print('addGuyImage image');
      print(parentImageUrl);
      await FirebaseFirestore.instance.collection(type).doc(userId).update({
        'image': parentImageUrl,
      });
      print('addImage done');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> addImageSub(
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
          .doc(AppPreferences.uId)
          .collection(type)
          .doc(userId)
          .update({
        'image': parentImageUrl,
      });
      return parentImageUrl;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<void> addDoctor(
      {required DoctorModel model, required File? image}) async {
    try {
      emit(LoadingAddDoctor());
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (checkPhone(model.phone ?? '', value.docs)) {
        emit(ErorrAddDoctor('Phone number is already used'));
        return;
      } else {
        var value1 = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email ?? '',
          password: model.password ?? '',
        );
        FirebaseFirestore.instance
            .collection('phoneNumbers')
            .doc(value1.user!.uid)
            .set({
          'phone': model.phone,
        });
        model.id = value1.user!.uid;
        await FirebaseFirestore.instance
            .collection(AppStrings.hospital)
            .doc(AppPreferences.uId)
            .collection(AppStrings.doctor)
            .doc(value1.user?.uid)
            .set(model.toJson());

        String? imageUri;
        if (image != null) {
          imageUri = await addImageSub(
            type: AppStrings.doctor,
            userId: value1.user!.uid,
            parentImageFile: image,
          );
        }
        setNewDoctor(model, imageUri);
        emit(ScAddDoctor());
      }
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddDoctor(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddDoctor(error.toString()));
      }
      print('Error: $error');
    }
  }

  void setNewDoctor(DoctorModel model, String? imageUri) {
    DoctorModel newDoctor = DoctorModel(
      ban: false,
      email: model.email,
      id: model.id,
      image: imageUri,
      name: model.name,
      online: false,
      password: model.password,
      phone: model.phone,
      bio: model.bio,
      gender: model.gender,
      hospitalId: model.hospitalId,
    );
    doctors.add(newDoctor);
  }

  Future<void> addMother(
      {required MotherModel model, required File? image}) async {
    try {
      emit(LoadingAddMother());
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (checkPhone(model.phone ?? '', value.docs)) {
        emit(ErorrAddMother('Phone number is already used'));
        return;
      } else {
        var value1 = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email ?? '',
          password: model.password ?? '',
        );
        FirebaseFirestore.instance
            .collection('phoneNumbers')
            .doc(value1.user!.uid)
            .set({
          'phone': model.phone,
        });
        model.id = value1.user!.uid;
        await FirebaseFirestore.instance
            .collection(AppStrings.hospital)
            .doc(AppPreferences.uId)
            .collection(AppStrings.mother)
            .doc(value1.user?.uid)
            .set(model.toJson());
        String? imageUri;
        if (image != null) {
          imageUri = await addImageSub(
            type: AppStrings.mother,
            userId: value1.user!.uid,
            parentImageFile: image,
          );
        }
        setNewMother(model, imageUri);
        emit(ScAddMother());
      }
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddMother(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddDoctor(error.toString()));
      }
      print('Error: $error');
    }
  }

  void setNewMother(MotherModel model, String? imageUri) {
    MotherModel newMother = MotherModel(
      ban: false,
      email: model.email,
      id: model.id,
      image: imageUri,
      name: model.name,
      online: false,
      password: model.password,
      phone: model.phone,
      hospitalId: model.hospitalId,
      address: model.address,
      doctorNotes: model.docyorlId,
      docyorlId: model.docyorlId,
      healthyHistory: model.healthyHistory,
      leaft: false,
      postpartumHealth: model.postpartumHealth,
    );
    newMother.doctorModel =
        doctors.firstWhere((element) => element.id == newMother.docyorlId);
    mothers.add(newMother);
  }

  Future<void> changeMotherLeft(MotherModel model, bool value) async {
    emit(LoadingChangeMotherLeft());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .collection(AppStrings.mother)
          .doc(model.id)
          .update({
        'leaft': value,
      });
      model.leaft = value;
      emit(ScChangeMotherLeft());
    } catch (e) {
      print('change Mother Left $e');
      emit(ErorrChangeMotherLeft(e.toString()));
    }
  }

  Future<void> changeBabyLeft(BabieModel model, bool value) async {
    emit(LoadingChangeBabyLeft());
    print(model.id);
    print(model.motherId);
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .collection(AppStrings.mother)
          .doc(model.motherId)
          .collection(AppStrings.baby)
          .doc(model.id)
          .update({
        'left': value,
      });
      model.left = value;
      emit(ScChangeBabyLeft());
    } catch (e) {
      print('change Baby Left $e');
      emit(ErorrChangeBabyLeft(e.toString()));
    }
  }

  List<DoctorModel> doctors = [];
  Future<void> getAllDoctors() async {
    emit(LoadingGetHospital());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid.isEmpty
              ? AppPreferences.uId
              : AppPreferences.hospitalUid)
          .collection(AppStrings.doctor)
          .get();

      for (var element in value.docs) {
        var doctor = DoctorModel.fromJson(element.data());

        doctors.add(doctor);
      }
      emit(ScGetHospital());
    } catch (e) {
      print('Get all Doctors1 Data Error: $e');
      emit(ErorrGetHospital(e.toString()));
    }
  }

  List<MotherModel> mothers = [];
  Future<void> getAllMothers() async {
    emit(LoadingGetHospital());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.hospitalUid.isEmpty
              ? AppPreferences.uId
              : AppPreferences.hospitalUid)
          .collection(AppStrings.mother)
          .get();

      for (var element in value.docs) {
        var mother = MotherModel.fromJson(element.data());
        mother.doctorModel =
            doctors.firstWhere((element) => element.id == mother.docyorlId);
        //get evrey mother baby
        var bays = await element.reference.collection(AppStrings.baby).get();
        mother.medications = [];
        //get evrey users medications
        await getMotherMedication(element, mother);
        mother.babys = [];
        for (var element in bays.docs) {
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
        mothers.add(mother);
      }
      emit(ScGetHospital());
    } catch (e) {
      print('Get all mothers1 Data Error: $e');
      emit(ErorrGetHospital(e.toString()));
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

  Future<void> getHomeData() async {
    mothers = [];
    doctors = [];
    emit(LoadingGetHomeData());
    try {
      await getAllDoctors();
      await getAllMothers();
      emit(ScGetHomeData());
    } catch (e) {
      print('Get home Data Error: $e');
      emit(ErorrGetHomeData(e.toString()));
    }
  }

  Future<void> changeDoctorBan(String doctorId, bool value) async {
    emit(LoadingChangeDoctorBan());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .collection(AppStrings.doctor)
          .doc(doctorId)
          .update({
        'ban': value,
      });
      emit(ScChangeDoctorBan());
    } catch (e) {
      print('change Doctor Ban $e');
      emit(ErorrChangeDoctorBan(e.toString()));
    }
  }

  Future<void> changeMotherBan(String id, bool value) async {
    emit(LoadingChangeMotherBan());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(AppPreferences.uId)
          .collection(AppStrings.mother)
          .doc(id)
          .update({
        'ban': value,
      });
      emit(ScChangeMotherBan());
    } catch (e) {
      print('change Mother Ban $e');
      emit(ErorrChangeMotherBan(e.toString()));
    }
  }

  Future<void> changeHospitalOnline(String hospitalId, bool value) async {
    emit(LoadingChangeHospitalOnline());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(hospitalId)
          .update({
        'online': value,
      });
      emit(ScChangeHospitalOnline());
    } catch (e) {
      print('change Hospital Online $e');
      emit(ErorrChangeHospitalOnline(e.toString()));
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
