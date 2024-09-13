import 'dart:convert';
import 'dart:developer';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:babies_tracker/ui/doctor/chat/doctor_message_mother_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../app/icon_broken.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key, this.getHomeData = true});
  final bool getHomeData;
  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    if (widget.getHomeData) {
      DoctorCubit.get(context).getCurrentDoctorData(homeData: true);
      HospitalCubit.get(context).getHomeData();
    }

    messagesListener();
    super.initState();
  }

  void messagesListener() {
    OneSignal.Notifications.addClickListener((event) {
      try {
        log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
        String myjson = event.notification
            .jsonRepresentation()
            .replaceAll(' ', '')
            .replaceAll("\n", "")
            .replaceAll('"{', '{')
            .replaceAll('}"', '}');
        log("Clicked notification: \n $myjson");
        Map<String, dynamic> data = (json.decode(myjson)
            as Map<String, dynamic>)['custom']['a'] as Map<String, dynamic>;
        log("data");
        log(data.toString());
        if (data['type'] == 'chat') {
          log('go tO chat');
          MotherModel doc = MotherModel.fromJson(data);
          DoctorCubit.get(context).getMessages(
            model: doc,
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorMessageMotherScreen(model: doc),
              ));
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorHomeScreen(
                getHomeData: false,
              ),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        print("erorr from messagesListener is ${e.toString()}");
      }
    });
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
