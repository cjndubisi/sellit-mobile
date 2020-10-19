import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_starterkit_firebase/core/firebase_service.dart';
import 'package:path/path.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/firebase_auth_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ListingBloc listingBloc;
  ListingService _authService;
  FirestoreServiceMock firestoreServiceMock;

  // From https://github.com/flutter/flutter/issues/20907#issuecomment-466185328
  final String _testDirectory = join(
    Directory.current.path,
    Directory.current.path.endsWith('test') ? '' : 'test',
  );
  Future<String> _loadFromAsset() => File('$_testDirectory/resources/dummy.json').readAsString();

  setUp(() {
    firestoreServiceMock = FirestoreServiceMock();
    _authService = ListingService.fromFirebaseService(
      FirebaseService(
        firebaseAuth: FirebaseAuthMock(),
        facebookSignIn: FacebookSignInMock(),
        firestore: firestoreServiceMock,
      ),
    );
    listingBloc = ListingBloc(service: _authService);
  });

  tearDown(() {
    listingBloc?.close();
  });

  group('listing bloc test', () {
    test('initial state is correct', () {
      expect(listingBloc.initialState, InitialState());
    });

    test('load item successfully', () async {
      // Prepare
      final String str = await _loadFromAsset();
      final List<dynamic> json = jsonDecode(str) as List<dynamic>;
      final List<ItemEntity> dummy = json.map((dynamic e) => ItemEntity.fromJson(e as Map<String, dynamic>)).toList();

      final StreamController<List<ItemEntity>> streamController = StreamController.broadcast();

      when(firestoreServiceMock.collectionStream<ItemEntity>(path: 'items', builder: anyNamed('builder')))
          .thenAnswer((_) => streamController.stream);

      Timer(const Duration(seconds: 1), () {
        streamController.add(dummy);
      });

      // Act
      listingBloc.add(InActiveSearch());

      // Expect
      listingBloc.itemStream.listen(
        expectAsync1((List<ItemEntity> event) {
          expect(event.first.price, dummy.first.price);
        }, max: 1),
      );

      expect(
        listingBloc,
        emits(InitialState()),
      );
    });
  });
}
