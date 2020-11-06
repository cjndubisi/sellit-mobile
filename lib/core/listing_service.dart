import 'dart:async';

import 'package:flutter_starterkit_firebase/model/item_entity.dart';

import 'firebase_service.dart';

class ListingService {
  ListingService() : _auth = FirebaseService();

  const ListingService.fromFirebaseService(FirebaseService firebaseService) : _auth = firebaseService;

  final FirebaseService _auth;

  Stream<List<ItemEntity>> get itemStream => _auth.itemStream;
}
