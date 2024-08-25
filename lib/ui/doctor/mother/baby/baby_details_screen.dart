import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_prefs.dart';
import '../../../../controller/doctor/doctor_cubit.dart';
import '../../../../controller/hospital/hospital_cubit.dart';
import '../../../componnents/custom_button.dart';
import '../../../componnents/widgets.dart';
import '../../../mother/pdfs/baby_health_pdf.dart';
import '../../../mother/pdfs/show_pdf_screen.dart';
import 'feeding_time/show_bayb_feeding_details.dart';
import 'sleep_details/show_bayb_sleep_details.dart';
import 'update_mother_baby.dart';
import 'vaccinations/show_bayb_vaccinations.dart';

class BabyDetailsScreen extends StatefulWidget {
  const BabyDetailsScreen({super.key, required this.model});
  final BabieModel model;
  @override
  State<BabyDetailsScreen> createState() => _BabyDetailsScreenState();
}

class _BabyDetailsScreenState extends State<BabyDetailsScreen> {
  late BabieModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.baby)),
        actions: [
          if (!model.left.orFalse() &&
              AppPreferences.userType == AppStrings.doctor &&
              widget.model.doctorId == DoctorCubit.get(context).model!.id)
            IconButton(
                onPressed: () async {
                  var value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBabyScreen(
                        model: widget.model,
                      ),
                    ),
                  );
                  if (value == 'add') {
                    Navigator.pop(context, 'add');
                  }
                },
                icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              userImage(),
              AppSizedBox.h1,
              options(),
              AppSizedBox.h1,
              dataValue(
                  name: "Name", value: model.name ?? '', prefix: Icons.person),
              AppSizedBox.h3,
              dataValue(
                  name: "Height in(cm)",
                  value: model.birthLength ?? '',
                  prefix: Icons.height),
              AppSizedBox.h3,
              dataValue(
                  name: "Weight in(kg)",
                  value: model.birthWeight ?? '',
                  prefix: Icons.monitor_weight),
              AppSizedBox.h3,
              dataValue(
                  name: "Head Circumference in(cm)",
                  value: model.headCircumference ?? '',
                  prefix: Icons.numbers),
              dataValue(
                  name: "Birth Date",
                  value: model.birthDate ?? '',
                  prefix: Icons.date_range),
              AppSizedBox.h3,
              dataValue(
                  name: "Gestational Age",
                  value: model.gestationalAge != null
                      ? '${model.gestationalAge!} month'
                      : '',
                  prefix: Icons.date_range),
              AppSizedBox.h3,
              dataValue(
                  name: "Delivery Type",
                  value: model.deliveryType ?? '',
                  prefix: Icons.type_specimen_sharp),
              AppSizedBox.h3,
              Row(
                children: [
                  const Text(
                    "Next Info",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  scoresIcon(context),
                ],
              ),
              AppSizedBox.h1,
              dataValue(
                  name: "Appearance",
                  value: model.appearance.toString(),
                  prefix: Icons.skateboarding_rounded),
              AppSizedBox.h3,
              dataValue(
                  name: "Grimace",
                  value: model.grimace.toString(),
                  prefix: Icons.skateboarding_rounded),
              AppSizedBox.h3,
              dataValue(
                  name: "Pulse",
                  value: model.pulse.toString(),
                  prefix: Icons.skateboarding_rounded),
              AppSizedBox.h3,
              dataValue(
                  name: "Respiration",
                  value: model.respiration.toString(),
                  prefix: Icons.skateboarding_rounded),
              AppSizedBox.h3,
              dataValue(
                  name: "Doctor Notes",
                  value: model.doctorNotes.toString(),
                  prefix: Icons.note),
              AppSizedBox.h3,
              if (AppPreferences.userType == AppStrings.hospital)
                BlocConsumer<HospitalCubit, HospitalState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state is LoadingChangeBabyLeft
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            text: !model.left.orFalse()
                                ? 'Check out the baby'
                                : 'Recheck in the baby',
                            width: 95,
                            fontsize: 12,
                            iconRight: const Icon(Icons.output),
                            onTap: () async {
                              checkSoutAlertDialog('baby', () {
                                HospitalCubit.get(context).changeBabyLeft(
                                    model, !model.left.orFalse());
                                Navigator.of(context).pop();
                              });
                            },
                          );
                  },
                ),
              if (AppPreferences.userType == AppStrings.mother)
                CustomButton(
                  text: 'Healthy information pdf',
                  width: 95,
                  fontsize: 12,
                  onTap: () async {
                    var value = await BabyHealthPdf.generate(model);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowPdf(file: value, uri: ''),
                        ));
                  },
                ),
              AppSizedBox.h3,
            ],
          ),
        ),
      ),
    );
  }

  checkSoutAlertDialog(String user, Function onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("AlertDialog"),
          content: Text(!model.left.orFalse()
              ? "Are you sour you want Check out the $user ?"
              : 'Are you sour you want Recheck in the $user ?"'),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Sure"),
              onPressed: () {
                onTap();
              },
            )
          ],
        );
      },
    );
  }

  Widget options() {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: 'Vaccinations',
                width: 40,
                fontsize: 12,
                onTap: () async {
                  var value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowBabyVaccinationss(
                        model: model,
                      ),
                    ),
                  );
                  if (value == 'add') {
                    Navigator.pop(context, 'add');
                  }
                },
              ),
              CustomButton(
                text: 'Sleep Details',
                width: 40,
                fontsize: 12,
                // iconRight: const Icon(Icons.baby_changing_station),
                onTap: () async {
                  var value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowBabySleepDetailss(
                        model: model,
                      ),
                    ),
                  );
                  if (value == 'add') {
                    Navigator.pop(context, 'add');
                  }
                },
              ),
            ],
          ),
          AppSizedBox.h1,
          CustomButton(
            text: 'Feeding Times',
            width: 60,
            fontsize: 12,
            onTap: () async {
              var value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowBabyFeedingDetailss(
                    model: model,
                  ),
                ),
              );
              if (value == 'add') {
                Navigator.pop(context, 'add');
              }
            },
          ),
        ],
      );
    });
  }

  Widget userImage() {
    return Column(
      children: [
        Container(
          width: double.infinity,
        ),
        Hero(
          tag: model.id.orEmpty(),
          child: SizedBox(
            width: 30.w,
            child: CircleAvatar(
              radius: 15.w,
              backgroundImage: (model.photo != null && model.photo!.isNotEmpty)
                  ? NetworkImage(model.photo.orEmpty())
                  : AssetImage(
                      AppAssets.mother,
                    ) as ImageProvider,
            ),
          ),
        ),
        AppSizedBox.h2,
      ],
    );
  }
}
