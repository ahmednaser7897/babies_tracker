import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:babies_tracker/ui/hospital/settings_screens/create_new_doctor.dart';
import 'package:babies_tracker/ui/hospital/settings_screens/edit_hospital_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../app/app_assets.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_strings.dart';
import '../../../app/icon_broken.dart';
import '../../componnents/log_out_button.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/widgets.dart';
import 'create_new_mother.dart';

class HospitalSettingsScreen extends StatefulWidget {
  const HospitalSettingsScreen({super.key});

  @override
  State<HospitalSettingsScreen> createState() => _HospitalSettingsScreenState();
}

class _HospitalSettingsScreenState extends State<HospitalSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HospitalCubit, HospitalState>(
      buildWhen: (previous, current) =>
          current is LoadingGetHospital ||
          current is ScGetHospital ||
          current is ErorrGetHospital,
      listener: (context, state) {},
      builder: (context, state) {
        HospitalCubit cubit = HospitalCubit.get(context);
        return screenBuilder(
          contant: Column(
            children: [
              SizedBox(
                width: 100.w,
                height: 20.h,
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 20.h,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 12.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: (cubit.hospitalModel!.image != null &&
                                        cubit.hospitalModel!.image!.isNotEmpty)
                                    ? NetworkImage(
                                        cubit.hospitalModel!.image.orEmpty())
                                    : AssetImage(
                                        AppAssets.hospital,
                                      ) as ImageProvider,
                              ),
                            ),
                          ),
                          AppSizedBox.w5,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cubit.hospitalModel!.name.orEmpty(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSizedBox.h3,
                              Text(
                                cubit.hospitalModel!.email.orEmpty(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 20.h,
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EditHospitalScreen(),
                              ));
                        },
                        icon: const Icon(
                          IconBroken.Edit,
                          color: AppColors.primerColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AppSizedBox.h3,
              settingbuildListItem(
                context,
                title: AppStrings.newUser(AppStrings.doctor),
                leadingIcon: IconBroken.Profile,
                subtitle: AppStrings.createNewUser(AppStrings.doctor),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateNewDoctor(),
                      ));
                },
              ),
              settingbuildListItem(
                context,
                title: AppStrings.newUser(AppStrings.mother),
                leadingIcon: IconBroken.Profile,
                subtitle: AppStrings.createNewUser(AppStrings.mother),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewMotherScreen(),
                      ));
                },
              ),
              const Spacer(),
              LogOutButton(
                onTap: () async {
                  await HospitalCubit.get(context).changeHospitalOnline(
                      HospitalCubit.get(context).hospitalModel!.id ?? "",
                      false);
                  cubit.changeBottomNavBar(0);
                },
              ),
              AppSizedBox.h3,
            ],
          ),
          isEmpty: false,
          isErorr: state is ErorrGetHospital,
          isLoading: state is LoadingGetHomeData ||
              state is LoadingGetHospital ||
              state is LoadingChangeHospitalOnline,
          isSc: state is ScGetHospital || cubit.hospitalModel != null,
        );
      },
    );
  }
}
