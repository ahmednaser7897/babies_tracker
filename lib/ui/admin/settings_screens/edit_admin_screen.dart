import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../app/app_strings.dart';
import '../../../controller/admin/admin_cubit.dart';
import '../../../model/admin_model.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/const_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/widgets.dart';

class EditNewAdminScreen extends StatefulWidget {
  const EditNewAdminScreen({super.key});

  @override
  State<EditNewAdminScreen> createState() => _EditNewAdminScreenState();
}

class _EditNewAdminScreenState extends State<EditNewAdminScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AdminCubit cubit = AdminCubit.get(context);
    if (cubit.adminModel != null) {
      genderController.text = cubit.adminModel!.gender ?? 'male';
      phoneController.text = cubit.adminModel!.phone ?? '';
      nameController.text = cubit.adminModel!.name ?? '';
      passwordController.text = cubit.adminModel!.password ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminCubit cubit = AdminCubit.get(context);
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.updateUser(AppStrings.admin)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSizedBox.h1,
                    Align(
                        alignment: Alignment.center,
                        child: ImageWidget(
                          init: cubit.adminModel!.image,
                        )),
                    const Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter  name",
                      prefix: Icons.person,
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: ' name');
                      },
                    ),
                    AppSizedBox.h3,
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: passwordController,
                      hintText: "Enter  password",
                      prefix: Icons.lock,
                      suffix: Icons.visibility,
                      isPassword: true,
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: ' password');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      hintText: "Enter  phone",
                      prefix: Icons.call,
                      validate: (value) {
                        return Validations.mobileValidation(value,
                            name: ' phone');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    genderWidget(genderController),
                    AppSizedBox.h3,
                    BlocConsumer<AdminCubit, AdminState>(
                      listener: (context, state) {
                        if (state is ScEditAdmin) {
                          showFlutterToast(
                            message: AppStrings.userUpdated(AppStrings.admin),
                            toastColor: Colors.green,
                          );
                          Navigator.pop(context, 'edit');
                        }
                        if (state is ErorrEditAdmin) {
                          showFlutterToast(
                            message: state.error,
                            toastColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        AdminCubit adminCubit = AdminCubit.get(context);
                        return state is LoadingEditAdmin
                            ? const CircularProgressComponent()
                            : BottomComponent(
                                child: Text(
                                  AppStrings.updateUser(AppStrings.admin),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  print("object1");
                                  if (_formKey.currentState!.validate()) {
                                    print("object2");
                                    adminCubit.editAdmin(
                                        image: ImageCubit.get(context).image,
                                        model: AdminModel(
                                          image: cubit.adminModel?.image,
                                          name: nameController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                          gender: genderController.text,
                                        ));
                                  }
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
