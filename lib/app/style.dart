import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_colors.dart';

import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.ubuntu(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    displayLarge: GoogleFonts.ubuntu(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
    displayMedium: GoogleFonts.ubuntu(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    displaySmall: GoogleFonts.ubuntu(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    headlineMedium: GoogleFonts.ubuntu(
      fontSize: 14.0,
      color: AppColors.black,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.ubuntu(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.ubuntu(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displayLarge: GoogleFonts.ubuntu(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.ubuntu(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.ubuntu(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.ubuntu(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.ubuntu(
      fontSize: 16.0,
      color: AppColors.black,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData lightTheme() {
    return ThemeData(
      fontFamily: 'Ubuntu',
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return AppColors.black;
          },
        ),
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: AppColors.black,
        backgroundColor: AppColors.primerColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarTextStyle: lightTextTheme.bodyMedium,
        titleTextStyle: GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primerColor,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: darkTextTheme,
    );
  }
}

// class Styles {
  
//   static ThemeData themeData(bool isDarkTheme) {
//     return ThemeData(
//         fontFamily: AppTextStyle.mainArFont,
//         primarySwatch: AppColors.mainColor.getMaterialColor(),
//         appBarTheme: const AppBarTheme(
//           // titleSpacing: 20,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           // to control status bar color default = true
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: AppColors.statusBarColorTransparent,
//             statusBarIconBrightness: Brightness.light,
//             statusBarBrightness: Brightness.light,
//           ),
//         ),
//         // primaryColor: isDarkTheme ? AppColors.black : Colors.white,
//         //
//         backgroundColor: AppColors.appBackground,
//         scaffoldBackgroundColor: AppColors.appBackground,
//         //
//         // indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
//         // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
//         //
//         // hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
//         //
//         // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0x640b9490),
//         // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
//         //
//         // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
//         // disabledColor: Colors.grey,
//         // // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
//         // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
//         // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
//         // // buttonTheme: Theme.of(context).buttonTheme.copyWith(
//         // //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
//         // appBarTheme: AppBarTheme(
//         //   elevation: 0.0,
//         // ),
//         brightness: isDarkTheme ? Brightness.dark : Brightness.light);
//   }
// }


