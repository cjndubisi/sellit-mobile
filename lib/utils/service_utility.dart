import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/config.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

class ServiceUtilityProvider {
  final String _baseURL = Config.baseUrl;

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
          number: item.author.phoneNumber,
          body: 'I am interest in your product ${item.title}',
          productId: item.uid,
        )
      : _generateWhatsAppURI(
          number: item.author.phoneNumber,
          body: 'I am interest in your product ${item.title}',
          productId: item.uid,
        );

  Future<void> sendSms(ContactSellerType type, ItemEntity item) => launch(generateURI(type, item));

  DateTime getCurrentDate() {
    final now = DateTime.now();
    return now;
  }
}

enum ContactSellerType {
  sms,
  whatsapp,
}
