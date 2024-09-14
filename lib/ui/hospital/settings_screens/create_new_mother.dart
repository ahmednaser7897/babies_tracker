import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/model/doctor_model.dart';
import 'package:babies_tracker/ui/componnents/const_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_prefs.dart';
import '../../../app/app_sized_box.dart';
import '../../../app/app_strings.dart';
import '../../../app/app_validation.dart';
import '../../../controller/hospital/hospital_cubit.dart';
import '../../../model/mother_model.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/widgets.dart';

class AddNewMotherScreen extends StatefulWidget {
  const AddNewMotherScreen({super.key});

  @override
  State<AddNewMotherScreen> createState() => _AddNewMotherScreenState();
}

class _AddNewMotherScreenState extends State<AddNewMotherScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController doctorNotesController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> motherHealthyHistory = [];
  List<String> motherPostpartumHealth = [];
  DoctorModel? doc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.addNewUser(AppStrings.mother)),
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
                      AppSizedBox.h3,
                      const Text(
                        "Doctor",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      pickDoctor(),
                      AppSizedBox.h3,
                      const Text(
                        "Healthy History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      selectFromOptionbs(healthyHistory, motherHealthyHistory),
                      AppSizedBox.h3,
                      const Text(
                        "Postpartum Health",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      selectFromOptionbs(
                          postpartumHealth, motherPostpartumHealth),
                      AppSizedBox.h3,
                      const Text(
                        "address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        hintText: "Enter  address",
                        prefix: Icons.home,
                        validate: (value) {
                          return Validations.normalValidation(value,
                              name: ' address');
                        },
                      ),
                      AppSizedBox.h3,
                      const Text(
                        "Doctor notes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        keyboardType: TextInputType.text,
                        controller: doctorNotesController,
                        hintText: "Enter  doctor notes",
                        prefix: Icons.note,
                        maxLines: 5,
                        validate: (value) {
                          return null;
                        },
                      ),
                      AppSizedBox.h3,
                      BlocConsumer<HospitalCubit, HospitalState>(
                        listener: (context, state) {
                          if (state is ScAddMother) {
                            showFlutterToast(
                              message: AppStrings.userAdded(AppStrings.mother),
                              toastColor: Colors.green,
                            );
                            Navigator.pop(context);
                          }
                          if (state is ErorrAddMother) {
                            showFlutterToast(
                              message: state.error,
                              toastColor: Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          HospitalCubit hospitalCubit =
                              HospitalCubit.get(context);
                          return state is LoadingAddMother
                              ? const CircularProgressComponent()
                              : BottomComponent(
                                  child: Text(
                                    AppStrings.addNewUser(AppStrings.mother),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    //if you didn't choose gender
                                    if (doc == null
                                        // ||
                                        //     motherHealthyHistory.isEmpty ||
                                        //     motherPostpartumHealth.isEmpty
                                        ) {
                                      showFlutterToast(
                                        message: 'You must add all mother data',
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
                                      hospitalCubit.addMother(
                                          image: ImageCubit.get(context).image,
                                          model: MotherModel(
                                              ban: false,
                                              email: emailController.text,
                                              id: null,
                                              image: null,
                                              name: nameController.text,
                                              password: passwordController.text,
                                              phone: phoneController.text,
                                              address: addressController.text,
                                              doctorNotes:
                                                  doctorNotesController.text,
                                              healthyHistory:
                                                  motherHealthyHistory,
                                              postpartumHealth:
                                                  motherPostpartumHealth,
                                              online: false,
                                              leaft: false,
                                              hospitalId: AppPreferences.uId,
                                              docyorlId: doc!.id));
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

  Widget pickDoctor() {
    return Container(
      width: 90.w,
      height: 5.h,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: const Text(
            "Select doctor",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          value: doc,
          onChanged: (DoctorModel? value) {
            if (value != null) {
              setState(() {
                doc = value;
              });
            }
          },
          items: HospitalCubit.get(context).doctors.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value.name ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
