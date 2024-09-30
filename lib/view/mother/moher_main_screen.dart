import 'dart:convert';
import 'dart:developer';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_state.dart';
import 'package:babies_tracker/view/doctor/mother/current_medications/medications_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../app/app_prefs.dart';
import '../../app/icon_broken.dart';
import '../../model/mother/current_medications_model.dart';
import '../../model/doctor/doctor_model.dart';
import 'chat/mother_message_doctor_screen.dart';

class MotherHomeScreen extends StatefulWidget {
  const MotherHomeScreen({super.key, this.getHomeData = true});
  final bool getHomeData;
  @override
  State<MotherHomeScreen> createState() => _MotherHomeScreenState();
}

class _MotherHomeScreenState extends State<MotherHomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (widget.getHomeData) {
      //MotherCubit.get(context).getCurrentMotherData();
      MotherCubit.get(context).getHomeData();
      HospitalCubit.get(context).getHomeData();
    }

    messagesListener();

    super.initState();
  }

  //this fun handels the (on/off)line system
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('did change');
    var cubit = MotherCubit.get(Get.context);
    if (state == AppLifecycleState.resumed) {
      print('state1');
      print(state);
      cubit.changeMotherOnline(
          cubit.model!.id.orEmpty(), AppPreferences.hospitalUid, true);
    } else if (state == AppLifecycleState.paused) {
      print('state2');
      print(state);
      cubit.changeMotherOnline(
          cubit.model!.id.orEmpty(), AppPreferences.hospitalUid, false);
    }
  }

  void messagesListener() {
    OneSignal.Notifications.addClickListener((event) async {
      try {
        log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
        //clear data
        String myjson = event.notification
            .jsonRepresentation()
            .replaceAll(' ', '')
            .replaceAll("\n", "")
            .replaceAll('"{', '{')
            .replaceAll('}"', '}');
        log("Clicked notification: \n $myjson");
        //convert data to json
        Map<String, dynamic> data = (json.decode(myjson)
            as Map<String, dynamic>)['custom']['a'] as Map<String, dynamic>;
        log("data");
        log(data.toString());
        //check the filed 'type' if it is ='chat'
        //go to chat screen with this doctor
        //else if it is medication go to medication screen
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
          if (MotherCubit.get(Get.context).model != null) {
            MotherCubit.get(Get.context)
                .model!
                .medications
                .orEmpty()
                .insert(0, model);
          }
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
