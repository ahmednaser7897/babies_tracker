import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:babies_tracker/app/extensions.dart';

class CustomDialog extends StatelessWidget {
  final Widget dialogContent;

  const CustomDialog({Key? key, required this.dialogContent}) : super(key: key);

  static Future<dynamic> show(
      {required BuildContext context, required Widget dialogContent}) async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomDialog(
              dialogContent: dialogContent,
            ));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
    );
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: dialogContent);
  }
}
