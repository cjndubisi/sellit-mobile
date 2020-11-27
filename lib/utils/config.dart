import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String baseUrl = DotEnv().env['APP_BASE_URL'];
}