import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/ui/componnents/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_colors.dart';
import '../../../../../model/feeding_times_model.dart';
import '../../../../auth/widgets/build_auth_bottom.dart';
import '../../../../componnents/app_textformfiled_widget.dart';
import '../../../../componnents/const_widget.dart';
import '../../../../componnents/show_flutter_toast.dart';

class AddFeedingDetailsScreen extends StatefulWidget {
  const AddFeedingDetailsScreen({super.key, required this.model});
  final BabieModel model;
  @override
  State<AddFeedingDetailsScreen> createState() =>
      _AddFeedingDetailsScreenState();
}

class _AddFeedingDetailsScreenState extends State<AddFeedingDetailsScreen> {
  TextEditingController notesNoatesController = TextEditingController();
  TextEditingController durationDateController = TextEditingController();
  TextEditingController detailsDateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amountDateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var feedTyps = ["Breast Feeding", "Formula Feeding"];
  String? feedQuality;

  List<Feedingdetails> details = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.addNewUser(AppStrings.feeding)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Date",
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
                    return Validations.normalValidation(value, name: 'date');
                  },
                ),
                AppSizedBox.h3,
                const Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppSizedBox.h2,
                AppTextFormFiledWidget(
                  controller: notesNoatesController,
                  keyboardType: TextInputType.text,
                  hintText: "Enter Notes",
                  prefix: Icons.note,
                  maxLines: 5,
                  validate: (value) {
                    return null;
                  },
                ),
                AppSizedBox.h3,
                Row(
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 15.w,
                      height: 5.h,
                      child: BottomComponent(
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          await showMyDialog(context);
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
                AppSizedBox.h3,
                showDetails(),
                AppSizedBox.h3,
                BlocConsumer<DoctorCubit, DoctorState>(
                  listener: (context, state) {
                    if (state is ScAddFeedingTime) {
                      showFlutterToast(
                        message: AppStrings.userAdded(AppStrings.feedings),
                        toastColor: Colors.green,
                      );
                      Navigator.pop(
                        context,
                      );
                    }
                    if (state is ErorrAddFeedingTime) {
                      showFlutterToast(
                        message: state.error,
                        toastColor: Colors.red,
                      );
                    }
                  },
                  builder: (context, state) {
                    DoctorCubit cubit = DoctorCubit.get(context);
                    return state is LoadingAddFeedingTime
                        ? const CircularProgressComponent()
                        : BottomComponent(
                            child: Text(
                              AppStrings.addNewUser(AppStrings.feedings),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (details.isEmpty) {
                                showFlutterToast(
                                  message: 'add feeding details',
                                  toastColor: Colors.red,
                                );
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                cubit.addFeedingTime(
                                    baby: widget.model,
                                    babyId: widget.model.id ?? '',
                                    motherId: widget.model.motherId ?? '',
                                    model: FeedingTimesModel(
                                      details: details,
                                      childId: widget.model.id ?? '',
                                      date: dateController.text,
                                      notes: notesNoatesController.text,
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
    );
  }

  Widget showDetails() {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
              tileColor: Colors.grey[100],
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details[index].feedingDetails.orEmpty(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  AppSizedBox.h1,
                  Text(
                    'Time : ${details[index].feedingTime.orEmpty()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSizedBox.h1,
                  Text(
                    'Amount in (Milliliters) : ${details[index].feedingAmount.orEmpty()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSizedBox.h1,
                  Text(
                    'Duration in (Minutes) : ${details[index].feedingDuration.orEmpty()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      details.remove(details[index]);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_outlined,
                    size: 18,
                    color: AppColors.primerColor,
                  )),
            ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: details.length);
  }

  Future<void> showMyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: _formKey2,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                height: 70.h,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Feeding Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Feeding time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      readOnly: true,
                      controller: timeController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter Feeding time",
                      prefix: Icons.timelapse,
                      onTap: () async {
                        TimeOfDay? value = await showPicker(context);
                        if (value != null) {
                          timeController.text = value.format(context);
                        }
                      },
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'Feeding time');
                      },
                    ),
                    AppSizedBox.h3,
                    const Text(
                      "Feeding amount in (Milliliters)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: amountDateController,
                      keyboardType: TextInputType.number,
                      hintText: "Enter Feeding amount",
                      prefix: Icons.note,
                      validate: (value) {
                        return Validations.numberValidation(value,
                            name: 'Feeding amount');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Feeding duration in (Minutes)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: durationDateController,
                      keyboardType: TextInputType.number,
                      hintText: "Enter Feeding duration",
                      prefix: Icons.note,
                      validate: (value) {
                        return Validations.numberValidation(value,
                            name: 'Feeding duration');
                      },
                    ),
                    AppSizedBox.h3,
                    findValue(feedQuality, 'feed Quality', (String val) {
                      setState(() {
                        feedQuality = val;
                      });
                    }),
                    AppSizedBox.h2,
                    const Spacer(),
                    BottomComponent(
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (feedQuality == null) {
                          showFlutterToast(
                            message: 'You must add feeding quality',
                            toastColor: Colors.red,
                          );
                          return;
                        }
                        if (_formKey2.currentState!.validate()) {
                          setState(() {
                            details.add(Feedingdetails(
                              feedingAmount: amountDateController.text,
                              feedingDetails: feedQuality,
                              feedingDuration: durationDateController.text,
                              feedingTime: timeController.text,
                            ));
                          });
                          amountDateController.text = '';
                          durationDateController.text = '';
                          timeController.text = '';
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
    amountDateController.text = '';

    durationDateController.text = '';
    timeController.text = '';
    feedQuality = null;
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
                  items: feedTyps.map((value) {
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
