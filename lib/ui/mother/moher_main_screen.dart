import 'dart:convert';
import 'dart:developer';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_state.dart';
import 'package:babies_tracker/ui/doctor/mother/current_medications/medications_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../app/icon_broken.dart';
import '../../model/current_medications_model.dart';
import '../../model/doctor_model.dart';
import 'chat/mother_message_doctor_screen.dart';

class MotherHomeScreen extends StatefulWidget {
  const MotherHomeScreen({super.key, this.getHomeData = true});
  final bool getHomeData;
  @override
  State<MotherHomeScreen> createState() => _MotherHomeScreenState();
}

class _MotherHomeScreenState extends State<MotherHomeScreen> {
  @override
  void initState() {
    if (widget.getHomeData) {
      MotherCubit.get(context).getCurrentMotherData();
      MotherCubit.get(context).getHomeData();
      HospitalCubit.get(context).getHomeData();
    }

    messagesListener();

    super.initState();
  }

  void messagesListener() {
    OneSignal.Notifications.addClickListener((event) async {
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
          DoctorModel doc = DoctorModel.fromJson(data);
          MotherCubit.get(context).getMessages(
            model: doc,
          );
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MotherMessageDoctorScreen(doctor: doc),
              ));
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MotherHomeScreen(
                getHomeData: false,
              ),
            ),
            (route) => false,
          );
        } else if (data['type'] == 'medication') {
          log('go tO medication2');
          log(data.toString());
          CurrentMedicationsModel model =
              CurrentMedicationsModel.fromJson(data);
          log(model.toString());
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationsDetailsScreen(model: model),
              ));
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MotherHomeScreen(
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
