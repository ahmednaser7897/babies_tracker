import 'package:babies_tracker/view/Doctor/settings_screens/edit_Doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../app/app_assets.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_prefs.dart';
import '../../../app/icon_broken.dart';

import '../../../controller/doctor/doctor_cubit.dart';
import '../../../controller/doctor/doctor_state.dart';
import '../../componnents/log_out_button.dart';
import '../../componnents/screen_builder.dart';

class DoctorSettingsScreen extends StatefulWidget {
  const DoctorSettingsScreen({super.key});

  @override
  State<DoctorSettingsScreen> createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      buildWhen: (previous, current) =>
          current is LoadingGetDoctor ||
          current is ScGetDoctor ||
          current is ErorrGetDoctor,
      listener: (context, state) {},
      builder: (context, state) {
        DoctorCubit cubit = DoctorCubit.get(context);
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
                                image: (cubit.model!.image != null &&
                                        cubit.model!.image!.isNotEmpty)
                                    ? NetworkImage(cubit.model!.image.orEmpty())
                                    : AssetImage(
                                        AppAssets.doctor,
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
                                cubit.model!.name.orEmpty(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSizedBox.h3,
                              Text(
                                cubit.model!.email.orEmpty(),
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
                                builder: (context) => const EditeDoctorScreen(),
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
              const Spacer(),
              LogOutButton(
                onTap: () async {
                  await DoctorCubit.get(context).changeDoctorOnline(
                      DoctorCubit.get(context).model!.id ?? "",
                      AppPreferences.hospitalUid,
                      false);
                  cubit.changeBottomNavBar(0);
                },
              ),
              AppSizedBox.h3,
            ],
          ),
          isEmpty: false,
          isErorr: state is ErorrGetDoctor,
          isLoading: state is LoadingGetHomeData ||
              state is LoadingGetDoctor ||
              state is LoadingChangeDoctorOnline,
          isSc: state is ScGetDoctor || cubit.model != null,
        );
      },
    );
  }
}
