import 'dart:convert';

import '../app_strings.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotification(
    {required String playerId,
    required String message,
    required String dis,
    required Map<String, dynamic> data}) async {
  String oneSignalAppId =
      AppStrings.oneSignalAppId; // Replace with your OneSignal App ID
  String oneSignalApiKey =
      AppStrings.oneSignalApiKey; // Replace with your OneSignal REST API Key

  final url = Uri.parse('https://onesignal.com/api/v1/notifications');
  final headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': 'Basic $oneSignalApiKey',
  };
  final body = jsonEncode({
    "app_id": oneSignalAppId,
    "include_aliases": {
      "external_id": [playerId]
    },
    "target_channel": "push",
    "headings": {"en": message},
    'data': data,
    "contents": {
      "en": dis,
    }
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print('Notification sent successfully.');
  } else {
    print('Failed to send notification: ${response.body}');
  }
  //https://youtu.be/v2BzkbCC8CM?si=Blunqz89Kvcb85zm
  /**
      Select Your App:
      Once logged in, you will see a dashboard listing your apps. Click on the app for which you want to find the REST API Key.
      Navigate to Settings:

      In the left-hand sidebar, find and click on "Settings".
      Go to the "Keys & IDs" Section:

      Under the "Settings" menu, click on "Keys & IDs".
      Find the REST API Key:

      In the "Keys & IDs" section, you will find the "REST API Key". This key is used for server-side requests to the OneSignal API.

      The page will display both the "REST API Key" and the "App ID". You will use the REST API Key for making API requests to OneSignal.
     */
}
