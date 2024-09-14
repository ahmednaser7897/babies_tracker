import 'package:babies_tracker/app/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:get/get.dart';

import '../../app/icon_broken.dart';
import '../../controller/admin/admin_cubit.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AdminCubit.get(context).getCurrentAdminData();
    AdminCubit.get(context).getHomeData();
    super.initState();
  }

  //this fun handels the (on/off)line system
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('did change');
    var cubit = AdminCubit.get(Get.context);
    if (state == AppLifecycleState.resumed) {
      print('state1');
      print(state);
      cubit.changeAdminOnline(cubit.adminModel!.id.orEmpty(), true);
    } else if (state == AppLifecycleState.paused) {
      print('state2');
      print(state);
      cubit.changeAdminOnline(cubit.adminModel!.id.orEmpty(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {},
      builder: (context, state) {
        AdminCubit cubit = AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.admin,
                  height: 7.w,
                  width: 7.w,
                ),
                label: AppStrings.admins,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.hospital,
                  height: 7.w,
                  width: 7.w,
                ),
                label: AppStrings.hospitals,
              ),
              const BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: AppStrings.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
