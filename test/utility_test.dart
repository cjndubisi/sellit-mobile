import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/firebase_auth_mock.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load();
  serviceUtilsTest();
}

void serviceUtilsTest() {
  final serviceUtilityProvider = ServiceUtilityProvider();
  ItemEntity item;
  String baseUrl;
  User user;
  group('testing building sms/whatsapp url string', () {
    setUp(() {
      baseUrl = DotEnv().env['APP_BASE_URL'];
      user = User.fromFirebaseUser(UserMock());
      item = ItemEntity(
        uid: 'random',
        author: user,
        title: 'title',
        description: 'description',
        price: 20.0,
        location: 'location',
        type: 'type',
        dateCreated: 1586348737122,
        images: ['images'],
      );
    });

    test('build url for whatsapp intent', () {
      expect(
          serviceUtilityProvider.generateURI(
            ContactSellerType.whatsapp,
            item,
          ),
          'https://wa.me/${item.author.phoneNumber}?text=I am interest in your product ${item.title} $baseUrl/${item.uid}');
    });

    test('build url for sms intent', () {
      expect(
          serviceUtilityProvider.generateURI(
            ContactSellerType.sms,
            item,
          ),
          'sms:${item.author.phoneNumber}?body=I am interest in your product ${item.title} $baseUrl/${item.uid}');
    });
  });
}
