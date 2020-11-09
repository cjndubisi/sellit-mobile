import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  serviceUtilsTest();
}

void serviceUtilsTest() {
  final serviceUtilityProvider = ServiceUtilityProvider();
  ItemEntity item;

  group('testing building sms/whatsapp url string', () {
    setUp(() {
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
          'https://wa.me/${item.author.number}?text=I am interest in your product ${item.title} https://sell.it/${item.id}');
    });

    test('build url for sms intent', () {
      expect(
          serviceUtilityProvider.generateURI(
            ContactSellerType.sms,
            item,
          ),
          'sms:${item.author.number}?body=I am interest in your product ${item.title} https://sell.it/${item.id}');
    });
  });
}
