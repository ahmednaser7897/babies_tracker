import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? sharedPreferences;
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static const String userTokenValue = 'userToken';
  static const String uidValue = 'uid';
  static const String hospitalUidValue = 'hospitalUidValue';
  static const String userTypeValue = 'userType';

  static Future<bool> _putData(String key, dynamic value) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic _getData(String key, dynamic def) {
    var value = sharedPreferences!.get(key);
    return value ?? def;
  }

  static Future<bool> remove(String key) async {
    return await sharedPreferences!.remove(key);
  }

  bool get isUserLogin => _getData(uidValue, "").isNotEmpty;

  static String get uId => _getData(uidValue, "");

  static set uId(String value) {
    _putData(uidValue, value);
  }

  static String get hospitalUid => _getData(hospitalUidValue, "");

  static set hospitalUid(String value) {
    _putData(hospitalUidValue, value);
  }

  static String get userType => _getData(userTypeValue, "");

  static set userType(String value) {
    _putData(userTypeValue, value);
  }

  static String get userToken => _getData(userTokenValue, "");

  static set userToken(String value) {
    _putData(userTokenValue, value);
  }

  static Future<void> logOut() async {
    await AppPreferences.remove(AppPreferences.uidValue);
    await AppPreferences.remove(AppPreferences.userTokenValue);
    await AppPreferences.remove(AppPreferences.hospitalUidValue);
    await AppPreferences.remove(AppPreferences.userTypeValue);
  }

// user data
  // UserModel? get userData {
  //   String data = _getData(_userData, "");
  //   if (data.isEmpty) return null;
  //   return UserModel.fromJson(jsonDecode(_getData(_userData, null)));
  // }

  // set userData(UserModel? user) {
  //   _putData(_userData, jsonEncode(user));
  // } // user data
}
