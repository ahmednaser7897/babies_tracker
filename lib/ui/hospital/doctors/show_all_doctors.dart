import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/hospital/hospital_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class ShowAllDoctorsScreen extends StatefulWidget {
  const ShowAllDoctorsScreen({
    super.key,
  });

  @override
  State<ShowAllDoctorsScreen> createState() => _ShowAllDoctorsScreenState();
}

class _ShowAllDoctorsScreenState extends State<ShowAllDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HospitalCubit, HospitalState>(
      buildWhen: (previous, current) =>
          current is LoadingGetHomeData ||
          current is ScGetHomeData ||
          current is ErorrGetHomeData,
      listener: (context, state) {},
      builder: (context, state) {
        HospitalCubit cubit = HospitalCubit.get(context);
        return screenBuilder(
          contant: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDoctorsList(doctors: cubit.doctors),
                  ],
                ),
              ),
            ),
          ),
          isEmpty: false,
          isErorr: state is ErorrGetHomeData,
          isLoading: state is LoadingGetHomeData ||
              state is LoadingGetHospital ||
              state is LoadingChangeHospitalOnline,
          isSc: state is ScGetHomeData || cubit.doctors.isNotEmpty,
        );
      },
    );
  }
}
