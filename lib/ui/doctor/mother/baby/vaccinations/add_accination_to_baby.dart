import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/ui/componnents/start_end_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../../../model/vaccinations_histories_model.dart';
import '../../../../auth/widgets/build_auth_bottom.dart';
import '../../../../componnents/app_textformfiled_widget.dart';
import '../../../../componnents/const_widget.dart';
import '../../../../componnents/show_flutter_toast.dart';

class AddVaccinationsScreen extends StatefulWidget {
  const AddVaccinationsScreen({super.key, required this.model});
  final BabieModel model;
  @override
  State<AddVaccinationsScreen> createState() => _AddVaccinationsScreenState();
}

class _AddVaccinationsScreenState extends State<AddVaccinationsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sideEffectsNoatesController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController administeringController = TextEditingController();
  TextEditingController headCircumferenceController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var administrationSite = ["Arm", "Thigh"];
  String? site;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.addNewUser(AppStrings.vaccination)),
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
                  const Text(
                    "Vaccine name",
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
                      return Validations.normalValidation(value, name: ' name');
                    },
                  ),
                  AppSizedBox.h2,
                  const Text(
                    "Administering Entity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSizedBox.h2,
                  AppTextFormFiledWidget(
                    controller: administeringController,
                    prefix: Icons.admin_panel_settings,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Administering Entity",
                    validate: (value) {
                      return Validations.normalValidation(value,
                          name: 'Administering Entity');
                    },
                  ),
                  AppSizedBox.h3,
                  const Text(
                    "Dose",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSizedBox.h2,
                  AppTextFormFiledWidget(
                    controller: dosageController,
                    prefix: Icons.vaccines,
                    keyboardType: TextInputType.text,
                    hintText: "Enter dosage",
                    validate: (value) {
                      return Validations.normalValidation(value,
                          name: 'dosage');
                    },
                  ),
                  AppSizedBox.h3,
                  findValue(site, 'Administration Site', (String val) {
                    site = val;
                  }),
                  AppSizedBox.h3,
                  DatesRow(
                    endDateController: endDateController,
                    startDateController: startDateController,
                    startTitel: 'Vaccination Date',
                    endTitel: 'Next Dose Date',
                  ),
                  AppSizedBox.h3,
                  const Text(
                    "Side Effects Noates",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSizedBox.h2,
                  AppTextFormFiledWidget(
                    controller: sideEffectsNoatesController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter  Side Effects Noates",
                    prefix: Icons.note,
                    maxLines: 5,
                    validate: (value) {
                      return null;
                    },
                  ),
                  AppSizedBox.h3,
                  BlocConsumer<DoctorCubit, DoctorState>(
                    listener: (context, state) {
                      if (state is ScAddVaccination) {
                        showFlutterToast(
                          message: AppStrings.userAdded(AppStrings.vaccination),
                          toastColor: Colors.green,
                        );
                        Navigator.pop(
                          context,
                        );
                      }
                      if (state is ErorrAddVaccination) {
                        showFlutterToast(
                          message: state.error,
                          toastColor: Colors.red,
                        );
                      }
                    },
                    builder: (context, state) {
                      DoctorCubit cubit = DoctorCubit.get(context);
                      return state is LoadingAddVaccination
                          ? const CircularProgressComponent()
                          : BottomComponent(
                              child: Text(
                                AppStrings.addNewUser(AppStrings.vaccination),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                //if you didn't choose administration site
                                if (site == null) {
                                  showFlutterToast(
                                    message: 'You must add administration site',
                                    toastColor: Colors.red,
                                  );
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  cubit.addVaccination(
                                      baby: widget.model,
                                      motherId: widget.model.motherId ?? '',
                                      model: VaccinationsHistoriesModel(
                                        nextDoseDate: endDateController.text,
                                        vaccinationDate:
                                            startDateController.text,
                                        administrationSite: site,
                                        sideEffects:
                                            sideEffectsNoatesController.text,
                                        dose: dosageController.text,
                                        vaccineName: nameController.text,
                                        administering:
                                            administeringController.text,
                                        babyId: widget.model.id ?? '',
                                        id: null,
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
    );
  }

  Widget findValue(String? data, String title, Function(String) onchange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppSizedBox.h2,
        Row(
          children: [
            Container(
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
                    "Select value",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: data,
                  onChanged: (String? value) {
                    if (value != null) {
                      onchange(value);
                      setState(() {
                        data = value;
                      });
                    }
                  },
                  items: administrationSite.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        AppSizedBox.h2,
      ],
    );
  }
}
