import 'package:babies_tracker/app/app_colors.dart';
import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/view/componnents/const_widget.dart';

import '../../app/app_prefs.dart';
import '../../app/icon_broken.dart';
import '../../controller/mother/mother_cubit.dart';
import '../../model/doctor/doctor_model.dart';
import '../componnents/show_flutter_toast.dart';
import '../componnents/widgets.dart';
import '../mother/chat/mother_message_doctor_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen(
      {super.key, required this.model, this.fromMother = false});
  final DoctorModel model;
  final bool fromMother;
  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late DoctorModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.doctor)),
      ),
      //doctor can chat with mother only
      floatingActionButton: (AppPreferences.userType == AppStrings.mother)
          ? FloatingActionButton(
              onPressed: () {
                MotherCubit.get(context).getMessages(
                  model: model,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MotherMessageDoctorScreen(
                      doctor: model,
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
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              userImage(),
              AppSizedBox.h2,
              //only hospital can ban doctor
              if (AppPreferences.userType == AppStrings.hospital) banWidget(),
              dataValue(
                  name: "Name", value: model.name ?? '', prefix: Icons.person),
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
                  name: "Gender",
                  value: model.gender ?? '',
                  prefix: Icons.male),
              AppSizedBox.h3,
              dataValue(
                  name: "Bio",
                  value: model.bio ?? '',
                  prefix: Icons.info_outline),
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
              type: AppAssets.doctor,
              isOnline: model.online.orFalse()),
        ),
      ],
    );
  }

  Widget banWidget() {
    return Builder(builder: (context) {
      return BlocConsumer<HospitalCubit, HospitalState>(
        listener: (context, state) {
          if (state is ScChangeDoctorBan) {
            setState(() {
              model.ban = !model.ban.orFalse();
            });
            if (model.ban.orFalse()) {
              showFlutterToast(
                message: AppStrings.userIsBaned(AppStrings.doctor),
                toastColor: Colors.green,
              );
            } else {
              showFlutterToast(
                message: AppStrings.userIsunBaned(AppStrings.doctor),
                toastColor: Colors.green,
              );
            }
          }
        },
        builder: (context, state) {
          return (state is LoadingChangeDoctorBan)
              ? const CircularProgressComponent()
              : Center(
                  child: Switch(
                    value: model.ban.orFalse(),
                    activeColor: Colors.red,
                    splashRadius: 18.0,
                    onChanged: (value) async {
                      await HospitalCubit.get(context).changeDoctorBan(
                          model.id.orEmpty(), !model.ban.orFalse());
                    },
                  ),
                );
        },
      );
    });
  }
}
