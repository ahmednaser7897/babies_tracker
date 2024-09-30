import 'package:babies_tracker/app/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/admin/admin_cubit.dart';
import 'package:babies_tracker/view/componnents/const_widget.dart';

import '../../../model/admin/admin_model.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/widgets.dart';

class AdminDetailsScreen extends StatefulWidget {
  const AdminDetailsScreen({super.key, required this.model});
  final AdminModel model;
  @override
  State<AdminDetailsScreen> createState() => _AdminDetailsScreenState();
}

class _AdminDetailsScreenState extends State<AdminDetailsScreen> {
  late AdminModel model;
  //The current login admin can stop this admin only if it was created before him
  late bool canBan;
  @override
  void initState() {
    model = widget.model;
    super.initState();
    //check if The current login admin was created before this admin
    var date1 = DateTime.parse(model.createdAt.toString());
    var date2 = DateTime.parse(
        AdminCubit.get(context).adminModel!.createdAt.toString());
    canBan = date2.isBefore(date1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.admin)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,

              userImage(),
              AppSizedBox.h2,
              //check if The current login admin was created before this admin
              if (canBan) banWidget(),
              titleAndDescriptionWidget(
                  name: "Name", value: model.name ?? '', prefix: Icons.person),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Email",
                  value: model.email ?? '',
                  prefix: Icons.email_rounded),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Phone", value: model.phone ?? '', prefix: Icons.call),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Gender",
                  value: model.gender ?? '',
                  prefix: Icons.male),
              AppSizedBox.h3,
            ],
          ),
        ),
      ),
    );
  }

  Widget userImage() {
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        Hero(
          tag: model.id.orEmpty(),
          child: imageWithOnlineState(
              uri: model.image,
              type: AppAssets.admin,
              isOnline: model.online.orFalse()),
        ),
      ],
    );
  }

  Widget banWidget() {
    return Builder(builder: (context) {
      return BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is ScChangeAdminBan) {
            setState(() {
              model.ban = !model.ban.orFalse();
            });
            if (model.ban.orFalse()) {
              showFlutterToast(
                message: AppStrings.userIsBaned(AppStrings.admin),
                toastColor: Colors.green,
              );
            } else {
              showFlutterToast(
                message: AppStrings.userIsunBaned(AppStrings.admin),
                toastColor: Colors.green,
              );
            }
          }
        },
        builder: (context, state) {
          return ((state is LoadingChangeAdminBan)
              ? const CircularProgressComponent()
              : Center(
                  child: Switch(
                    value: model.ban.orFalse(),
                    activeColor: Colors.red,
                    splashRadius: 18.0,
                    onChanged: (value) async {
                      await AdminCubit.get(context).changeAdminBan(
                          model.id.orEmpty(), !model.ban.orFalse());
                    },
                  ),
                ));
        },
      );
    });
  }
}
