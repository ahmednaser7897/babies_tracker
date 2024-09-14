import 'package:babies_tracker/app/app_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_prefs.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app/bloc_observer.dart';

import 'my_app.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await AppPreferences.init();
  await Firebase.initializeApp();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(AppStrings.oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
