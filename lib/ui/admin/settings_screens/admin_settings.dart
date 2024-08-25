import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../app/app_assets.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_strings.dart';
import '../../../app/icon_broken.dart';
import '../../../controller/admin/admin_cubit.dart';
import '../../componnents/log_out_button.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/widgets.dart';
import 'add_new_admin_screen.dart';
import 'add_new_hospital_screen.dart';
import 'edit_admin_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      buildWhen: (previous, current) =>
          current is LoadingGetAdmin ||
          current is ScGetAdmin ||
          current is ErorrGetAdmin,
      listener: (context, state) {},
      builder: (context, state) {
        AdminCubit cubit = AdminCubit.get(context);
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
                                image: (cubit.adminModel!.image != null &&
                                        cubit.adminModel!.image!.isNotEmpty)
                                    ? NetworkImage(
                                        cubit.adminModel!.image.orEmpty())
                                    : AssetImage(
                                        AppAssets.admin,
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
                                cubit.adminModel!.name.orEmpty(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSizedBox.h3,
                              Text(
                                cubit.adminModel!.email.orEmpty(),
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
                                    const EditNewAdminScreen(),
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
                title: AppStrings.newUser(AppStrings.admin),
                leadingIcon: IconBroken.Profile,
                subtitle: AppStrings.createNewUser(AppStrings.admin),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewAdminScreen(),
                      ));
                },
              ),
              settingbuildListItem(
                context,
                title: AppStrings.newUser(AppStrings.hospital),
                leadingIcon: IconBroken.Profile,
                subtitle: AppStrings.createNewUser(AppStrings.hospital),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewHospitalScreen(),
                      ));
                },
              ),
              const Spacer(),
              LogOutButton(
                onTap: () async {
                  await AdminCubit.get(context).changeAdminOnline(
                      AdminCubit.get(context).adminModel!.id ?? "", false);
                  cubit.changeBottomNavBar(0);
                },
              ),
              AppSizedBox.h3,
            ],
          ),
          isEmpty: false,
          isErorr: state is ErorrGetAdmin,
          isLoading: state is LoadingGetAdmin,
          isSc: state is ScGetAdmin || cubit.adminModel != null,
        );
      },
    );
  }
}
