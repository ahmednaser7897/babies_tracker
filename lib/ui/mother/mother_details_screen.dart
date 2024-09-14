import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/ui/componnents/const_widget.dart';

import '../../app/app_colors.dart';
import '../../app/app_prefs.dart';
import '../../app/icon_broken.dart';
import '../../model/mother_model.dart';
import '../componnents/custom_button.dart';
import '../componnents/show_flutter_toast.dart';
import '../componnents/widgets.dart';
import '../doctor/mother/baby/show_mother_baybs.dart';
import '../doctor/chat/doctor_message_mother_screen.dart';
import '../doctor/mother/current_medications/show_mother_medications.dart';

class MotherDetailsScreen extends StatefulWidget {
  const MotherDetailsScreen({super.key, required this.model});
  final MotherModel model;
  @override
  State<MotherDetailsScreen> createState() => _MotherDetailsScreenState();
}

class _MotherDetailsScreenState extends State<MotherDetailsScreen> {
  late MotherModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.mother)),
      ),
      //MOTHER CAN CHAT WITH  HER DOCTOR ONLY
      floatingActionButton: (AppPreferences.userType == AppStrings.doctor &&
              model.docyorlId == DoctorCubit.get(context).model!.id)
          ? FloatingActionButton(
              onPressed: () {
                DoctorCubit.get(context).getMessages(
                  model: model,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorMessageMotherScreen(
                      model: model,
                    ),
                  ),
                );
              },
              backgroundColor: AppColors.primerColor,
              child: const Icon(
                IconBroken.Chat,
                color: Colors.white,
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              userImage(),
              AppSizedBox.h2,
              //only hospital can ban mother
              if (AppPreferences.userType == AppStrings.hospital) banWidget(),
              AppSizedBox.h1,
              options(),
              AppSizedBox.h3,
              dataValue(
                  name: "Name", value: model.name ?? '', prefix: Icons.person),
              AppSizedBox.h3,
              dataValue(
                  name: "Doctor",
                  value: model.doctorModel!.name ?? '',
                  prefix: Icons.person),
              AppSizedBox.h3,
              dataValue(
                  name: "Email",
                  value: model.email ?? '',
                  prefix: Icons.email_rounded),
              AppSizedBox.h3,
              dataValue(
                  name: "Phone", value: model.phone ?? '', prefix: Icons.call),
              AppSizedBox.h3,
              dataValue(
                  name: "address",
                  value: model.address ?? '',
                  prefix: Icons.home),
              AppSizedBox.h3,
              dataValue(
                  name: "Doctor notes",
                  value: model.doctorNotes ?? '',
                  prefix: Icons.note),
              AppSizedBox.h3,
              const Text(
                "Healthy History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AppSizedBox.h1,
              showList(
                model.healthyHistory ?? [],
              ),
              AppSizedBox.h3,
              const Text(
                "Postpartum Health",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AppSizedBox.h1,
              showList(
                model.postpartumHealth ?? [],
              ),
              AppSizedBox.h3,
              //only hospital can Check(IN/OUT) mother
              //if mother checked out this prevent doctor to add baby or medication to this mother
              if (AppPreferences.userType == AppStrings.hospital)
                BlocConsumer<HospitalCubit, HospitalState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state is LoadingChangeMotherLeft
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            text: !model.leaft.orFalse()
                                ? 'Check out the mother'
                                : 'Recheck in the mother',
                            width: 95,
                            fontsize: 12,
                            iconRight: Icon((model.leaft.orFalse())
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank),
                            onTap: () async {
                              checkSoutAlertDialog('mother', () {
                                HospitalCubit.get(context).changeMotherLeft(
                                    model, !model.leaft.orFalse());
                                Navigator.of(context).pop();
                              });
                            },
                          );
                  },
                ),
              AppSizedBox.h3,
            ],
          ),
        ),
      ),
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
          child: imageWithOnlineState(
              uri: model.image,
              type: AppAssets.mother,
              isOnline: model.online.orFalse()),
        ),
      ],
    );
  }

  Widget banWidget() {
    return Builder(builder: (context) {
      return BlocConsumer<HospitalCubit, HospitalState>(
        listener: (context, state) {
          if (state is ScChangeMotherBan) {
            setState(() {
              model.ban = !model.ban.orFalse();
            });
            if (model.ban.orFalse()) {
              showFlutterToast(
                message: AppStrings.userIsBaned(AppStrings.mother),
                toastColor: Colors.green,
              );
            } else {
              showFlutterToast(
                message: AppStrings.userIsunBaned(AppStrings.mother),
                toastColor: Colors.green,
              );
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              (state is LoadingChangeMotherBan)
                  ? const CircularProgressComponent()
                  : Center(
                      child: Switch(
                        value: model.ban.orFalse(),
                        activeColor: Colors.red,
                        splashRadius: 18.0,
                        onChanged: (value) async {
                          await HospitalCubit.get(context).changeMotherBan(
                              model.id.orEmpty(), !model.ban.orFalse());
                        },
                      ),
                    ),
            ],
          );
        },
      );
    });
  }

  Widget options() {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            text: 'Baybs',
            width: 45,
            fontsize: 12,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowMotherBabys(
                    model: model,
                  ),
                ),
              );
            },
          ),
          CustomButton(
            text: 'Medications',
            width: 45,
            fontsize: 12,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowMotherMedicationss(
                    model: model,
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  checkSoutAlertDialog(String user, Function onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(!model.leaft.orFalse()
                  ? "Check out the $user"
                  : 'Recheck in the $user'),
              const Spacer(),
              Icon(
                (model.leaft.orFalse())
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank,
                size: 20,
                color: AppColors.primerColor,
              ),
            ],
          ),
          content: Text(!model.leaft.orFalse()
              ? "Are you sour you want Check out the $user ?"
              : 'Are you sour you want Recheck in the $user ?'),
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

  Widget showList(List<String> myList) {
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
              title: Text(
                myList[index],
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
              ),
              leading: const Icon(
                Icons.health_and_safety,
                size: 18,
                color: AppColors.primerColor,
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: myList.length);
  }
}
