import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'constants.dart';

class Repository {
  Repository._internal();

  static final Repository _instance = Repository._internal();

  static Repository getInstance() {
    return _instance;
  }

  Future<bool> isFirstTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(Constants.FIRST_TIME) ?? true;
  }

  Future<void> onBoardingCompleted() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(Constants.FIRST_TIME, false);
    navigateTo('/login');
  }
}
