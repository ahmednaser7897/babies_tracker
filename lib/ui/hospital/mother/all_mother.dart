import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../controller/hospital/hospital_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class AllMothersScreen extends StatefulWidget {
  const AllMothersScreen({super.key});

  @override
  State<AllMothersScreen> createState() => _AllMothersScreenState();
}

class _AllMothersScreenState extends State<AllMothersScreen> {
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
          isLoading: state is LoadingGetHomeData,
          isSc: state is ScGetHomeData || cubit.mothers.isNotEmpty,
        );
      },
    );
  }
}
