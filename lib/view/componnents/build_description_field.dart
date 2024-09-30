import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildDescriptionTextFiled extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefix;
  final IconData? suffix;
  final TextInputType? keyboardType;
  bool isPassword = false;
  bool isEnable = true;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validate;
  BuildDescriptionTextFiled({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.isEnable = true,
    this.onChanged,
    this.validate,
  });

  @override
  State<BuildDescriptionTextFiled> createState() =>
      _BuildDescriptionTextFiledState();
}

class _BuildDescriptionTextFiledState extends State<BuildDescriptionTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 2,
      maxLines: 8,
      enabled: widget.isEnable,
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
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
