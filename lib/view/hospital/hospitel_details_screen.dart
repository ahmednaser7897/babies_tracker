import 'package:babies_tracker/app/app_prefs.dart';
import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/app/luanch_url.dart';
import 'package:babies_tracker/model/hospital/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/admin/admin_cubit.dart';
import 'package:babies_tracker/view/componnents/const_widget.dart';

import '../../app/app_colors.dart';
import '../componnents/custom_button.dart';
import '../componnents/show_flutter_toast.dart';
import '../componnents/users_lists.dart';
import '../componnents/widgets.dart';

class HospitelDetailsScreen extends StatefulWidget {
  const HospitelDetailsScreen({super.key, required this.model});
  final HospitalModel model;
  @override
  State<HospitelDetailsScreen> createState() => _HospitelDetailsScreenState();
}

class _HospitelDetailsScreenState extends State<HospitelDetailsScreen> {
  late HospitalModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.hospital)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              userImage(),
              AppSizedBox.h2,
              banWidget(),
              AppSizedBox.h2,
              options(),
              AppSizedBox.h2,
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
                  name: "City", value: model.city ?? '', prefix: Icons.home),
              AppSizedBox.h3,
              dataValue(
                name: "Location",
                value: model.location ?? '',
                prefix: Icons.location_history,
                trailing: InkWell(
                  onTap: () {
                    launchURLFunction(model.location ?? '');
                  },
                  child: const Icon(
                    Icons.info,
                    color: AppColors.primer,
                  ),
                ),
              ),
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
        const SizedBox(
          width: double.infinity,
        ),
        Hero(
          tag: model.id.orEmpty(),
          child: imageWithOnlineState(
              uri: model.image,
              type: AppAssets.hospital,
              isOnline: model.online.orFalse()),
        ),
      ],
    );
  }

  Widget banWidget() {
    return Builder(builder: (context) {
      return BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is ScChangeHospitalBan) {
            setState(() {
              model.ban = !model.ban.orFalse();
            });
            if (model.ban.orFalse()) {
              showFlutterToast(
                message: AppStrings.userIsBaned(AppStrings.hospital),
                toastColor: Colors.green,
              );
            } else {
              showFlutterToast(
                message: AppStrings.userIsunBaned(AppStrings.hospital),
                toastColor: Colors.green,
              );
            }
          }
        },
        builder: (context, state) {
          return (state is LoadingChangeHospitalBan)
              ? const CircularProgressComponent()
              : Center(
                  child: Switch(
                    value: model.ban.orFalse(),
                    activeColor: Colors.red,
                    splashRadius: 18.0,
                    onChanged: (value) async {
                      await AdminCubit.get(context).changeHospitalBan(
                          model.id.orEmpty(), !model.ban.orFalse());
                    },
                  ),
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
            text: 'Doctors',
            width: AppPreferences.userType != AppStrings.admin ? 40 : 90,
            fontsize: 12,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Show doctors'),
                    ),
                    body: (model.doctors ?? []).isEmpty
                        ? emptListWidget(AppStrings.doctors)
                        : buildDoctorsList(doctors: model.doctors ?? []),
                  ),
                ),
              );
            },
          ),
          // admin can not see hospital mothers
          if (AppPreferences.userType != AppStrings.admin)
            CustomButton(
              text: 'Mothers',
              width: 40,
              fontsize: 12,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Show mothers'),
                      ),
                      body: buildMothersList(mothers: model.mothers ?? []),
                    ),
                  ),
                );
              },
            ),
        ],
      );
    });
  }
}
