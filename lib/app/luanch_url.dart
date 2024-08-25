import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/componnents/show_flutter_toast.dart';

void launchURLFunction(String website) async {
  try {
    final Uri parsedUri = Uri.parse(website);
    print(parsedUri);
    if (!await launchUrl(parsedUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $parsedUri');
    }
  } catch (e) {
    showFlutterToast(
      message: "link is not working",
      toastColor: Colors.red,
    );
    print("launchURLFunction erorr $e");
  }
}
