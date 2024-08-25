import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../app/icon_broken.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    DoctorCubit.get(context).getCurrentDoctorData();

    HospitalCubit.get(context).getHomeData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {},
      builder: (context, state) {
        DoctorCubit cubit = DoctorCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
              // if (index == 1) {
              //   cubit.getHomeData();
              // }
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
                  AppAssets.mother,
                  height: 7.w,
                  width: 7.w,
                ),
                label: AppStrings.mothers,
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
