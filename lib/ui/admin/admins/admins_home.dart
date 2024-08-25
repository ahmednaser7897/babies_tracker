import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../controller/admin/admin_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class AdminsHome extends StatefulWidget {
  const AdminsHome({super.key});

  @override
  State<AdminsHome> createState() => _AdminsHomeState();
}

class _AdminsHomeState extends State<AdminsHome> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      buildWhen: (previous, current) =>
          current is LoadingGetHomeData ||
          current is ScGetHomeData ||
          current is ErorrGetHomeData,
      listener: (context, state) {},
      builder: (context, state) {
        AdminCubit cubit = AdminCubit.get(context);
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
                    buildAdminList(cubit.admins),
                    AppSizedBox.h2,
                  ],
                ),
              ),
            ),
          ),
          isEmpty: false,
          isErorr: state is ErorrGetHomeData,
          isLoading: state is LoadingGetHomeData,
          isSc: state is ScGetHomeData || cubit.admins.isNotEmpty,
        );
      },
    );
  }
}
