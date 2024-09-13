import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/sleep_details_model.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../componnents/widgets.dart';

class SleepsDetailsScreen extends StatefulWidget {
  const SleepsDetailsScreen({super.key, required this.model});
  final SleepDetailsModel model;
  @override
  State<SleepsDetailsScreen> createState() => _SleepsDetailsScreenState();
}

class _SleepsDetailsScreenState extends State<SleepsDetailsScreen> {
  late SleepDetailsModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails('Sleeping times')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              dataValue(
                  name: "Total sleeped hours",
                  value: ' ${model.totalSleepDuration ?? ''}  hours',
                  prefix: Icons.timelapse_rounded),
              AppSizedBox.h3,
              dataValue(
                  name: "Date",
                  value: model.date ?? '',
                  prefix: Icons.date_range),
              AppSizedBox.h3,
              AppSizedBox.h3,
              dataValue(
                  name: "Notes", value: model.notes ?? '', prefix: Icons.note),
              AppSizedBox.h3,
              Text(
                'Sleeping Times : ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: GoogleFonts.almarai(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              AppSizedBox.h1,
              showDetails(model.details ?? []),
            ],
          ),
        ),
      ),
    );
  }

  Widget showDetails(List<DetailsModel> details) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
              tileColor: Colors.grey[100],
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details[index].sleepQuality.orEmpty(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  AppSizedBox.h1,
                  Row(
                    children: [
                      Text(
                        'From : ${details[index].startTime.orEmpty()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.almarai(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.w3,
                      Text(
                        'To : ${details[index].endTime.orEmpty()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.almarai(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        separatorBuilder: (context, index) => AppSizedBox.h1,
        itemCount: details.length);
  }
}
