import 'dart:convert';
import 'dart:developer';

import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/controller/hospital/hospital_cubit.dart';
import 'package:babies_tracker/model/mother/mother_model.dart';
import 'package:babies_tracker/view/doctor/chat/doctor_message_mother_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../app/app_prefs.dart';
import '../../app/icon_broken.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key, this.getHomeData = true});
  final bool getHomeData;
  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (widget.getHomeData) {
      DoctorCubit.get(context).getCurrentDoctorData(homeData: true);
      HospitalCubit.get(context).getHomeData();
    }
    //Listener to coming notifications
    messagesListener();
    super.initState();
  }

  //this fun handels the (on/off)line system
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('did change');
    var cubit = DoctorCubit.get(Get.context);
    if (state == AppLifecycleState.resumed) {
      print('state1');
      print(state);
      cubit.changeDoctorOnline(
          cubit.model!.id.orEmpty(), AppPreferences.hospitalUid, true);
    } else if (state == AppLifecycleState.paused) {
      print('state2');
      print(state);
      cubit.changeDoctorOnline(
          cubit.model!.id.orEmpty(), AppPreferences.hospitalUid, false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
        //go to chat screen with this mother
        if (data['type'] == 'chat') {
          log('go tO chat');
          MotherModel doc = MotherModel.fromJson(data);
          DoctorCubit.get(context).getMessages(
            model: doc,
          );
          await Navigator.push(
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
