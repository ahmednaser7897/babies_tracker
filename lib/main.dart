import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('87259bef-e9d0-4ca8-88ab-6c4fb5360d2c');
  OneSignal.Notifications.requestPermission(true);

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
