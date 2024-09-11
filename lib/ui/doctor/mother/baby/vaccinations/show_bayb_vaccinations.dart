import 'package:animate_do/animate_do.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/model/vaccinations_histories_model.dart';
import 'package:babies_tracker/ui/doctor/mother/baby/vaccinations/add_accination_to_baby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_colors.dart';
import '../../../../../app/app_prefs.dart';
import '../../../../../app/app_sized_box.dart';
import '../../../../../app/app_strings.dart';
import '../../../../componnents/screen_builder.dart';
import 'vaccinations_details_screen.dart';

class ShowBabyVaccinationss extends StatefulWidget {
  const ShowBabyVaccinationss({super.key, required this.model});
  final BabieModel model;
  @override
  State<ShowBabyVaccinationss> createState() => _ShowBabyVaccinationssState();
}

class _ShowBabyVaccinationssState extends State<ShowBabyVaccinationss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Show Baby vaccinations'),
          actions: [
            if (!widget.model.left.orFalse() &&
                AppPreferences.userType == AppStrings.doctor &&
                widget.model.doctorId == DoctorCubit.get(context).model!.id)
              IconButton(
                  onPressed: () async {
                    var value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddVaccinationsScreen(
                          model: widget.model,
                        ),
                      ),
                    );
                    if (value == 'add') {
                      Navigator.pop(context, 'add');
                    }
                  },
                  icon: const Icon(Icons.add))
          ],
        ),
        body: BlocConsumer<DoctorCubit, DoctorState>(
          buildWhen: (previous, current) =>
              current is LoadingGetHomeData ||
              current is ScGetHomeData ||
              current is ErorrGetHomeData,
          listener: (context, state) {},
          builder: (context, state) {
            return screenBuilder(
              contant: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSizedBox.h2,
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => vaccinationsCard(
                                (widget.model.vaccinations ?? [])[index]),
                            separatorBuilder: (context, index) =>
                                AppSizedBox.h2,
                            itemCount:
                                (widget.model.vaccinations ?? []).length),
                        AppSizedBox.h2,
                      ],
                    ),
                  ),
                ),
              ),
              isEmpty: false,
              isErorr: state is ErorrGetHomeData,
              isLoading: state is LoadingGetHomeData,
              isSc: state is ScGetHomeData ||
                  (widget.model.vaccinations ?? []).isNotEmpty,
            );
          },
        ));
  }

  Widget vaccinationsCard(VaccinationsHistoriesModel model) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VaccinationsDetailsScreen(
                  model: model,
                ),
              ));
        },
        child: FadeInUp(
          from: 20,
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 100.w,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            decoration: BoxDecoration(
              //color: model..orFalse() ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizedBox.w3,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'name : ${model.vaccineName.orEmpty()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      AppSizedBox.w1,
                    ],
                  ),
                  AppSizedBox.h1,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Site : ${model.administrationSite.toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSizedBox.h1,
                  Text(
                    'Vaccination Date : ${model.vaccinationDate.orEmpty()}',
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
                    'Next Dose Date : ${model.nextDoseDate.orEmpty()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
