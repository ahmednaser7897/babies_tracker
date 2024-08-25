import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/admin/admin_cubit.dart';
import 'package:babies_tracker/ui/componnents/const_widget.dart';

import '../../componnents/custom_button.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/users_lists.dart';
import '../../componnents/widgets.dart';

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
                  name: "City",
                  value: model.city ?? '',
                  prefix: Icons.location_city),
              AppSizedBox.h3,
              dataValue(
                  name: "Location",
                  value: model.location ?? '',
                  prefix: Icons.location_history),
              AppSizedBox.h3,
              dataValue(
                  name: "Bio", value: model.bio ?? '', prefix: Icons.biotech),
              AppSizedBox.h3,
            ],
          ),
        ),
      ),
    );
  }

  Widget options() {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            text: 'Doctors',
            width: 40,
            fontsize: 12,
            onTap: () async {
              var value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Show doctors'),
                    ),
                    body: buildDoctorsList(doctors: model.doctors ?? []),
                  ),
                ),
              );
              if (value == 'add') {
                Navigator.pop(context, 'add');
              }
            },
          ),
          CustomButton(
            text: 'Mothers',
            width: 40,
            fontsize: 12,
            onTap: () async {
              var value = await Navigator.push(
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
          return Column(
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Hero(
                tag: model.id.orEmpty(),
                child: SizedBox(
                  width: 30.w,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor:
                              model.online ?? false ? Colors.green : Colors.red,
                          radius: 2.w,
                        ),
                      ),
                      CircleAvatar(
                        radius: 15.w,
                        backgroundImage:
                            (model.image != null && model.image!.isNotEmpty)
                                ? NetworkImage(model.image.orEmpty())
                                : AssetImage(
                                    AppAssets.admin,
                                  ) as ImageProvider,
                      ),
                    ],
                  ),
                ),
              ),
              AppSizedBox.h2,
              (state is LoadingChangeHospitalBan)
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
                    ),
              AppSizedBox.h2,
              options(),
              AppSizedBox.h2,
            ],
          );
        },
      );
    });
  }
}
