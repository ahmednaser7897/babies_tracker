import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_colors.dart';
import 'package:babies_tracker/app/extensions.dart';

class BottomComponent extends StatelessWidget {
  final Widget child;
  final Function? onPressed;
  const BottomComponent({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.primerColor.withOpacity(0.8),
        minimumSize: Size(
          90.w,
          7.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: child,
    );
  }
}
