import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../controller/doctor/doctor_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class DoctorMothersScreen extends StatefulWidget {
  const DoctorMothersScreen({super.key});

  @override
  State<DoctorMothersScreen> createState() => _DoctorMothersScreenState();
}

class _DoctorMothersScreenState extends State<DoctorMothersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      buildWhen: (previous, current) =>
          previous is LoadingGetHomeData ||
          current is ScGetHomeData ||
          current is ErorrGetHomeData,
      listener: (context, state) {},
      builder: (context, state) {
        DoctorCubit cubit = DoctorCubit.get(context);
        return screenBuilder(
          contant: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSizedBox.h2,
                    buildMothersList(mothers: cubit.mothers),
                    AppSizedBox.h2,
                  ],
                ),
              ),
            ),
          ),
          isEmpty: false,
          isErorr: state is ErorrGetHomeData,
          isLoading: state is LoadingGetHomeData ||
              state is LoadingGetDoctor ||
              state is LoadingChangeDoctorOnline,
          isSc: state is ScGetHomeData || cubit.mothers.isNotEmpty,
        );
      },
    );
  }
}
