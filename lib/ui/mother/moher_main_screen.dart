import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../app/icon_broken.dart';

class MotherHomeScreen extends StatefulWidget {
  const MotherHomeScreen({super.key});

  @override
  State<MotherHomeScreen> createState() => _MotherHomeScreenState();
}

class _MotherHomeScreenState extends State<MotherHomeScreen> {
  @override
  void initState() {
    MotherCubit.get(context).getCurrentMotherData();

    HospitalCubit.get(context).getHomeData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MotherCubit, MotherState>(
      listener: (context, state) {},
      builder: (context, state) {
        MotherCubit cubit = MotherCubit.get(context);
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
                  AppAssets.doctor,
                  height: 7.w,
                  width: 7.w,
                ),
                label: AppStrings.doctors,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.baby,
                  height: 7.w,
                  width: 7.w,
                ),
                label: AppStrings.baby,
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
