import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/baby/sleep_details_model.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_assets.dart';
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
        itemBuilder: (context, index) => Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        AppAssets.sleeping,
                      ),
                    ),
                    AppSizedBox.w5,
                    Expanded(
                      child: Column(
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
                          Text(
                            'From : ${details[index].startTime.orEmpty()} - To : ${details[index].endTime.orEmpty()}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.almarai(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => AppSizedBox.h1,
        itemCount: details.length);
  }
}
