// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart' as intl;

// import '../../app/app_colors.dart';
// import '../../app/text_style.dart';

// class CustomTextField extends StatefulWidget {
//   final int? max;
//   final int? min;
//   final double? width;
//   final String? Function(String?)? validator;
//   final String? hint;
//   final bool? enable;
//   final bool align;
//   final TextEditingController controller;
//   final Widget? prefix;
//   final Widget? suffixIcon;
//   final TextInputType? type;
//   final VoidCallback? onTapPassword;
//   final void Function(String)? onChange;
//   final void Function(String)? onSaved;
//   final void Function(String)? onFieldSubmitted;
//   final double radius;
//   final double? verticalContentPadding;
//   final double? horizontalContentPadding;
//   final VoidCallback? onTap;
//   final FocusNode? focusNode;
//   final bool readOnly;
//   final TextInputAction? action;
//   const CustomTextField({
//     required this.controller,
//     this.onSaved,
//     this.onFieldSubmitted,
//     this.readOnly = false,
//     this.action,
//     this.enable = true,
//     this.align = true,
//     required this.hint,
//     this.verticalContentPadding,
//     this.horizontalContentPadding,
//     this.max = 1,
//     this.min,
//     this.onChange,
//     required this.type,
//     required this.validator,
//     this.onTapPassword,
//     Key? key,
//     this.prefix,
//     this.onTap,
//     this.radius = 4,
//     this.width,
//     this.suffixIcon,
//     this.focusNode,
//   }) : super(key: key);

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool isRTL(String text) {
//     return intl.Bidi.detectRtlDirectionality(text);
//   }

//   final ValueNotifier<TextDirection> _textDir =
//       ValueNotifier(TextDirection.ltr);
//   late bool showPassword;
//   @override
//   void initState() {
//     super.initState();
//     bool isR = isRTL(widget.controller.text);
//     if (isR) {
//       _textDir.value = TextDirection.rtl;
//     } else {
//       _textDir.value = TextDirection.ltr;
//     }

//     showPassword = true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;

//     return Container(
//       decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(widget.radius.sp)),
//       width: widget.width ?? size.width * .9,
//       child: ValueListenableBuilder<TextDirection>(
//         valueListenable: _textDir,
//         builder: (context, value, child) {
//           if (widget.controller.text.trim().length < 100) {
//             final dir = getDirection(widget.controller.text);
//             if (dir != value) _textDir.value = dir;
//           }
//           return TextFormField(
//             onTap: () {
//               if (widget.controller.selection ==
//                   TextSelection.fromPosition(TextPosition(
//                       offset: widget.controller.text.length - 1))) {
//                 setState(() {
//                   widget.controller.selection = TextSelection.fromPosition(
//                       TextPosition(offset: widget.controller.text.length));
//                 });
//               }
//             },
//             readOnly: widget.readOnly,
//             textDirection: widget.align ? _textDir.value : TextDirection.rtl,
//             onSaved: (widget.onSaved != null)
//                 ? (newValue) {
//                     if (newValue!.trim().length < 100) {
//                       final dir = getDirection(newValue);
//                       if (dir != value) _textDir.value = dir;
//                     }
//                     return widget.onSaved!(newValue);
//                   }
//                 : null,
//             onChanged: (input) {
//               if (input.trim().length < 100) {
//                 final dir = getDirection(input);
//                 if (dir != value) _textDir.value = dir;
//               }
//               bool isR = isRTL(input);
//               if (isR) {
//                 _textDir.value = TextDirection.rtl;
//               } else {
//                 _textDir.value = TextDirection.ltr;
//               }
//               if (widget.onChange != null) {
//                 widget.onChange!(input);
//               }
//             },
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             enabled: widget.enable,
//             focusNode: widget.focusNode,
//             onFieldSubmitted: (value) {
//               if (widget.onFieldSubmitted != null) {
//                 widget.onFieldSubmitted!(value);
//                 FocusScope.of(context).requestFocus(FocusNode());
//               }
//             },
//             textInputAction: widget.action,
//             maxLines: widget.max,
//             minLines: widget.min,
//             obscuringCharacter: '*',
//             controller: widget.controller,
//             cursorColor: AppColors.primaryColor,
//             style: AppTextStyle.getBoldStyle(
//                 color: AppColors.whiteColor, fontSize: 12.sp),
//             keyboardType: widget.type,
//             textAlignVertical: TextAlignVertical.center,
//             obscureText: widget.type == TextInputType.visiblePassword
//                 ? showPassword
//                 : false,
//             validator: widget.validator,
//             decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                     vertical: widget.verticalContentPadding ?? 2.h,
//                     horizontal: widget.horizontalContentPadding ?? 5.w),
//                 fillColor: AppColors.fillColor,
//                 filled: true,
//                 alignLabelWithHint: true,
//                 suffixIconConstraints: const BoxConstraints(
//                   minWidth: 25,
//                   minHeight: 25,
//                 ),
//                 prefixIconConstraints: const BoxConstraints(
//                   minWidth: 25,
//                   minHeight: 25,
//                 ),
//                 suffixIcon: widget.type == TextInputType.visiblePassword
//                     ? Material(
//                         color: Colors.transparent,
//                         shape: const CircleBorder(),
//                         clipBehavior: Clip.hardEdge,
//                         child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 showPassword = !showPassword;
//                               });
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 3.w, vertical: 2.w),
//                               child: Icon(
//                                 showPassword
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.grey,
//                               ),
//                             )),
//                       )
//                     : widget.suffixIcon != null
//                         ? Padding(
//                             padding: EdgeInsetsDirectional.only(
//                                 start: 3.w, end: 5.w),
//                             child: widget.suffixIcon,
//                           )
//                         : null,
//                 prefixIcon: widget.prefix != null
//                     ? GestureDetector(
//                         onTap: widget.onTapPassword,
//                         child: Padding(
//                           padding:
//                               EdgeInsetsDirectional.only(start: 5.w, end: 3.w),
//                           child: widget.prefix,
//                         ),
//                       )
//                     : null,
//                 label: Text(widget.hint!),
//                 labelStyle: AppTextStyle.getRegularStyle(
//                     color: AppColors.grayDarkColor, fontSize: 12.sp),
//                 floatingLabelStyle:
//                     const TextStyle(color: AppColors.primaryColor),
//                 errorStyle: const TextStyle(color: AppColors.primaryColor),
//                 enabledBorder: enabledBorder(),
//                 border: border(),
//                 disabledBorder: disabledBorder(),
//                 focusedBorder: focusedBorder(),
//                 focusedErrorBorder: errorBorder(),
//                 errorBorder: errorBorder()),
//           );
//         },
//       ),
//     );
//   }

//   TextDirection getDirection(String v) {
//     final string = v.trim();
//     if (string.isEmpty) return TextDirection.ltr;
//     final firstUnit = string.codeUnitAt(0);
//     if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
//         firstUnit > 0x0750 && firstUnit < 0x077F ||
//         firstUnit > 0x07C0 && firstUnit < 0x07EA ||
//         firstUnit > 0x0840 && firstUnit < 0x085B ||
//         firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
//         firstUnit > 0x08E3 && firstUnit < 0x08FF ||
//         firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
//         firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
//         firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
//         firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
//         firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
//         firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
//         firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
//         firstUnit > 0x10800 && firstUnit < 0x10805 ||
//         firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
//         firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
//         firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
//         firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
//         firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
//         firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
//         firstUnit > 0x1D242 && firstUnit < 0x1D244) {
//       return TextDirection.rtl;
//     }
//     return TextDirection.ltr;
//   }

//   OutlineInputBorder errorBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(widget.radius.sp),
//       borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
//     );
//   }

//   OutlineInputBorder disabledBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(widget.radius.sp),
//       borderSide: const BorderSide(color: AppColors.background, width: 2),
//     );
//   }

//   OutlineInputBorder focusedBorder() {
//     return OutlineInputBorder(
//         borderRadius: BorderRadius.circular(widget.radius.sp),
//         borderSide: const BorderSide(color: AppColors.primaryColor, width: 2));
//   }

//   OutlineInputBorder border() {
//     return OutlineInputBorder(
//         borderRadius: BorderRadius.circular(widget.radius.sp),
//         borderSide: const BorderSide(color: AppColors.primaryColor, width: 2));
//   }

//   OutlineInputBorder enabledBorder() {
//     return OutlineInputBorder(
//         borderRadius: BorderRadius.circular(widget.radius.sp),
//         borderSide: const BorderSide(color: AppColors.background, width: 2));
//   }
// }
