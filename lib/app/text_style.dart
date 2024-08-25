import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'extensions.dart';

class AppTextStyle {
  static const String mainArFont = 'bank';

  static TextStyle get hintTextStyle => TextStyle(
      fontSize: 10.0.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.textFieldHintColor);

  static TextStyle get hintSmallTextStyle => TextStyle(
      fontSize: 10.0.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.textFieldHintColor);

  static TextStyle get headline1 =>
      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold);

  static TextStyle get headline2 =>
      TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.bold);

  static TextStyle get appBarTitleStyle =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);

  static TextStyle get tabBarLabel => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: mainArFont);

  static TextStyle get normal =>
      TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w600, height: 1.5);

  static TextStyle get listTextStyle =>
      TextStyle(fontSize: 8.5.sp, fontWeight: FontWeight.w600);

  static TextStyle getTextStyle(
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  ) {
    return TextStyle(
        fontSize: fontSize,
        fontFamily: mainArFont,
        color: color ?? AppColors.primer,
        height: 1.2,
        fontWeight: fontWeight);
  }

// regular style

  static TextStyle getRegularStyle(
      {double fontSize = 12, required Color color, double height = 1.2}) {
    return getTextStyle(fontSize, FontWeight.w400, color);
  }

// bold style

  static TextStyle getBoldStyle({double fontSize = 12, required Color color}) {
    return getTextStyle(fontSize, FontWeight.w800, color);
  }
}
