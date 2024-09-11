import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../controller/admin/admin_cubit.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/const_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';

class AddNewHospitalScreen extends StatefulWidget {
  const AddNewHospitalScreen({super.key});

  @override
  State<AddNewHospitalScreen> createState() => _AddNewHospitalScreenState();
}

class _AddNewHospitalScreenState extends State<AddNewHospitalScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.addNewUser(AppStrings.hospital)),
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
                    const Align(
                        alignment: Alignment.center, child: ImageWidget()),
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
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter  email",
                      prefix: Icons.email_rounded,
                      validate: (value) {
                        return Validations.emailValidation(value,
                            name: ' email');
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
                        return Validations.passwordValidation(value,
                            name: ' password');
                      },
                    ),
                    AppSizedBox.h3,
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
                    AppSizedBox.h3,
                    const Text(
                      "City",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter city",
                      prefix: Icons.home,
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: ' city');
                      },
                    ),
                    AppSizedBox.h3,
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: locationController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter  location",
                      prefix: Icons.location_history,
                      validate: (value) {
                        return Validations.isGoogleMapsUrl(value,
                            name: ' location');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Bio",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter  bio",
                      prefix: Icons.info_outline,
                      maxLines: 5,
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: ' bio');
                      },
                    ),
                    AppSizedBox.h3,
                    BlocConsumer<AdminCubit, AdminState>(
                      listener: (context, state) {
                        if (state is ScAddHospital) {
                          showFlutterToast(
                            message: AppStrings.userAdded(AppStrings.hospital),
                            toastColor: Colors.green,
                          );
                          Navigator.pop(context);
                        }
                        if (state is ErorrAddHospital) {
                          showFlutterToast(
                            message: state.error,
                            toastColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        AdminCubit adminCubit = AdminCubit.get(context);
                        return state is LoadingAddHospital
                            ? const CircularProgressComponent()
                            : BottomComponent(
                                child: Text(
                                  AppStrings.addNewUser(AppStrings.hospital),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    emailController.text = emailController.text
                                        .replaceAll(' ', '')
                                        .toLowerCase();
                                    adminCubit.addHospital(
                                        image: ImageCubit.get(context).image,
                                        model: HospitalModel(
                                            ban: false,
                                            email: emailController.text,
                                            id: null,
                                            image: null,
                                            name: nameController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text,
                                            bio: bioController.text,
                                            city: cityController.text,
                                            location: locationController.text,
                                            online: false));
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
