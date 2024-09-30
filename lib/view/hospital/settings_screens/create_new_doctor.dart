import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/view/componnents/const_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_prefs.dart';
import '../../../app/app_sized_box.dart';
import '../../../app/app_strings.dart';
import '../../../app/app_validation.dart';
import '../../../controller/hospital/hospital_cubit.dart';
import '../../../model/doctor/doctor_model.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/widgets.dart';

class CreateNewDoctor extends StatefulWidget {
  const CreateNewDoctor({super.key});

  @override
  State<CreateNewDoctor> createState() => _CreateNewDoctorState();
}

class _CreateNewDoctorState extends State<CreateNewDoctor> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController bioController = TextEditingController();
  String? gender;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.addNewUser(AppStrings.doctor)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Builder(builder: (context) {
              return Form(
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
                      AppSizedBox.h2,
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      genderWidget(
                          initValue: gender,
                          onTap: (String value) {
                            setState(() {
                              gender = value;
                            });
                          }),
                      AppSizedBox.h3,
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
                      BlocConsumer<HospitalCubit, HospitalState>(
                        listener: (context, state) {
                          if (state is ScAddDoctor) {
                            showFlutterToast(
                              message: AppStrings.userAdded(AppStrings.doctor),
                              toastColor: Colors.green,
                            );
                            Navigator.pop(context);
                          }
                          if (state is ErorrAddDoctor) {
                            showFlutterToast(
                              message: state.error,
                              toastColor: Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          HospitalCubit hospitalCubit =
                              HospitalCubit.get(context);
                          return state is LoadingAddDoctor
                              ? const CircularProgressComponent()
                              : BottomComponent(
                                  child: Text(
                                    AppStrings.addNewUser(AppStrings.doctor),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    //if you didn't choose gender
                                    if (gender == null) {
                                      showFlutterToast(
                                        message: 'you must enter gender',
                                        toastColor: Colors.red,
                                      );
                                      return;
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      // email must not has any space
                                      emailController.text = emailController
                                          .text
                                          .replaceAll(' ', '')
                                          .toLowerCase();
                                      hospitalCubit.addDoctor(
                                          image: ImageCubit.get(context).image,
                                          model: DoctorModel(
                                              ban: false,
                                              email: emailController.text,
                                              id: null,
                                              image: null,
                                              name: nameController.text,
                                              password: passwordController.text,
                                              phone: phoneController.text,
                                              gender: gender,
                                              online: false,
                                              bio: bioController.text,
                                              hospitalId: AppPreferences.uId));
                                    }
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
