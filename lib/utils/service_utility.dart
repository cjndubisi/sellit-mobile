import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

class ServiceUtilityProvider {
  // TODO(okechukwu): move to base URL Config.BASEURL
  final String _baseURL = 'https://sell.it';

  String _generateSMSURI({
    @required String number,
    @required String body,
    @required String productId,
  }) =>
      'sms:$number?body=$body $_baseURL/$productId';

  String _generateWhatsAppURI({
    @required String number,
    @required String body,
    @required String productId,
  }) =>
      'https://wa.me/$number?text=$body $_baseURL/$productId';

  String generateURI(ContactSellerType type, ItemEntity item) => type == ContactSellerType.sms
      ? _generateSMSURI(
          number: item.author.number,
          body: 'I am interest in your product ${item.title}',
          productId: item.id,
        )
      : _generateWhatsAppURI(
          number: item.author.number,
          body: 'I am interest in your product ${item.title}',
          productId: item.id,
        );

  Future<void> sendSms(ContactSellerType type, ItemEntity item) => launch(generateURI(type, item));
}

enum ContactSellerType {
  sms,
  whatsapp,
}
