import 'package:animate_do/animate_do.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/controller/doctor/doctor_cubit.dart';
import 'package:babies_tracker/controller/doctor/doctor_state.dart';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:babies_tracker/ui/doctor/mother/current_medications/medications_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_prefs.dart';
import '../../../../app/app_sized_box.dart';
import '../../../../app/app_strings.dart';
import '../../../../model/current_medications_model.dart';
import '../../../componnents/screen_builder.dart';
import 'add_Medications_to_mother.dart';

class ShowMotherMedicationss extends StatefulWidget {
  const ShowMotherMedicationss({super.key, required this.model});
  final MotherModel model;
  @override
  State<ShowMotherMedicationss> createState() => _ShowMotherMedicationssState();
}

class _ShowMotherMedicationssState extends State<ShowMotherMedicationss> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Show mother meducations'),
              actions: [
                if (!widget.model.leaft.orFalse() &&
                    AppPreferences.userType == AppStrings.doctor &&
                    widget.model.docyorlId ==
                        DoctorCubit.get(context).model!.id)
                  IconButton(
                      onPressed: () async {
                        var value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMedicationsScreen(
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
                                itemBuilder: (context, index) =>
                                    medicationsCard((widget.model.medications ??
                                        [])[index]),
                                separatorBuilder: (context, index) =>
                                    AppSizedBox.h2,
                                itemCount:
                                    (widget.model.medications ?? []).length),
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
                      (widget.model.medications ?? []).isNotEmpty,
                );
              },
            ));
      },
    );
  }

  Widget medicationsCard(CurrentMedicationsModel model) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationsDetailsScreen(
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      AppAssets.vaccination,
                    ),
                  ),
                  AppSizedBox.w5,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ${model.name.orEmpty()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        AppSizedBox.h1,
                        Text(
                          "Frequency : ${model.frequency.toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSizedBox.h1,
                        Text(
                          'from :${model.startDate.orEmpty().split('-')[0]} - to :${model.startDate.orEmpty().split('-')[0]} ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AppSizedBox.h1,
                      ],
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
