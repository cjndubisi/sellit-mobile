import 'dart:async';

import 'package:flutter_starterkit_firebase/core/firestore_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';

class ListingService {
  ListingService() : _fireStoreService = FirestoreService();

  const ListingService.fromFirebaseService(FirestoreService fireStoreService) : _fireStoreService = fireStoreService;

  final FirestoreService _fireStoreService;

  Stream<List<ItemEntity>> get itemStream =>
      _fireStoreService.collectionStream(path: 'items', builder: (data, _) => ItemEntity.fromJson(data));

}
