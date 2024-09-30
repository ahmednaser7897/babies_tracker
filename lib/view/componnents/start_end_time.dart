import 'package:babies_tracker/view/componnents/widgets.dart';
import 'package:flutter/material.dart';

import '../../app/app_sized_box.dart';
import '../../app/app_validation.dart';
import 'app_textformfiled_widget.dart';
import 'show_flutter_toast.dart';

class TimesRow extends StatefulWidget {
  const TimesRow(
      {super.key,
      required this.startDateController,
      required this.endDateController,
      this.isEnable = true});
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final bool isEnable;

  @override
  State<TimesRow> createState() => _TimesRowState();
}

class _TimesRowState extends State<TimesRow> {
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late bool isEnable;
  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();
  @override
  void initState() {
    startDateController = widget.startDateController;
    endDateController = widget.endDateController;
    isEnable = widget.isEnable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Start Time",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppSizedBox.h2,
        InkWell(
          onTap: isEnable
              ? () async {
                  TimeOfDay? value = await showPicker(context);
                  if (value != null) {
                    start = value;
                    print('start');
                    print(start);
                    startDateController.text = start.format(context);
                  }
                }
              : null,
          child: AppTextFormFiledWidget(
            isEnable: false,
            controller: startDateController,
            keyboardType: TextInputType.text,
            hintText: "Enter Start Time",
            prefix: Icons.date_range,
            validate: (value) {
              return Validations.normalValidation(value,
                  name: 'your Start time');
            },
          ),
        ),
        AppSizedBox.h3,
        const Text(
          "End Time",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppSizedBox.h2,
        InkWell(
          onTap: isEnable
              ? () async {
                  TimeOfDay? value = await showPicker(context);
                  if (value != null) {
                    end = value;
                    print('end');
                    print(end);
                    endDateController.text = end.format(context);
                  }
                }
              : null,
          child: AppTextFormFiledWidget(
            isEnable: false,
            controller: endDateController,
            keyboardType: TextInputType.text,
            hintText: "Enter End Time",
            prefix: Icons.date_range,
            validate: (value) {
              print('object33');
              print(start);
              print(end);
              double startVal = toDouble(start);
              double endVal = toDouble(end);
              if (startVal > endVal) {
                print('start time must be befor end tome');
                showFlutterToast(
                  message: 'start time must be befor end time',
                  toastColor: Colors.red,
                );
                return 'start time must be befor end time';
              }
              print('object44');
              return null;
            },
          ),
        ),
      ],
    );
  }
}

double toDouble(TimeOfDay timeOfDay) {
  print('time');
  print(timeOfDay);
  return timeOfDay.hour + timeOfDay.minute / 60.0;
}
