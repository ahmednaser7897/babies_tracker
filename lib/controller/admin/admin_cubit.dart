import 'dart:io';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/doctor_model.dart';
import 'package:babies_tracker/model/hospital_model.dart';
import 'package:babies_tracker/ui/admin/hospitels_screen/admin_hospitels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_prefs.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/model/admin_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../ui/admin/admins/admins_home.dart';
import '../../ui/admin/settings_screens/admin_settings.dart';
import '../auth/auth_cubit.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());
  static AdminCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const AdminsHome(),
    const AdminGyms(),
    const AdminSettingsScreen(),
  ];
  List titles = [
    AppStrings.admins,
    AppStrings.hospitals,
    AppStrings.settings,
  ];
  void changeBottomNavBar(int index) {
    emit(LoadingChangeHomeIndex());
    currentIndex = index;
    emit(ScChangeHomeIndex());
  }

  AdminModel? adminModel;
  Future<void> getCurrentAdminData() async {
    emit(LoadingGetAdmin());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.admin)
          .doc(AppPreferences.uId)
          .get();
      adminModel = AdminModel.fromJson(value.data() ?? {});
      changeAdminOnline(adminModel!.id ?? '', true);
      saveFvmToken(adminModel!.id ?? '');
      emit(ScGetAdmin());
    } catch (e) {
      print('Get admin Data Error: $e');
      emit(ErorrGetAdmin(e.toString()));
    }
  }

  Future<void> addAdmin(
      {required AdminModel model, required File? image}) async {
    try {
      emit(LoadingAddAdmin());
      //check if the new phone number is not used
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (checkPhone(model.phone ?? '', value.docs)) {
        emit(ErorrAddAdmin('Phone number is already used'));
        return;
      } else {
        var value1 = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email ?? '',
          password: model.password ?? '',
        );
        //save the number in firebase
        await FirebaseFirestore.instance
            .collection('phoneNumbers')
            .doc(value1.user!.uid)
            .set({
          'phone': model.phone,
        });
        model.id = value1.user!.uid;
        await FirebaseFirestore.instance
            .collection(AppStrings.admin)
            .doc(value1.user?.uid)
            .set(model.toJson());
        String? imageUri;
        if (image != null) {
          //return the image link to use it(if it is exists)
          imageUri = await addImage(
            type: AppStrings.admin,
            userId: value1.user!.uid,
            parentImageFile: image,
          );
        }
        //save this admin in the list of admins
        setNewAdmin(model, imageUri);
        emit(ScAddAdmin());
      }
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddAdmin(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddAdmin(error.toString()));
      }
      print('Error: $error');
    }
  }

  void setNewAdmin(AdminModel model, String? imageUri) {
    AdminModel newAdmin = AdminModel(
        ban: false,
        createdAt: model.createdAt,
        email: model.email,
        gender: model.gender,
        id: model.id,
        image: imageUri,
        name: model.name,
        online: false,
        password: model.password,
        phone: model.phone);
    admins.add(newAdmin);
  }

  Future<void> editAdmin(
      {required AdminModel model, required File? image}) async {
    try {
      emit(LoadingEditAdmin());
      User? currentUser = FirebaseAuth.instance.currentUser;
      //check if the new phone number is not used
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (model.phone != adminModel!.phone) {
        if (checkPhone(model.phone ?? '', value.docs)) {
          emit(ErorrEditAdmin('Phone number is already used'));
          return;
        } else {
          //save the number in firebas
          await FirebaseFirestore.instance
              .collection('phoneNumbers')
              .doc(AppPreferences.uId)
              .update({
            'phone': model.phone,
          });
        }
      }
      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: adminModel!.email!,
        password: adminModel!.password!,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully');
      await currentUser.updatePassword(model.password.orEmpty());
      print(model.toJson());
      await FirebaseFirestore.instance
          .collection(AppStrings.admin)
          .doc(AppPreferences.uId)
          .update(model.toJson());
      if (image != null) {
        await addImage(
          type: AppStrings.admin,
          userId: AppPreferences.uId,
          parentImageFile: image,
        );
      }
      emit(ScEditAdmin());
      await getCurrentAdminData();
    } catch (error) {
      print('Error: $error');
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrEditAdmin(
            'The email address is already in use by another account'));
      }
      print('Error: $error');
      emit(ErorrEditAdmin(error.toString()));
    }
  }

  Future<String?> addImage(
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
      return parentImageUrl;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  List<AdminModel> admins = [];
  Future<void> getAllAdmins() async {
    try {
      var value =
          await FirebaseFirestore.instance.collection(AppStrings.admin).get();
      for (var element in value.docs) {
        if (element.id == AppPreferences.uId) {
          continue;
        }

        admins.add(AdminModel.fromJson(element.data()));
      }
    } catch (e) {
      print('Get all admins Data Error: $e');
    }
  }

  Future<void> addHospital(
      {required HospitalModel model, required File? image}) async {
    try {
      emit(LoadingAddHospital());
      //check if the new phone number is not used
      var value =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (checkPhone(model.phone ?? '', value.docs)) {
        emit(ErorrAddHospital('Phone number is already used'));
        return;
      } else {
        var value1 = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email ?? '',
          password: model.password ?? '',
        );
        //save the number in firebase
        FirebaseFirestore.instance
            .collection('phoneNumbers')
            .doc(value1.user!.uid)
            .set({
          'phone': model.phone,
        });
        model.id = value1.user!.uid;
        await FirebaseFirestore.instance
            .collection(AppStrings.hospital)
            .doc(value1.user?.uid)
            .set(model.toJson());
        String? imageUri;
        if (image != null) {
          imageUri = await addImage(
            type: AppStrings.hospital,
            userId: value1.user!.uid,
            parentImageFile: image,
          );
        }
        //save this hospital in the list of hospitals
        setNewHospital(model, imageUri);
        emit(ScAddHospital());
      }
    } catch (error) {
      if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        emit(ErorrAddHospital(
            'The email address is already in use by another account'));
      } else {
        emit(ErorrAddHospital(error.toString()));
      }
      print('Error: $error');
    }
  }

  void setNewHospital(HospitalModel model, String? imageUri) {
    HospitalModel newHospital = HospitalModel(
      ban: false,
      email: model.email,
      id: model.id,
      image: imageUri,
      name: model.name,
      online: false,
      password: model.password,
      phone: model.phone,
      bio: model.bio,
      city: model.city,
      location: model.location,
    );
    hospitals.add(newHospital);
  }

  List<HospitalModel> hospitals = [];
  Future<void> getAllHospitals() async {
    emit(LoadingGetAdmin());
    try {
      var value = await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .get();
      for (var element in value.docs) {
        var hospital = HospitalModel.fromJson(element.data());
        //get evrey Hospitals doctor
        var doctors =
            await element.reference.collection(AppStrings.doctor).get();
        hospital.doctors = [];
        for (var element in doctors.docs) {
          hospital.doctors!.add(DoctorModel.fromJson(element.data()));
        }
        hospitals.add(hospital);
      }
      emit(ScGetAdmin());
    } catch (e) {
      print('Get all Hospitals Data Error: $e');
      emit(ErorrGetAdmin(e.toString()));
    }
  }

  Future<void> getHomeData() async {
    admins = [];
    hospitals = [];
    emit(LoadingGetHomeData());
    try {
      await getAllAdmins();
      await getAllHospitals();
      emit(ScGetHomeData());
    } catch (e) {
      print('Get home Data Error: $e');
      emit(ErorrGetHomeData(e.toString()));
    }
  }

  Future<void> changeHospitalBan(String hospitalId, bool value) async {
    emit(LoadingChangeHospitalBan());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.hospital)
          .doc(hospitalId)
          .update({
        'ban': value,
      });
      emit(ScChangeHospitalBan());
    } catch (e) {
      print('change Hospital Ban $e');
      emit(ErorrChangeHospitalBan(e.toString()));
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

  Future<void> changeAdminBan(String adminId, bool value) async {
    emit(LoadingChangeAdminBan());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.admin)
          .doc(adminId)
          .update({
        'ban': value,
      });
      emit(ScChangeAdminBan());
    } catch (e) {
      print('change Admin Ban $e');
      emit(ErorrChangeAdminBan(e.toString()));
    }
  }

  Future<void> changeAdminOnline(String adminId, bool value) async {
    emit(LoadingChangeAdminOnline());
    try {
      await FirebaseFirestore.instance
          .collection(AppStrings.admin)
          .doc(adminId)
          .update({
        'online': value,
      });
      emit(ScChangeAdminOnline());
    } catch (e) {
      print('change Admin Online $e');
      emit(ErorrChangeAdminOnline(e.toString()));
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
