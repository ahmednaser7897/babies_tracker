// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_colors.dart';

class TextFormFiledComponent extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  bool obscureText;
  final FormFieldValidator<String>? validate;

  TextFormFiledComponent({
    super.key,
    this.controller,
    this.keyboardType,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    required this.validate,
  });

  @override
  State<TextFormFiledComponent> createState() => _TextFormFiledComponentState();
}

class _TextFormFiledComponentState extends State<TextFormFiledComponent> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: widget.validate,
      cursorColor: Theme.of(context).primaryColor,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hintText,
        hintStyle:
            TextStyle(color: Colors.grey[400], fontSize: 16.0, height: 1.0),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: 20.0,
                color: AppColors.primerColor.withOpacity(0.7),
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
                icon: Icon(
                  widget.obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primer,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primerColor.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
