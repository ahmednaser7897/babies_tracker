import 'package:babies_tracker/ui/doctor/mother/current_medications/show_mother_medications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/extensions.dart';

import '../../../app/app_assets.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_prefs.dart';
import '../../../app/icon_broken.dart';
import '../../../controller/mother/mother_cubit.dart';
import '../../../controller/mother/mother_state.dart';
import '../../componnents/const_widget.dart';
import '../../componnents/log_out_button.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/widgets.dart';
import '../pdfs/mother_healthy_information_pdf.dart';
import '../pdfs/show_pdf_screen.dart';
import 'edit_mother_screen.dart';

class MotherSettingsScreen extends StatefulWidget {
  const MotherSettingsScreen({super.key});

  @override
  State<MotherSettingsScreen> createState() => _MotherSettingsScreenState();
}

class _MotherSettingsScreenState extends State<MotherSettingsScreen> {
  bool loding = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MotherCubit, MotherState>(
      buildWhen: (previous, current) =>
          current is LoadingGetMother ||
          current is ScGetMother ||
          current is ErorrGetMother,
      listener: (context, state) {},
      builder: (context, state) {
        MotherCubit cubit = MotherCubit.get(context);
        return screenBuilder(
          contant: Column(
            children: [
              SizedBox(
                width: 100.w,
                height: 20.h,
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 20.h,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 12.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: (cubit.model!.image != null &&
                                        cubit.model!.image!.isNotEmpty)
                                    ? NetworkImage(cubit.model!.image.orEmpty())
                                    : AssetImage(
                                        AppAssets.mother,
                                      ) as ImageProvider,
                              ),
                            ),
                          ),
                          AppSizedBox.w5,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cubit.model!.name.orEmpty(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSizedBox.h3,
                              Text(
                                cubit.model!.email.orEmpty(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 20.h,
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditeMotherScreen(),
                              ));
                        },
                        icon: const Icon(
                          IconBroken.Edit,
                          color: AppColors.primerColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AppSizedBox.h3,
              settingbuildListItem(
                context,
                title: 'Medications',
                leadingIcon: Icons.medical_information,
                subtitle: 'show your medications',
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowMotherMedicationss(
                          model: MotherCubit.get(context).model!,
                        ),
                      ));
                },
              ),
              loding
                  ? const Center(child: CircularProgressComponent())
                  : settingbuildListItem(
                      context,
                      title: 'Your health',
                      leadingIcon: Icons.health_and_safety,
                      subtitle: 'Print as PDF her healthy information',
                      onTap: () async {
                        print(MotherCubit.get(context).model!.healthyHistory);
                        print(MotherCubit.get(context).model!.postpartumHealth);
                        print(MotherCubit.get(context).model!.medications);
                        setState(() {
                          loding = true;
                        });
                        var value = await MotherHealthPdf.generate(
                            MotherCubit.get(context).model!);
                        setState(() {
                          loding = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShowPdf(file: value, uri: ''),
                            ));
                      },
                    ),
              const Spacer(),
              LogOutButton(
                onTap: () async {
                  await MotherCubit.get(context).changeMotherOnline(
                      MotherCubit.get(context).model!.id ?? "",
                      AppPreferences.hospitalUid,
                      false);
                  cubit.changeBottomNavBar(0);
                },
              ),
              AppSizedBox.h3,
            ],
          ),
          isEmpty: false,
          isErorr: state is ErorrGetMother,
          isLoading: state is LoadingGetMother,
          isSc: state is ScGetMother || cubit.model != null,
        );
      },
    );
  }
}
