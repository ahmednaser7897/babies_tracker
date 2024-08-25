// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HandleLocalNotification {
  static var buildContext;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeFlutterNotification(context) {
    buildContext = context;

    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/launcher_icon");
    var initSetttings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        onSelectNotification(details);
      },
    );
    backgroundClick();
  }

  void backgroundClick() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      if (notificationAppLaunchDetails!.notificationResponse != null) {
        print(
            'here${notificationAppLaunchDetails.notificationResponse?.payload}');

        await Future.delayed(const Duration(seconds: 1));
        onSelectNotification(
            notificationAppLaunchDetails.notificationResponse!);
      }
    } else {
      if (notificationAppLaunchDetails!.notificationResponse != null) {
        print(
            'here${notificationAppLaunchDetails.notificationResponse?.payload}');
        await Future.delayed(const Duration(seconds: 1));
        onSelectNotification(
            notificationAppLaunchDetails.notificationResponse!);
      }
    }
  }

  static Future<void> onSelectNotification(NotificationResponse details) async {
    try {
      if (details.payload != null) {
        Map notificationModelMap = jsonDecode(details.payload ?? '');
        print(notificationModelMap);
        //Get.to();
        // if (notificationModelMap.isNotEmpty) {
        //   print(Get.currentRoute);
        //   print(notificationModelMap['route_name']);
        //   print(notificationModelMap['id']);
        //   if (Get.currentRoute == notificationModelMap['route_name']) {
        //     Get.back();
        //     Get.toNamed(notificationModelMap['route_name'],
        //         arguments: [notificationModelMap['id']]);
        //   } else {
        //     Get.toNamed(notificationModelMap['route_name'],
        //         arguments: [notificationModelMap['id']]);
        //   }

        // }
      }
    } catch (e) {
      print('onSelectNotification value is ${e.toString()}');
    }

    print(
        "===================Flutter local notification payload ${details.payload}");
  }

  static Future<void> showNotification(
      String title, String body, Map<String, dynamic> data) async {
    log("===================show notification==============");
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: jsonEncode(data));
  }
}
