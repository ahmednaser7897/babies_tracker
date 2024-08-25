import 'package:babies_tracker/app/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_prefs.dart';
import '../../model/tokens_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  //TokensModel? tokenModel;
  String userId = '';
  //login function that check this email type and login as this type
  void login({required String email, required String password}) async {
    emit(AuthGetUserAfterLoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      userId = value.user!.uid;
      print('on log in');
      print(AppPreferences.uId);
      print(AppPreferences.userType);
      //check this user type
      await getUserType(userId);
    }).catchError((error) {
      catchError(error);
      return;
    });
  }

  Future<void> getUserType(String userId) async {
    try {
      if (userId != '') {
        //save token to firebase to send notifications
        await saveFvmToken(userId);
        if (await isAdmin(userId)) {
          userId = '';
          print('User is an admin😎');
          AppPreferences.userType = AppStrings.admin;
          emit(AuthGetUserAfterLoginSuccessState(message: AppStrings.admin));
        } else if (await isHospital(userId)) {
          userId = '';
          print('User is a hospital');
          AppPreferences.userType = AppStrings.hospital;
          emit(AuthGetUserAfterLoginSuccessState(message: AppStrings.hospital));
        } else if (await isMother(userId)) {
          userId = '';
          print('User is a moter');
          AppPreferences.userType = AppStrings.mother;
          emit(AuthGetUserAfterLoginSuccessState(message: AppStrings.mother));
        } else if (await isDoctor(userId)) {
          AppPreferences.userType = AppStrings.doctor;
          emit(AuthGetUserAfterLoginSuccessState(message: AppStrings.doctor));
          userId = '';
          print('User is a doctor');
        }
      } else {
        emit(AuthGetUserAfterLoginErrorState(error: 'invalid account'));
        userId = '';
        print('User is not found😎');
      }
    } catch (e) {
      print('erorr getUserType $e');
    }
  }

  void catchError(error) {
    if (error.code.toString().contains('INVALID_LOGIN_CREDENTIALS')) {
      emit(AuthGetUserAfterLoginErrorState(
          error: 'invalid user name or password'));
      return;
    } else if (error
        .toString()
        .contains('The supplied auth credential is incorrect')) {
      emit(AuthGetUserAfterLoginErrorState(error: 'Invalid Email or password'));
      return;
    } else if (error.code == 'user-not-found') {
      emit(AuthGetUserAfterLoginErrorState(
          error: 'No user found for that email.'));
      return;
    } else if (error.code == 'wrong-password') {
      emit(AuthGetUserAfterLoginErrorState(error: 'Invalid Password'));
      return;
    } else if (error.code == 'invalid-email') {
      emit(AuthGetUserAfterLoginErrorState(error: 'Invalid Email'));
      return;
    } else if (error.code == 'user-disabled') {
      emit(AuthGetUserAfterLoginErrorState(error: 'User is disabled'));
      return;
    } else if (error.code == 'too-many-requests') {
      emit(AuthGetUserAfterLoginErrorState(
          error: 'Too many requests. Try again later.'));
      return;
    } else {
      print(error.message);
      emit(AuthGetUserAfterLoginErrorState(error: error.message));
      return;
    }
  }

  Future<bool> isAdmin(String userId) async {
    print('check if user admin');
    final adminRef =
        FirebaseFirestore.instance.collection(AppStrings.admin).doc(userId);
    final adminDocExit = await adminRef.get().then((value) => value.exists);
    final adminDoc = await adminRef.get();
    //check if this admin baned
    if (adminDocExit == true) {
      if (adminDoc.data()!['ban']) {
        emit(AuthGetUserAfterLoginErrorState(error: 'Admin is banned'));
        return false;
      } else {
        AppPreferences.userType = AppStrings.admin;
        AppPreferences.uId = userId;
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> isHospital(String userId) async {
    final parentRef =
        FirebaseFirestore.instance.collection(AppStrings.hospital).doc(userId);
    final parentDocExit = await parentRef.get().then((value) => value.exists);
    final parentDoc = await parentRef.get();
    if (parentDocExit) {
      //check if this hospital baned
      if (parentDoc.data()!['ban']) {
        emit(AuthGetUserAfterLoginErrorState(error: 'hospital is banned'));
        return false;
      } else {
        AppPreferences.userType = AppStrings.hospital;
        AppPreferences.uId = userId;
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> isMother(String userId) async {
    final hospitalsQuerySnapshot =
        await FirebaseFirestore.instance.collection(AppStrings.hospital).get();
    for (final hospitals in hospitalsQuerySnapshot.docs) {
      final coachRef =
          hospitals.reference.collection(AppStrings.mother).doc(userId);
      final coachDocExit = await coachRef.get().then((value) => value.exists);
      final coachDoc = await coachRef.get();
      if (coachDocExit == true) {
        //check if this coach is baned
        if (coachDoc.data()!['ban']) {
          emit(AuthGetUserAfterLoginErrorState(error: 'mother is banned'));
          return false;
        } else {
          //check if this coachs hospital is baned
          if (hospitals.data()['ban']) {
            emit(AuthGetUserAfterLoginErrorState(error: 'hospital is banned'));
            return false;
          } else {
            AppPreferences.userType = AppStrings.mother;
            AppPreferences.uId = userId;
            AppPreferences.hospitalUid = hospitals.id;
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<bool> isDoctor(String userId) async {
    final hospitalsQuerySnapshot =
        await FirebaseFirestore.instance.collection(AppStrings.hospital).get();
    for (final hospitals in hospitalsQuerySnapshot.docs) {
      final doctorRef =
          hospitals.reference.collection(AppStrings.doctor).doc(userId);
      final doctorDocExit = await doctorRef.get().then((value) => value.exists);
      final doctorDoc = await doctorRef.get();
      if (doctorDocExit == true) {
        //check if this doctor  is baned
        if (doctorDoc.data()!['ban']) {
          emit(AuthGetUserAfterLoginErrorState(error: 'doctor is banned'));
          return false;
        } else {
          //check if this doctors hospital is baned
          if (hospitals.data()['ban']) {
            emit(AuthGetUserAfterLoginErrorState(error: 'hospital is banned'));
            return false;
          } else {
            AppPreferences.userType = AppStrings.doctor;
            AppPreferences.uId = userId;
            AppPreferences.hospitalUid = hospitals.id;
            return true;
          }
        }
      }
    }
    return false;
  }
}

Future<void> saveFvmToken(String userId) async {
  TokensModel? tokenModel;
  //save token to firebase to send notifications
  var token = await FirebaseMessaging.instance.getToken();
  tokenModel = TokensModel(id: userId, token: token!);
  await FirebaseFirestore.instance.collection('tokens').doc(userId).set(
        tokenModel.toMap(),
      );
}
