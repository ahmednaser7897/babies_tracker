import 'package:flutter/material.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../app/app_colors.dart';
import '../../app/text_style.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final String text;
  final VoidCallback? onTap;
  final double radius;
  final double height;
  final double fontsize;
  final FontWeight fontweight;
  final Color butcolor;
  final Widget? iconRight;
  final Widget? iconLeft;
  final Color txtcolor;
  const CustomButton({
    required this.text,
    this.height = 6.2,
    this.width = 80,
    this.butcolor = AppColors.primerColor,
    this.fontsize = 12,
    required this.onTap,
    this.radius = 12,
    Key? key,
    this.txtcolor = Colors.white,
    this.fontweight = FontWeight.w600,
    this.iconRight,
    this.iconLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.sp),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(butcolor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius.sp)),
            ),
          ),
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        ),
        onPressed: onTap,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconRight != null) ...[
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    // start: 2.w,
                    end: 2.w,
                  ),
                  child: iconRight,
                ),
              ],
              Text(
                text,
                style: AppTextStyle.getBoldStyle(
                  color: txtcolor,
                  fontSize: fontsize.sp,
                ).copyWith(fontWeight: fontweight),
              ),
              if (iconLeft != null) ...[
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 2.w,
                    end: 2.w,
                  ),
                  child: iconLeft,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
