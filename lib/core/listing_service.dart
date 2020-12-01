import 'dart:async';

import 'package:flutter_starterkit_firebase/core/item_service.dart';
import 'package:flutter_starterkit_firebase/core/firestore_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'firestorage_service.dart';

class ListingService extends FirebaseListingService {
  ListingService({
    FirestoreService firestoreService,
    FirebaseStorageService firebaseStorageService,
  }) : super(
          firestoreService: firestoreService ?? FirestoreService(),
          firebaseStorageService: firebaseStorageService ?? FirebaseStorageService(),
        );

  ItemEntity _selectedItem;

  ItemEntity get selectedItem => _selectedItem;
}

/* ************
 * FirebaseListingService
 * ************
 */
class FirebaseListingService with FirebaseServices implements ItemService {
  FirebaseListingService({this.firestoreService, this.firebaseStorageService});

  @override
  final FirestoreService firestoreService;
  @override
  final FirebaseStorageService firebaseStorageService;

  @override
  Stream<List<ItemEntity>> get itemStream {
    return firestoreService.collectionStream(
      path: 'items',
      builder: (data, _) {
        try {
          return ItemEntity.fromMap(data);
        } catch (e) {
          print(e);
          return null;
        }
      },
    );
  }

  // ItemService
  @override
  Future<void> addItem(ItemEntity item, List<Asset> images) async {
    final uid = firestoreService.generateIDForCollection('items');

    final imageUrls = await firebaseStorageService.uploadImages(fileName: 'images/items/$uid/', assets: images);

    if (imageUrls == null || imageUrls.isEmpty) {
      throw 'Failed to upload images properly';
    }

    final mutableItem = item.copyWith(uid: uid, images: imageUrls);
    await firestoreService.setDocData(path: 'items/$uid', data: mutableItem.toMap());
  }

  @override
  Future<List<ItemEntity>> getItems() => itemStream.last;
}
