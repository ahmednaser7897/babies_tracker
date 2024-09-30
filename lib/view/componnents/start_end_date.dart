import 'package:babies_tracker/view/componnents/widgets.dart';
import 'package:flutter/material.dart';

import '../../app/app_sized_box.dart';
import '../../app/app_validation.dart';
import 'app_textformfiled_widget.dart';
import 'show_flutter_toast.dart';

class DatesRow extends StatefulWidget {
  const DatesRow(
      {super.key,
      required this.startDateController,
      required this.endDateController,
      this.isEnable = true,
      this.startTitel,
      this.endTitel});
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final String? startTitel;
  final String? endTitel;
  final bool isEnable;

  @override
  State<DatesRow> createState() => _DatesRowState();
}

class _DatesRowState extends State<DatesRow> {
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late bool isEnable;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  @override
  void initState() {
    startDateController = widget.startDateController;
    endDateController = widget.endDateController;
    isEnable = widget.isEnable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.startTitel ?? "Start Date",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AppSizedBox.h2,
              InkWell(
                onTap: isEnable
                    ? () async {
                        DateTime? value = await showDateEPicker(context);
                        if (value != null) {
                          start = value;
                          print('start');
                          print(start);
                          startDateController.text =
                              dateFoemated(start.toString());
                        }
                      }
                    : null,
                child: AppTextFormFiledWidget(
                  isEnable: false,
                  controller: startDateController,
                  keyboardType: TextInputType.text,
                  hintText: "Enter Date",
                  prefix: Icons.date_range,
                  validate: (value) {
                    return Validations.normalValidation(value,
                        name: 'your Date');
                  },
                ),
              ),
              AppSizedBox.h3,
              Text(
                widget.endTitel ?? "End Date",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AppSizedBox.h2,
              InkWell(
                onTap: isEnable
                    ? () async {
                        DateTime? value = await showDateEPicker(context);
                        if (value != null) {
                          end = value;
                          print('end');
                          print(end);
                          endDateController.text = dateFoemated(end.toString());
                        }
                      }
                    : null,
                child: AppTextFormFiledWidget(
                  isEnable: false,
                  controller: endDateController,
                  keyboardType: TextInputType.text,
                  hintText: "Enter Date",
                  prefix: Icons.date_range,
                  validate: (value) {
                    if (start.isAfter(end)) {
                      print('First Date must be last end tome');
                      showFlutterToast(
                        message: 'First Date must be last end Date',
                        toastColor: Colors.red,
                      );
                      return 'First Date must be last end Date';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
