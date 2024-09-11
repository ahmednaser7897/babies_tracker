class Validations {
  static bool isOnlyNumber(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static bool isOnlyArabicNumber(String? s) {
    var arNumbers = '٠١٢٣٤٥٦٧٨٩'.split('');
    if (s == null) {
      return false;
    }
    return s.split('').every((element) => arNumbers.contains(element));
  }

  static RegExp emailRegix =
      RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$");
  static RegExp capitalLettersRegix = RegExp(r'^(?=.*?[A-Z]).{1,}$');
  static RegExp smallLettersRegix = RegExp(r'^(?=.*?[a-z]).{1,}$');
  static RegExp numbersRegix = RegExp(r'^(?=.*?[0-9]).{1,}$');
  static RegExp arabic = RegExp(r'^[ّء-ي 0-9]+$');
  static RegExp googleMapsPattern = RegExp(
      r'^https:\/\/maps\.app\.goo\.gl\/[a-zA-Z0-9_-]{10,}$',
      // r'^(http:|https:)?\\/\\/(www\\.)?(maps.)?google\\.[a-z.]+\\/maps/?([\\?]|place/*[^@]*)?/*@?(ll=)?(q=)?(([\\?=]?[a-zA-Z]*[+]?)*/?@{0,1})?([0-9]{1,3}\\.[0-9]+(,|&[a-zA-Z]+=)-?[0-9]{1,3}\\.[0-9]+(,?[0-9]+(z|m))?)?(\\/?data=[\\!:\\.\\-0123456789abcdefmsx]+)?',
      //r'^(https?:\/\/)?maps.*$',
      // r'^https?\:\/\/(www\.|maps\.)?google(\.[a-z]+){1,2}\/maps\/?\?([^&]+&)*(ll=-?[0-9]{1,2}\.[0-9]+,-?[0-9]{1,2}\.[0-9]+|q=[^&]+)+($|&)/',
      caseSensitive: false);

  // static RegExp gmailPattern = RegExp(
  //   r'^[a-z0-9](\.?[a-z0-9]){5,}@g(oogle)?mail\.com$',
  //   // r'^[a-z0-9](\.?[a-z0-9]){5,}@g(oogle)?mail\.com$', // Note the escaped dot before 'com'
  // );

  static RegExp english = RegExp('[a-zA-Z]');
  static String? normalValidation(String? value, {required String name}) {
    if (value == null || value.isEmpty) {
      return "Please Enter $name";
    }
    return null;
  }

  static String? isGoogleMapsUrl(String? value, {required String name}) {
    if (value == null || value.isEmpty) {
      return "Please Enter $name";
    }
    if (!googleMapsPattern.hasMatch(value)) {
      return ' $name must ba a correct Google map link';
    }
    return null;
  }

  static String? passwordValidation(String? value, {required String name}) {
    if (value == null || value.isEmpty) {
      return "Please Enter $name";
    }
    if (value.length < 8) {
      return ' $name must  have at least 8 letters';
    }
    if (capitalLettersRegix.hasMatch(value)) {
      return ' $name must not have capital letters';
    }
    return null;
  }

  static String? emailValidation(String? value, {required String name}) {
    return null;
    RegExp specialcharactersRegex =
        RegExp(r'^(?=.*[*"!@#$%^&(){}:;<>,?/~_+-]).{1,}$');
    // print(value);
    // print(specialcharactersRegex.hasMatch(value![0]));
    // print(!value.contains('@gmail.com'));
    print("object1");
    if (value == null || value.isEmpty) {
      print("object2");
      return 'Please enter $name';
    }
    print("object3");
    if (specialcharactersRegex.hasMatch(value[0]) ||
        !value.contains('@gmail.com')) {
      print("object4");
      return 'Please enter a valid email';
    }

    print("object5");
    return null;
  }

  static String? mobileValidation(String? value, {required String name}) {
    if (value == null || value.isEmpty) {
      return 'Please enter $name';
    }
    if (!startsWith05(value)) {
      return 'Phone number must start with 05';
    }
    if (!contains8Digits(value)) {
      return 'Phone number must contain 8 digits';
    }
    return null;
  }

  static bool startsWith05(String number) {
    if (number.isEmpty) {
      return false;
    }
    return number.startsWith('05');
  }

  static bool contains8Digits(String number) {
    if (number.isEmpty) {
      return false;
    }
    return RegExp(r'^\d{8}$').hasMatch(number.substring(2));
  }

  static String? numberValidation(String? value,
      {required String name, bool isInt = false}) {
    RegExp specialcharactersRegex =
        RegExp(r'^(?=.*[*"!@#$%^&(){}:;<>,?/~_+-]).{1,}$');
    if (value == null || value.isEmpty) {
      print(value);
      return 'Please enter $name';
    }

    if (isInt) {
      if (int.tryParse(value) == null) {
        return '$name must Be integer';
      }
    }
    if (capitalLettersRegix.hasMatch(value) ||
        smallLettersRegix.hasMatch(value)) {
      return ' $name must not have  letters';
    }

    if (specialcharactersRegex.hasMatch(value)) {
      return ' $name must not have special characters';
    } else {
      return null;
    }
  }

  // static String? passwordValidation(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return MyApp.tr.pleaseEnterPassword;
  //   }
  //   if (value.length < 6) {
  //     return '${MyApp.tr.pleaseEnter} ${MyApp.tr.passwordMustHaveSixLitters} ';
  //     //return ' من فضلك ادخل كلمة مرور تحتوي علي 6 حروف وارقام';
  //   } else {
  //     if (!capitalLettersRegix.hasMatch(value)) {
  //       return MyApp.tr.passwordHaveCapitalLetters;
  //       //return ' من فضلك ادخل كلمة مرور تحتوي علي حروف كبيره';
  //     } else if (!smallLettersRegix.hasMatch(value)) {
  //       return MyApp.tr.passwordHaveSmallLetters;
  //       //return ' من فضلك ادخل كلمة مرور تحتوي علي حروف صغيره' ;
  //     } else if (!numbersRegix.hasMatch(value)) {
  //       return MyApp.tr.passwordHaveNumber;
  //       //return ' من فضلك ادخل كلمة مرور تحتوي علي ارقام';
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // static String? userNameValidation(
  //     {String? value,
  //     required String name,
  //     int? index,
  //     bool building = false}) {
  //   RegExp specialcharactersRegex =
  //       RegExp(r'^(?=.*[*".!@#$%^&(){}:;<>,.?/~_+-]).{1,}$');
  //   if (value == null || value.isEmpty) {
  //     return '${MyApp.tr.pleaseEnter} $name';
  //   }
  //   if (value[0] == ' ') {
  //     return '$name ${MyApp.tr.mustNotHaveSpace}';
  //   }
  //   if (value.length < 2 && building == false) {
  //     return '$name ${MyApp.tr.mustNotBeLessThentwoLitters}';
  //   } else if (isOnlyNumber(value)) {
  //     return '$name ${MyApp.tr.mustNotHaveNumbrsOnly}';
  //   } else if (isOnlyArabicNumber(value)) {
  //     return '$name ${MyApp.tr.mustNotHaveNumbrsOnly}';
  //   } else if (specialcharactersRegex.hasMatch(value)) {
  //     return '$name ${MyApp.tr.mustNotHaveSpecialcharacters}';
  //   } else if (english.hasMatch(value) && index == 1) {
  //     return MyApp.tr.typeInArabic;
  //   } else if (!english.hasMatch(value) && index == 0) {
  //     return MyApp.tr.typeInEnglish;
  //   } else {
  //     return null;
  //   }
  // }

  // static String? mobileValidation(
  //     {required String? value, required String countryCode}) {
  //   RegExp specialcharactersRegex =
  //       RegExp(r'^(?=.*[*".!@#$%^&(){}:;<>,.?/~_+-]).{1,}$');
  //   if (value == null || value.isEmpty) {
  //     return '${MyApp.tr.pleaseEnter} ${MyApp.tr.phone}';
  //   }
  //   if (value.startsWith(countryCode)) {
  //     return '${MyApp.tr.phone} ${MyApp.tr.mustNotStartWithCountryCode}';
  //   }
  //   if (value.contains(' ')) {
  //     return '${MyApp.tr.phone} ${MyApp.tr.mustNotHaveSpace}';
  //     //return 'رقم الهاتف يجب الا يحتوي علي مسافه';
  //   }
  //   if (capitalLettersRegix.hasMatch(value) ||
  //       smallLettersRegix.hasMatch(value)) {
  //     return '${MyApp.tr.phone} ${MyApp.tr.mustNotHaveLitters}';
  //     //return 'رقم الهاتف يجب الا يحتوي علي حروف';
  //   }
  //   if (specialcharactersRegex.hasMatch(value)) {
  //     return '${MyApp.tr.phone} ${MyApp.tr.mustNotHaveSpecialcharacters}';
  //     //return 'رقم الهاتف يجب الا يحتوي علي حروف مميزه';
  //   }
  //   if (value.length > 11) {
  //     return '${MyApp.tr.phone} ${MyApp.tr.mustNotBeMoreThenEleven}';
  //     //return 'رقم الهاتف يجب الا يحتوي علي حروف مميزه';
  //   }

  //   return null;
  // }

  // static String? confirmValidation(String? value, String input) {
  //   if (value == null || value.isEmpty) {
  //     return MyApp.tr.pleaseEnterPasswordAgien;
  //   }
  //   if (value != input) {
  //     return MyApp.tr.passwordMustMach;
  //   } else {
  //     return null;
  //   }
  // }

  // static String? discValidation(String? value, int? index) {
  //   if (value == null || value.isEmpty) {
  //     return "${MyApp.tr.pleaseEnter} ${MyApp.tr.productDescription}";
  //   } else if (english.hasMatch(value) && index == 1) {
  //     return MyApp.tr.typeInArabic;
  //   } else if (!english.hasMatch(value) && index == 0) {
  //     return MyApp.tr.typeInEnglish;
  //   } else {
  //     return null;
  //   }
  // }
}
