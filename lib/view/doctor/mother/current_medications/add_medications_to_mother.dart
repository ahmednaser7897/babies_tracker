import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/view/componnents/start_end_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../../model/mother/current_medications_model.dart';
import '../../../../model/mother/mother_model.dart';
import '../../../auth/widgets/build_auth_bottom.dart';
import '../../../componnents/app_textformfiled_widget.dart';
import '../../../componnents/const_widget.dart';
import '../../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../../componnents/show_flutter_toast.dart';

class AddMedicationsScreen extends StatefulWidget {
  const AddMedicationsScreen({super.key, required this.model});
  final MotherModel model;
  @override
  State<AddMedicationsScreen> createState() => _AddMedicationsScreenState();
}

class _AddMedicationsScreenState extends State<AddMedicationsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController docNoatesController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController headCircumferenceController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<int> values = [1, 2, 4, 5, 6, 7, 8, 9, 10];
  int? frequency;

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
          title: Text(AppStrings.addNewUser(AppStrings.medications)),
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
                    AppSizedBox.h2,
                    const Text(
                      "Purpose",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: purposeController,
                      prefix: Icons.add_circle,
                      keyboardType: TextInputType.text,
                      hintText: "Enter Purpose",
                      maxLines: 5,
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'Purpose');
                      },
                    ),
                    AppSizedBox.h3,
                    const Text(
                      "Dosage",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: dosageController,
                      prefix: Icons.medical_information,
                      keyboardType: TextInputType.text,
                      hintText: "Enter dosage",
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'dosage');
                      },
                    ),
                    AppSizedBox.h3,
                    DatesRow(
                        endDateController: endDateController,
                        startDateController: startDateController),
                    AppSizedBox.h3,
                    findValue(frequency, 'Frequency', (int val) {
                      frequency = val;
                    }),
                    AppSizedBox.h2,
                    const Text(
                      "Doctor notes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: docNoatesController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter  Doctor notes",
                      prefix: Icons.note,
                      maxLines: 5,
                      validate: (value) {
                        return null;
                      },
                    ),
                    AppSizedBox.h3,
                    BlocConsumer<DoctorCubit, DoctorState>(
                      listener: (context, state) {
                        if (state is ScAddMedications) {
                          showFlutterToast(
                            message:
                                AppStrings.userAdded(AppStrings.medication),
                            toastColor: Colors.green,
                          );
                          Navigator.pop(
                            context,
                          );
                        }
                        if (state is ErorrAddMedications) {
                          showFlutterToast(
                            message: state.error,
                            toastColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        DoctorCubit cubit = DoctorCubit.get(context);
                        return state is LoadingAddMedications
                            ? const CircularProgressComponent()
                            : BottomComponent(
                                child: Text(
                                  AppStrings.addNewUser(AppStrings.medication),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  //if you didn't choose frequency
                                  if (frequency == null) {
                                    showFlutterToast(
                                      message: 'You must add frequency',
                                      toastColor: Colors.red,
                                    );
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    cubit.addMedications(
                                        motherModel: widget.model,
                                        model: CurrentMedicationsModel(
                                          endDate: endDateController.text,
                                          startDate: startDateController.text,
                                          frequency: frequency,
                                          doctorNotes: docNoatesController.text,
                                          purpose: purposeController.text,
                                          dosage: dosageController.text,
                                          motherId: widget.model.id,
                                          docyorlId: widget.model.docyorlId,
                                          name: nameController.text,
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
      ),
    );
  }

  Widget findValue(int? data, String title, Function(int) onchange) {
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
                  onChanged: (int? value) {
                    if (value != null) {
                      onchange(value);
                      setState(() {
                        data = value;
                      });
                    }
                  },
                  items: values.map((value) {
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
