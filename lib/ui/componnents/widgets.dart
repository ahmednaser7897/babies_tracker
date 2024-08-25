import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../app/app_assets.dart';
import '../../app/app_colors.dart';
import '../../app/app_sized_box.dart';
import '../auth/widgets/build_auth_bottom.dart';

Widget dataValue({required name, required String value, IconData? prefix}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      AppSizedBox.h2,
      ListTile(
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
        title: Text(
          value,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
        ),
        leading: prefix != null
            ? Icon(
                prefix,
                size: 18,
                color: AppColors.primerColor,
              )
            : null,
      )
    ],
  );
}

List<String> healthyHistory = const [
  "Diabetes",
  "Hypertension",
  "Heart Disease",
  "Asthma",
  "Thyroid Disorders",
  "Cervical Cancer"
];
List<String> postpartumHealth = const [
  "Postpartum Bleeding",
  "Abdominal Pain",
  "Uterine Contraction",
  "Mastitis",
  "Constipation",
  "Excessive Swelling"
];

Widget selectFromOptionbs(List<String> mainList, List<String> myList) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70.w,
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
                "Select status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: mainList[0],
              onChanged: (String? value) {
                if (value != null && !myList.contains(value)) {
                  setState(() {
                    myList.add(value);
                  });
                }
              },
              items: mainList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
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
        AppSizedBox.h1,
        ListView.separated(
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
                  title: Text(
                    myList[index],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                  ),
                  leading: const Icon(
                    Icons.health_and_safety,
                    size: 18,
                    color: AppColors.primerColor,
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          myList.remove(myList[index]);
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outlined,
                        size: 18,
                        color: AppColors.primerColor,
                      )),
                ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: myList.length)
      ],
    );
  });
}

TimeOfDay parseTimeOfDay(String timeString) {
  // Define the format of the input string
  final format = DateFormat.jm(); // '5:30 PM' format

  // Parse the string into a DateTime object
  final dateTime = format.parse(timeString);

  // Extract hours and minutes
  final hour = dateTime.hour;
  final minute = dateTime.minute;

  // Create and return a TimeOfDay object
  return TimeOfDay(hour: hour, minute: minute);
}

SizedBox scoresIcon(BuildContext context) {
  return SizedBox(
    width: 15.w,
    height: 5.h,
    child: BottomComponent(
      child: const Icon(
        Icons.info,
        color: Colors.white,
        size: 20,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Container(
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: 100,
            width: 100,
            child: Image.asset(AppAssets.scors),
          ),
        );
      },
    ),
  );
}

String dateFoemated(String date) {
  return DateFormat(
    'dd MMM yyyy - hh:mm a',
  ).format(DateTime.parse(date.toString()));
}

Future<DateTime?> showDateEPicker(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(20100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primerColor,
            onPrimary: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primerColor,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    return pickedDate;
  } else {
    return null;
  }
}

Widget genderWidget(TextEditingController genderController,
    {String init = 'male'}) {
  var list = ['male', 'female'];
  if (init == 'female') {
    list = ['female', 'male'];
  }
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      width: 40.w,
      height: 6.5.h,
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
            "Select status",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          value: genderController.text,
          onChanged: (value) {
            setState(() {
              genderController.text = value.toString();
            });
          },
          items: list.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  });
}

Future<TimeOfDay?> showPicker(BuildContext context) async {
  TimeOfDay? pickedDate = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primerColor,
            onPrimary: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primerColor,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    return pickedDate;
  } else {
    return null;
  }
}

Widget settingbuildListItem(BuildContext context,
    {required String title,
    required IconData leadingIcon,
    IconData? tailIcon,
    String? subtitle,
    Function()? onTap}) {
  return ListTile(
    onTap: onTap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    dense: true,
    splashColor: AppColors.primerColor.withOpacity(0.2),
    style: ListTileStyle.list,
    leading: Icon(
      leadingIcon,
      color: AppColors.primerColor,
    ),
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
    subtitle: Text(subtitle ?? ''),
    trailing: Icon(tailIcon),
  );
}

Widget buildHomeItem(
    {required Function ontap,
    required String? image,
    required String assetImage,
    required String name,
    required bool ban,
    bool leaft = false,
    required String des,
    required String id,
    IconData icon = Icons.info_outline,
    bool showOnly = false}) {
  return Builder(builder: (context) {
    return FadeInUp(
      from: 20,
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: 100.w,
        height: 18.h,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              width: 100.w,
              height: 17.h,
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: id,
                      child: CircleAvatar(
                        radius: 33,
                        backgroundImage: (image != null && image.isNotEmpty)
                            ? NetworkImage(image.orEmpty())
                            : AssetImage(
                                assetImage,
                              ) as ImageProvider,
                      ),
                    ),
                    AppSizedBox.w3,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name.orEmpty(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.almarai(
                              color: Colors.black45,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppSizedBox.h2,
                          Text(
                            des.orEmpty(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.almarai(
                              color: Colors.black45,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          AppSizedBox.h1,
                          Text(
                            ban.orFalse() ? 'Banned' : '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.almarai(
                              color: ban.orFalse() ? Colors.red : Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          AppSizedBox.h1,
                          Text(
                            leaft.orFalse() ? 'Cheked out' : '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.almarai(
                              color: ban.orFalse() ? Colors.red : Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSizedBox.w5,
                    InkWell(
                      onTap: () {
                        ontap();
                      },
                      child: Container(
                        width: 14.w,
                        height: 6.5.h,
                        decoration: BoxDecoration(
                          color: AppColors.primer,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
