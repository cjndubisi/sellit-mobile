import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load();
  serviceUtilsTest();
}

void serviceUtilsTest() {
  final serviceUtilityProvider = ServiceUtilityProvider();
  ItemEntity item;
  String baseUrl;
  group('testing building sms/whatsapp url string', () {
    setUp(() {
      baseUrl = DotEnv().env['APP_BASE_URL'];
      item = ItemEntity(
        'random',
        User(name: 'Seller', number: '232393232'),
        'title',
        'description',
        20.0,
        'location',
        'type',
        'dateCreated',
        ['images'],
      );
    });

    test('build url for whatsapp intent', () {
      expect(
          serviceUtilityProvider.generateURI(
            ContactSellerType.whatsapp,
            item,
          ),
          'https://wa.me/${item.author.number}?text=I am interest in your product ${item.title} $baseUrl/${item.id}');
    });

    test('build url for sms intent', () {
      expect(
          serviceUtilityProvider.generateURI(
            ContactSellerType.sms,
            item,
          ),
          'sms:${item.author.number}?body=I am interest in your product ${item.title} $baseUrl/${item.id}');
    });
  });
}
