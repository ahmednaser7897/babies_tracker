import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../app/app_assets.dart';
import '../../../app/luanch_url.dart';
import '../../../model/chat/message_model.dart';

class BuildMyMessageWidget extends StatelessWidget {
  final MessageModel model;
  final AlignmentDirectional alignment;
  final Color backgroundColor;
  const BuildMyMessageWidget({
    super.key,
    required this.model,
    required this.alignment,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: 65.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: alignment == AlignmentDirectional.centerStart
                ? const Radius.circular(0.0)
                : const Radius.circular(13.0),
            bottomEnd: alignment == AlignmentDirectional.centerEnd
                ? const Radius.circular(0.0)
                : const Radius.circular(13.0),
            topStart: const Radius.circular(13.0),
            topEnd: const Radius.circular(13.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: alignment == AlignmentDirectional.centerStart
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(
              model.message.orEmpty(),
              style: GoogleFonts.almarai(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
            ),
            AppSizedBox.h1,
            if (model.file == null) dateWidget(),
            if (model.file != null) ...[
              buildReportCard(),
              AppSizedBox.h1,
              dateWidget(),
            ]
          ],
        ),
      ),
    );
  }

  Text dateWidget() {
    return Text(
      DateFormat(
        'dd MMM yyyy - hh:mm a',
      ).format(DateTime.parse(model.dateTime.toString())),
      style: GoogleFonts.almarai(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget buildReportCard() {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          launchURLFunction(model.file!);
        },
        child: Container(
          width: 20.w,
          height: 20.w,
          margin: const EdgeInsets.only(right: 10.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: AssetImage(
                  AppAssets.request,
                ),
                fit: BoxFit.contain),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
      );
    });
  }
}
