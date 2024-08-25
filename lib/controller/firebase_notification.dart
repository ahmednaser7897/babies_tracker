// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// class NotificationHelper {
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const IOSInitializationSettings();
//     var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationsSettings);
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
//     String _title;
//     String _body;
//     String _orderID;
//     String? _image;
//     if (data) {
//       _title = message.data['title'];
//       _body = message.data['body'];
//       _orderID = message.data['order_id'];
//       _image = (message.data['image'] != null && message.data['image'].isNotEmpty)
//           ? message.data['image'].startsWith('http')
//               ? message.data['image']
//               : ''
//           : null;
//     } else {
//       _title = message.notification!.title!;
//       _body = message.notification!.body!;
//       _orderID = message.notification!.titleLocKey!;
//       if (Platform.isAndroid) {
//         _image = ((message.notification!.android!.imageUrl != null && message.notification!.android!.imageUrl!.isNotEmpty)
//             ? message.notification!.android!.imageUrl!.startsWith('http')
//                 ? message.notification!.android!.imageUrl
//                 : ''
//             : null)!;
//       } else if (Platform.isIOS) {
//         _image = ((message.notification!.apple!.imageUrl != null && message.notification!.apple!.imageUrl!.isNotEmpty)
//             ? message!.notification!.apple!.imageUrl!.startsWith('http')
//                 ? message.notification!.apple!.imageUrl
//                 : ''
//             : null)!;
//       }
//     }

//     if (_image != null && _image.isNotEmpty) {
//       try {
//         await showBigPictureNotificationHiddenLargeIcon(_title, _body, _orderID, _image, fln);
//       } catch (e) {
//         await showBigTextNotification(_title, _body, _orderID, fln);
//       }
//     } else {
//       await showBigTextNotification(_title, _body, _orderID, fln);
//     }
//   }

//   static Future<void> showTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       '6valley_delivery',
//       '6valley_delivery name',
//       playSound: true,
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }

//   static Future<void> showBigTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//       body,
//       htmlFormatBigText: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//     );
//     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       '6valley_delivery channel id',
//       '6valley_delivery name',
//       importance: Importance.max,
//       styleInformation: bigTextStyleInformation,
//       priority: Priority.max,
//       playSound: true,
//       sound: const RawResourceAndroidNotificationSound('notification'),
//     );
//     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }

//   static Future<void> showBigPictureNotificationHiddenLargeIcon(
//       String title, String body, String orderID, String image, FlutterLocalNotificationsPlugin fln) async {
//     final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
//     final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       hideExpandedLargeIcon: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//       summaryText: body,
//       htmlFormatSummaryText: true,
//     );
//     final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       '6valley_delivery',
//       '6valley_delivery name',
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       priority: Priority.max,
//       playSound: true,
//       styleInformation: bigPictureStyleInformation,
//       importance: Importance.