import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/app_colors.dart';

class AppTextFormFiledWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? prefix;
  final IconData? suffix;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final Function()? onTap;
  bool isPassword = false;
  final bool isEnable;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validate;
  AppTextFormFiledWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.isEnable = true,
    this.validate,
  });

  @override
  State<AppTextFormFiledWidget> createState() => _AppTextFormFiledWidgetState();
}

class _AppTextFormFiledWidgetState extends State<AppTextFormFiledWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnable,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      validator: widget.validate,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword,
      style: GoogleFonts.almarai(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(14.0),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.almarai(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.black45,
        ),
        filled: true,
        prefixIcon: widget.prefix != null
            ? Icon(
                widget.prefix,
                size: 18,
                color: AppColors.primerColor,
              )
            : null,
        suffixIcon: widget.suffix != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.isPassword = !widget.isPassword;
                  });
                },
                icon: Icon(
                  widget.isPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primerColor,
                  size: 20,
                ),
              )
            : null,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: AppColors.primerColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
