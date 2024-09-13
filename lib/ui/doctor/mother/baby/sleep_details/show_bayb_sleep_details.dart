import 'package:animate_do/animate_do.dart';
import 'package:babies_tracker/app/app_prefs.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/model/sleep_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_sized_box.dart';
import '../../../../../app/app_strings.dart';
import '../../../../componnents/screen_builder.dart';
import 'add_sleep_details_to_baby.dart';
import 'sleap_details_details_screen.dart';

class ShowBabySleepDetailss extends StatefulWidget {
  const ShowBabySleepDetailss({super.key, required this.model});
  final BabieModel model;
  @override
  State<ShowBabySleepDetailss> createState() => _ShowBabySleepDetailssState();
}

class _ShowBabySleepDetailssState extends State<ShowBabySleepDetailss> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Show Baby Sleep Detailss'),
              actions: [
                if (!widget.model.left.orFalse() &&
                    AppPreferences.userType == AppStrings.doctor &&
                    widget.model.doctorId == DoctorCubit.get(context).model!.id)
                  IconButton(
                      onPressed: () async {
                        var value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSleepDetailsScreen(
                              model: widget.model,
                            ),
                          ),
                        );
                        if (value == 'add') {
                          Navigator.pop(context, 'add');
                        }
                      },
                      icon: const Icon(Icons.add))
              ],
            ),
            body: BlocConsumer<DoctorCubit, DoctorState>(
              buildWhen: (previous, current) =>
                  current is LoadingGetHomeData ||
                  current is ScGetHomeData ||
                  current is ErorrGetHomeData,
              listener: (context, state) {},
              builder: (context, state) {
                return screenBuilder(
                  contant: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSizedBox.h2,
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    SleepDetailsCard(
                                        (widget.model.sleepDetailsModel ??
                                            [])[index]),
                                separatorBuilder: (context, index) =>
                                    AppSizedBox.h2,
                                itemCount:
                                    (widget.model.sleepDetailsModel ?? [])
                                        .length),
                            AppSizedBox.h2,
                          ],
                        ),
                      ),
                    ),
                  ),
                  isEmpty: false,
                  isErorr: state is ErorrGetHomeData,
                  isLoading: state is LoadingGetHomeData,
                  isSc: state is ScGetHomeData ||
                      (widget.model.sleepDetailsModel ?? []).isNotEmpty,
                );
              },
            ));
      },
    );
  }

  Widget SleepDetailsCard(SleepDetailsModel model) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SleepsDetailsScreen(
                  model: model,
                ),
              ));
        },
        child: FadeInUp(
          from: 20,
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 100.w,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Hours : ${model.totalSleepDuration.orEmpty()}',
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
                  Text(
                    'Date : ${model.date.orEmpty()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
