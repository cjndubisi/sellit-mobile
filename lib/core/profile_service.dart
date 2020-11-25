import 'dart:async';

import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';

class ProfileService {
  ProfileService(ListingService listingService) : _listingService = listingService;

  final ListingService _listingService;

  Stream<List<ItemEntity>> getUserItems(String term) => _listingService.getItemsByStateStream(term);
}
