import 'package:flutter/material.dart';

import '../my_app.dart';

class AppColors {
  static const Color tabBarSubTitleColor = Color(0xff535353);
  static const Color blackColor = Color(0xff000000);
  static const Color whiteColor = Color(0xffffffff);
  static const Color textFieldHintColor = Color(0xffa9aaad);
  static const Color errorColor = Color(0xFFC80000);
  static const statusBarColorTransparent = Color(0x42000000);
  static const Color background = Color(0xFF1B1B1B);
  static const Color fillColor = Color(0xFF2E2E2E);
  static const Color grayDarkColor = Color(0xFF6E6E6E);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Color.fromRGBO(117, 117, 117, 1);
  static const Color primerColor = Color(0xFFe0185e);
  static const Color primer = Color(0xFFff4f98);

  /// example to how make colors aware of app brightness
  static Color get appBackground =>
      MyApp.isDark ? const Color(0xff1B1B1B) : const Color(0xffffffff);
}
