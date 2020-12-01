import 'package:flutter_starterkit_firebase/utils/sort_type.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    //navigateTo('/dashboard');
  }

  String getSortField(SortingType sortingType) {
    switch (sortingType) {
      case SortingType.relevance:
        return 'title';
      case SortingType.low_high:
      case SortingType.high_low:
        return 'price';
      case SortingType.date_added:
        return 'dateCreated';
      default:
        return 'author';
    }
  }


  String getRef() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd kk:mm:s:S').format(now);
    return formattedDate
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll(':', '');
  }
}
