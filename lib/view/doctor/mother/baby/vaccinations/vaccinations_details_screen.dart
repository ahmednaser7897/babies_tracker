import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/model/baby/vaccinations_histories_model.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../../componnents/start_end_date.dart';
import '../../../../componnents/widgets.dart';

class VaccinationsDetailsScreen extends StatefulWidget {
  const VaccinationsDetailsScreen({super.key, required this.model});
  final VaccinationsHistoriesModel model;
  @override
  State<VaccinationsDetailsScreen> createState() =>
      _VaccinationsDetailsScreenState();
}

class _VaccinationsDetailsScreenState extends State<VaccinationsDetailsScreen> {
  late VaccinationsHistoriesModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.vaccination)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              titleAndDescriptionWidget(
                  name: "Vaccine Name",
                  value: model.vaccineName ?? '',
                  prefix: Icons.person),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Dose",
                  value: model.dose ?? '',
                  prefix: Icons.medical_information),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Administering Entity",
                  value: model.administering.toString(),
                  prefix: Icons.admin_panel_settings),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Administration Site ",
                  value: model.administrationSite ?? '',
                  prefix: Icons.table_chart_sharp),
              AppSizedBox.h3,
              DatesRow(
                  isEnable: false,
                  startTitel: 'Vaccination Date',
                  endTitel: 'Next Dose Date',
                  endDateController:
                      TextEditingController(text: model.vaccinationDate ?? ''),
                  startDateController:
                      TextEditingController(text: model.nextDoseDate ?? '')),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Side Effects",
                  value: model.sideEffects.toString(),
                  prefix: Icons.note),
              AppSizedBox.h3,
            ],
          ),
        ),
      ),
    );
  }
}
