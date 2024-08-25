import 'package:flutter/material.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildCoverTextWidget extends StatelessWidget {
  final String message;
  final double width;
  final int maxLines;
  const BuildCoverTextWidget(
      {super.key, required this.message, this.width = 0, this.maxLines = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == 0 ? 100.w : width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Text(
          message,
          maxLines: maxLines == 0 ? 7 : maxLines,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.almarai(
            height: 1.5,
            color: Colors.black45,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
