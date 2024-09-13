import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/feeding_times_model.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_assets.dart';
import '../../../../componnents/widgets.dart';

class FeedingsDetailsScreen extends StatefulWidget {
  const FeedingsDetailsScreen({super.key, required this.model});
  final FeedingTimesModel model;
  @override
  State<FeedingsDetailsScreen> createState() => _FeedingsDetailsScreenState();
}

class _FeedingsDetailsScreenState extends State<FeedingsDetailsScreen> {
  late FeedingTimesModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.feedings)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              dataValue(
                  name: "Date",
                  value: model.date ?? '',
                  prefix: Icons.date_range),
              AppSizedBox.h3,
              dataValue(
                  name: "Notes", value: model.notes ?? '', prefix: Icons.note),
              AppSizedBox.h3,
              Text(
                'Feedings : ',
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

  Widget showDetails(List<Feedingdetails> details) {
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
                        AppAssets.feeding,
                      ),
                    ),
                    AppSizedBox.w5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details[index].feedingDetails.orEmpty(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        AppSizedBox.h1,
                        Text(
                          'Time : ${details[index].feedingTime.orEmpty()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSizedBox.h1,
                        Text(
                          'Amount in (Milliliters) : ${details[index].feedingAmount.orEmpty()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSizedBox.h1,
                        Text(
                          'Duration in (Minutes) : ${details[index].feedingDuration.orEmpty()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => AppSizedBox.h1,
        itemCount: details.length);
  }
}
