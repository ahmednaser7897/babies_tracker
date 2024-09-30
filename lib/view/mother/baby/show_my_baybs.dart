import 'package:babies_tracker/controller/mother/mother_cubit.dart';
import 'package:babies_tracker/controller/mother/mother_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_sized_box.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class ShowMyBabys extends StatefulWidget {
  const ShowMyBabys({super.key});

  @override
  State<ShowMyBabys> createState() => _ShowMyBabysState();
}

class _ShowMyBabysState extends State<ShowMyBabys> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<MotherCubit, MotherState>(
      buildWhen: (previous, current) =>
          current is LoadingGetHomeData ||
          current is ScGetHomeData ||
          current is ErorrGetHomeData,
      listener: (context, state) {},
      builder: (context, state) {
        return screenBuilder(
          contant: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBabyList(
                        baby: MotherCubit.get(context).model!.babys ?? []),
                    AppSizedBox.h2,
                  ],
                ),
              ),
            ),
          ),
          isEmpty: false,
          isErorr: state is ErorrGetHomeData,
          isLoading: state is LoadingGetHomeData,
          isSc: state is ScGetHomeData ||
              (MotherCubit.get(context).model!.babys ?? []).isNotEmpty,
        );
      },
    ));
  }
}
