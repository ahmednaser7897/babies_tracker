
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../my_app.dart';
import 'constants.dart';

extension Sizer on num {

  double  get h {
    var h = MyApp.appContext.height;
    return (this / 100) * h;
  }

  double  get w {
    var w = MyApp.appContext.width;
    return (this / 100) * w;
  }

  double get sp => this * (MyApp.appContext.width / 3) / 100;
}

extension OnContext on BuildContext {
  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }
}


extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}
extension NonNullBool on bool? {
  bool orFalse() {
    if (this == null) {
      return false;
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}
extension NonNullList<T> on List<T>? {
  List<T> orEmpty() {
    if (this == null) {
      return [];
    } else {
      return this!;
    }
  }
}


extension NonNullDouble on double? {
  double orZero() {
    if (this == null) {
      return Constants.zeroDouble;
    } else {
      return this!;
    }
  }
}

extension OnWidget on Widget{
  Widget mPadding(EdgeInsetsGeometry edgeInsets){
    return Padding(padding: edgeInsets,child: this,);
  }
}

extension OnDateTime on DateTime{
  String toStringServerFormat(){
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(this);
}
}

extension OnStringToDateTime on String{
  DateTime dateFromStringServerFormat(){
    return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(this);
}
}

extension OnColor on Color{
  MaterialColor getMaterialColor(){
    return MaterialColor(value, getSwatch());
  }

  Map<int, Color> getSwatch() {
    final hslColor = HSLColor.fromColor(this);
    final lightness = hslColor.lightness;

    /// if [500] is the default color, there are at LEAST five
    /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
    /// divisor of 5 would mean [50] is a lightness of 1.0 or
    /// a color of #ffffff. A value of six would be near white
    /// but not quite.
    final lowDivisor = 6;

    /// if [500] is the default color, there are at LEAST four
    /// steps above [500]. A divisor of 4 would mean [900] is
    /// a lightness of 0.0 or color of #000000
    final highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }
}