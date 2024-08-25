// import 'package:flutter/material.dart';
// import 'package:babies_tracker/app/app_sized_box.dart';
// import 'package:babies_tracker/app/extensions.dart';
// import 'package:google_fonts/google_fonts.dart';


// class BuildMyMessageWidget extends StatelessWidget {
//   final MessageModel model;
//   final AlignmentDirectional alignment;
//   final Color backgroundColor;
//   const BuildMyMessageWidget({
//     super.key,
//     required this.model,
//     required this.alignment,
//     required this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
    
//     return Align(
//       alignment: alignment,
//       child: Container(
//         constraints: BoxConstraints(maxWidth:65.w),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadiusDirectional.only(
//             bottomStart: alignment == AlignmentDirectional.centerStart
//                 ? const Radius.circular(0.0)
//                 : const Radius.circular(13.0),
//             bottomEnd: alignment == AlignmentDirectional.centerEnd
//                 ? const Radius.circular(0.0)
//                 : const Radius.circular(13.0),
//             topStart: const Radius.circular(13.0),
//             topEnd: const Radius.circular(13.0),
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//         child: Column(
//           crossAxisAlignment: alignment == AlignmentDirectional.centerStart
//               ? CrossAxisAlignment.start
//               : CrossAxisAlignment.end,
//           children: [
//             Text(
//               model.message,
//               style: GoogleFonts.almarai(
//                 fontSize: 15.0,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.grey[700],
//               ),
//             ),
//             AppSizedBox.h1,
//             Text(
//               model.time!,
//               style: GoogleFonts.almarai(
//                 fontSize: 12.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
