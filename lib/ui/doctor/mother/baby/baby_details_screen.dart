import 'package:babies_tracker/app/app_colors.dart';
import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_prefs.dart';
import '../../../../controller/doctor/doctor_cubit.dart';
import '../../../../controller/doctor/doctor_state.dart';
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
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showBottomSheet(context);
            },
            backgroundColor: AppColors.primerColor,
            child: const Icon(
              Icons.more_horiz,
            ),
          ),
          appBar: AppBar(
            title: Text(AppStrings.userDetails(AppStrings.baby)),
            actions: [
              if (!model.left.orFalse() &&
                  AppPreferences.userType == AppStrings.doctor &&
                  widget.model.doctorId == DoctorCubit.get(context).model!.id)
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBabyScreen(
                            model: widget.model,
                          ),
                        ),
                      );

                      Navigator.pop(context, '');
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
                  // options(),
                  // AppSizedBox.h1,
                  dataValue(
                      name: "Name",
                      value: model.name ?? '',
                      prefix: Icons.person),
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
                        "APGAR Score !",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSizedBox.w5,
                      scoresIcon(context),
                    ],
                  ),
                  AppSizedBox.h1,
                  dataValue(
                    name: null,
                    value:
                        '( ${model.appearance} , ${model.pulse} , ${model.grimace} , ${model.activity} , ${model.respiration} )',
                  ),
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
                              builder: (context) =>
                                  ShowPdf(file: value, uri: ''),
                            ));
                      },
                    ),
                  AppSizedBox.h3,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  checkSoutAlertDialog(String user, Function onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(!model.left.orFalse()
                  ? "Check out the $user"
                  : 'Recheck in the $user"'),
              const Spacer(),
              const Icon(
                Icons.check_box_rounded,
                size: 20,
                color: AppColors.primerColor,
              ),
            ],
          ),
          content: Text(!model.left.orFalse()
              ? "Are you sour you want Check out the $user ?"
              : 'Are you sour you want Recheck in the $user ?"'),
          elevation: 10,
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

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0)), // Custom border radius
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.vaccines,
                  color: AppColors.primerColor,
                  size: 30,
                ),
                title: const Text('Vaccinations'),
                onTap: () async {
                  Navigator.pop(context);
                  // Handle option 1 action
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
              ListTile(
                leading: const Icon(
                  Icons.bed,
                  color: AppColors.primerColor,
                  size: 30,
                ),
                title: const Text('Sleep Details'),
                onTap: () async {
                  Navigator.pop(context);
                  // Handle option 2 action
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
              ListTile(
                leading: const Icon(
                  Icons.food_bank,
                  color: AppColors.primerColor,
                  size: 30,
                ),
                title: const Text('Feeding Times'),
                onTap: () async {
                  Navigator.pop(context);
                  // Handle option 3 action
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
          ),
        );
      },
    );
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
                      AppAssets.baby,
                    ) as ImageProvider,
            ),
          ),
        ),
        AppSizedBox.h2,
      ],
    );
  }
}
