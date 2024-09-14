import 'package:babies_tracker/model/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../app/app_strings.dart';
import '../../../controller/hospital/hospital_cubit.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/const_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';

class EditHospitalScreen extends StatefulWidget {
  const EditHospitalScreen({super.key});

  @override
  State<EditHospitalScreen> createState() => _EditHospitalScreenState();
}

class _EditHospitalScreenState extends State<EditHospitalScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    HospitalCubit cubit = HospitalCubit.get(context);
    if (cubit.hospitalModel != null) {
      phoneController.text = cubit.hospitalModel!.phone ?? '';

      bioController.text = cubit.hospitalModel!.bio ?? '';
      locationController.text = cubit.hospitalModel!.location ?? '';
      cityController.text = cubit.hospitalModel!.city ?? '';
      nameController.text = cubit.hospitalModel!.name ?? '';
      passwordController.text = cubit.hospitalModel!.password ?? '';
    }

    super.initState();
  }

//Make sure that something has changed in the data so that it can be updated.
  // Otherwise, the data will not be updated
  bool isDataChanged(BuildContext context) {
    HospitalCubit cubit = HospitalCubit.get(context);
    return ImageCubit.get(context).image != null ||
        cubit.hospitalModel!.phone != phoneController.text ||
        cubit.hospitalModel!.name != nameController.text ||
        cubit.hospitalModel!.password != passwordController.text ||
        cubit.hospitalModel!.bio != bioController.text ||
        cubit.hospitalModel!.location != locationController.text ||
        cubit.hospitalModel!.city != cityController.text;
  }

  @override
  Widget build(BuildContext context) {
    HospitalCubit cubit = HospitalCubit.get(context);
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.updateUser(AppStrings.hospital)),
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
                          init: cubit.hospitalModel!.image,
                        )),
                    AppSizedBox.h1,
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
                      hintText: "Enter  city",
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
                    AppSizedBox.h3,
                    BlocConsumer<HospitalCubit, HospitalState>(
                      listener: (context, state) {
                        if (state is ScEditHospital) {
                          showFlutterToast(
                            message:
                                AppStrings.userUpdated(AppStrings.hospital),
                            toastColor: Colors.green,
                          );
                          Navigator.pop(context, 'edit');
                        }
                        if (state is ErorrEditHospital) {
                          showFlutterToast(
                            message: state.error,
                            toastColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        HospitalCubit hspitalCubit = HospitalCubit.get(context);
                        return state is LoadingEditHospital
                            ? const CircularProgressComponent()
                            : BottomComponent(
                                child: Text(
                                  AppStrings.updateUser(AppStrings.hospital),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    //if nothing has changed in the data
                                    if (!isDataChanged(context)) {
                                      showFlutterToast(
                                        message: 'No data changed for now!',
                                        toastColor: Colors.red,
                                      );
                                      print('No data changed for now!');
                                    } else {
                                      hspitalCubit.editHospital(
                                          image: ImageCubit.get(context).image,
                                          model: HospitalModel(
                                              image: cubit.hospitalModel?.image,
                                              name: nameController.text,
                                              password: passwordController.text,
                                              phone: phoneController.text,
                                              bio: bioController.text,
                                              city: cityController.text,
                                              location: locationController.text,
                                              online: true));
                                    }
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
