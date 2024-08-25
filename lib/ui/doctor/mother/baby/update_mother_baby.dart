import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../auth/widgets/build_auth_bottom.dart';
import '../../../componnents/app_textformfiled_widget.dart';
import '../../../componnents/const_widget.dart';
import '../../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../../componnents/image_picker/image_widget.dart';
import '../../../componnents/show_flutter_toast.dart';
import '../../../componnents/widgets.dart';

class EditBabyScreen extends StatefulWidget {
  const EditBabyScreen({super.key, required this.model});
  final BabieModel model;
  @override
  State<EditBabyScreen> createState() => _EditBabyScreenState();
}

class _EditBabyScreenState extends State<EditBabyScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController docNoatesController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController headCircumferenceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController gestationalAgeController = TextEditingController();
  var deliveryType = ["Natural", "Cesarean"];
  String delivery = "Natural";
  var gestationalAge = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var gestational = 0;
  final _formKey = GlobalKey<FormState>();
  List<int> values = [0, 1, 2];
  int activity = 0;
  int appearance = 0;
  int grimace = 0;
  int pulse = 0;
  int respiration = 0;
  late BabieModel model;
  @override
  void initState() {
    model = widget.model;
    nameController.text = model.name ?? '';
    docNoatesController.text = model.doctorNotes ?? '';
    weightController.text = model.birthWeight ?? '';
    heightController.text = model.birthLength ?? '';
    headCircumferenceController.text = model.headCircumference ?? '';
    dateController.text = model.birthDate ?? '';
    gestationalAgeController.text = model.gestationalAge ?? '';
    gestational = int.parse(model.gestationalAge ?? '0');

    activity = model.activity ?? 0;
    appearance = model.appearance ?? 0;
    grimace = model.grimace ?? 0;
    pulse = model.pulse ?? 0;
    respiration = model.respiration ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.updateUser(AppStrings.baby)),
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
                          init: model.photo,
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
                    AppSizedBox.h2,
                    const Text(
                      "Height",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: heightController,
                      prefix: Icons.height,
                      keyboardType: TextInputType.number,
                      hintText: "Enter height",
                      validate: (value) {
                        return Validations.numberValidation(value,
                            name: 'height');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Head circumference",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: headCircumferenceController,
                      prefix: Icons.h_mobiledata_sharp,
                      keyboardType: TextInputType.number,
                      hintText: "Enter Head circumference",
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'Head circumference');
                      },
                    ),
                    AppSizedBox.h3,
                    const Text(
                      "Weight",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: weightController,
                      prefix: Icons.monitor_weight_sharp,
                      keyboardType: TextInputType.number,
                      hintText: "Enter weight",
                      validate: (value) {
                        return Validations.numberValidation(value,
                            name: 'weight');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Dirth Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      readOnly: true,
                      controller: dateController,
                      prefix: Icons.date_range,
                      keyboardType: TextInputType.text,
                      hintText: "Enter date",
                      onTap: () async {
                        var value = await showDateEPicker(context);
                        if (value != null) {
                          dateController.text = dateFoemated(value.toString());
                        }
                      },
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'date');
                      },
                    ),
                    AppSizedBox.h3,
                    findDelevaryValue(delivery, 'Delivery Type', (String val) {
                      delivery = val;
                    }),
                    AppSizedBox.h3,
                    findGestationalAgeValue(gestational, 'Gestational age',
                        (int val) {
                      gestational = val;
                    }),
                    findValue(activity, 'Activity', (int val) {
                      activity = val;
                    }),
                    findValue(appearance, 'Appearance', (int val) {
                      appearance = val;
                    }),
                    findValue(grimace, 'Grimace', (int val) {
                      grimace = val;
                    }),
                    findValue(pulse, 'Pulse', (int val) {
                      pulse = val;
                    }),
                    findValue(respiration, 'Respiration', (int val) {
                      respiration = val;
                    }),
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
                      controller: docNoatesController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter  Doctor notes",
                      prefix: Icons.person,
                      validate: (value) {
                        return null;
                      },
                    ),
                    AppSizedBox.h3,
                    BlocConsumer<DoctorCubit, DoctorState>(
                      listener: (context, state) {
                        if (state is ScEditBaby) {
                          showFlutterToast(
                            message: AppStrings.userUpdated(AppStrings.baby),
                            toastColor: Colors.green,
                          );
                          Navigator.pop(context, 'add');
                        }
                        if (state is ErorrEditBaby) {
                          showFlutterToast(
                            message: state.error,
                            toastColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        DoctorCubit cubit = DoctorCubit.get(context);
                        return state is LoadingEditBaby
                            ? const CircularProgressComponent()
                            : BottomComponent(
                                child: Text(
                                  AppStrings.updateUser(AppStrings.baby),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.editBaby(
                                        image: ImageCubit.get(context).image,
                                        motherId: widget.model.motherId ?? '',
                                        model: BabieModel(
                                            birthDate: dateController.text,
                                            deliveryType: delivery,
                                            gestationalAge:
                                                gestational.toString(),
                                            activity: activity,
                                            appearance: appearance,
                                            grimace: grimace,
                                            pulse: pulse,
                                            respiration: respiration,
                                            headCircumference:
                                                headCircumferenceController
                                                    .text,
                                            doctorNotes:
                                                docNoatesController.text,
                                            birthLength: heightController.text,
                                            birthWeight: weightController.text,
                                            left: false,
                                            motherId: widget.model.motherId,
                                            doctorId: widget.model.doctorId,
                                            name: nameController.text,
                                            photo: model.photo,
                                            id: model.id));
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

  Widget findDelevaryValue(
      String data, String title, Function(String) onchange) {
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
              width: 60.w,
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
                  items: deliveryType.map((value) {
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

  Widget findValue(int data, String title, Function(int) onchange) {
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
              width: 60.w,
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
            const Spacer(),
            scoresIcon(context),
          ],
        ),
        AppSizedBox.h2,
      ],
    );
  }

  Widget findGestationalAgeValue(
      int data, String title, Function(int) onchange) {
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
              width: 60.w,
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
                  items: gestationalAge.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        '$value month',
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
