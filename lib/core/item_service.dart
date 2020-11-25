import 'package:flutter_starterkit_firebase/core/firestorage_service.dart';
import 'package:flutter_starterkit_firebase/core/firestore_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

// https://stackoverflow.com/a/45903671/2751762
mixin FirebaseServices {
  FirestoreService firestoreService;
  FirebaseStorageService firebaseStorageService;
}

abstract class ItemService {
  Stream<List<ItemEntity>> get itemStream;
  Future<List<ItemEntity>> getItems();
  Future<List<ItemEntity>> getItemsByState(String state);
  Future<void> addItem(ItemEntity item, List<Asset> images);
}
