import 'dart:convert';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_starterkit_firebase/core/item_service.dart';
import 'package:flutter_starterkit_firebase/core/custom_exception.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/listing/add_item/bloc/additem_bloc.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';

import '../mocks.dart';

void main() {
  setupFirebaseAuthMocks();
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  addItemBloc();
  addItemService();
}

void addItemBloc() {
  AdditemBloc additemBloc;
  ItemService addItemService;
  User user;

  ServiceUtilityProviderMock serviceUtilityProviderMock;
  final List<Asset> assetList = [
    Asset('_identifier', '_name', 2, 1),
    Asset('_identifier', '_name', 2, 1),
    Asset('_identifier', '_name', 2, 1),
  ];

  user = User.fromFirebaseUser(UserMock());

  final item = ItemEntity(
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

  // From https://github.com/flutter/flutter/issues/20907#issuecomment-466185328
  final _testDirectory = join(
    Directory.current.path,
    Directory.current.path.endsWith('test') ? '' : 'test',
  );
  Future<String> _loadFromAsset() => File('$_testDirectory/resources/dummy.json').readAsString();
  // ignore: unused_local_variable
  List<ItemEntity> dummy;

  setUp(() async {
    final str = await _loadFromAsset();
    final json = jsonDecode(str) as List<dynamic>;
    dummy = json.map((dynamic e) => ItemEntity.fromMap(e as Map<String, dynamic>)).toList();
    serviceUtilityProviderMock = ServiceUtilityProviderMock();
    addItemService = ItemServiceMock();

    additemBloc = AdditemBloc(addItemService: addItemService, utilityProvider: serviceUtilityProviderMock);
  });

  tearDown(() {
    additemBloc?.close();
  });

  group('AddItemBloc Tests', () {
    test('initial state of bloc', () {
      expect(additemBloc.state, isA<AdditemInitial>());
    });

    blocTest<AdditemBloc, AdditemState>(
      'select an image',
      build: () {
        return additemBloc;
      },
      act: (bloc) => bloc.add(ImageSelectedEvent(assetList)),
      expect: [isA<MultipleImageSelected>()],
    );

    blocTest<AdditemBloc, AdditemState>(
      'successfully adds item',
      build: () {
        when(addItemService.addItem(any, any)).thenAnswer((_) async => null);
        return additemBloc;
      },
      act: (bloc) => bloc.add(
        SubmitAddItemEvent(
          assetList,
          item,
        ),
      ),
      expect: [isA<StartLoading>(), isA<LoadingSuccessful>()],
    );

    blocTest<AdditemBloc, AdditemState>(
      'fails to add item',
      build: () {
        when(addItemService.addItem(item, assetList)).thenThrow(ClientException('could not upload item'));
        return additemBloc;
      },
      act: (bloc) => bloc.add(
        SubmitAddItemEvent(
          assetList,
          item,
        ),
      ),
      expect: [isA<StartLoading>(), isA<LoadingFailed>()],
    );
  });
}

void addItemService() {
  ItemService itemService;
  FirebaseStorageServiceMock storageService;
  FirestoreServiceMock firestoreService;
  User user;

  final List<Asset> assetList = [
    Asset('_identifier', '_name', 2, 1),
    Asset('_identifier', '_name', 2, 1),
    Asset('_identifier', '_name', 2, 1),
  ];

  user = User.fromFirebaseUser(UserMock());
  final List<String> imageUrls = ['url1', 'url2', 'url3'];

  final item = ItemEntity(
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

  setUp(() {
    storageService = FirebaseStorageServiceMock();
    firestoreService = FirestoreServiceMock();
    itemService = ListingService(
      firebaseStorageService: storageService,
      firestoreService: firestoreService,
    );
  });

  group('testing upload to firebase storage and adding item to firestore', () {
    test('successfully upload images to firebase storage', () async {
      const id = 'randomId';
      when(firestoreService.generateIDForCollection('items')).thenAnswer((_) => id);
      when(storageService.uploadImages(fileName: 'images/items/$id/', assets: anyNamed('assets')))
          .thenAnswer((_) async => imageUrls);

      await itemService.addItem(item, assetList);

      verify(firestoreService.generateIDForCollection(any)).called(1);

      final args = verify(firestoreService.setDocData(
        path: captureAnyNamed('path'),
        data: captureAnyNamed('data'),
      )).captured;
      expect(args[0].toString(), 'items/randomId');
      expect(args[1], isMap);
    });
  });
}
