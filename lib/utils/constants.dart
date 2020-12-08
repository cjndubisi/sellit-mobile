class Constants {
  static const String FIRST_TIME = 'is_first_time_b';

  static const String Live = 'Live';
  static const String Draft = 'Draft';
  static const String Sold = 'Sold';

  static const List<String> choices = <String>[Live, Draft, Sold];
}

class Strings {
  static const String passwordValidationError =
      'must contain at least one uppercase letter , must contain at least one digit , must contain at least one special character';
  static const String emailInputError = 'please enter a valid email';
}
