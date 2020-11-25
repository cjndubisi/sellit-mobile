import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_starterkit_firebase/listing/bloc/bloc.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';
import 'package:path/path.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.dart';

void main() {
  setupFirebaseAuthMocks();
  TestWidgetsFlutterBinding.ensureInitialized();
  listingBloc();
}

void listingBloc() {
  ListingBloc listingBloc;

  ListingService _listingService;
  FirestoreServiceMock firestoreServiceMock;

  // From https://github.com/flutter/flutter/issues/20907#issuecomment-466185328
  final _testDirectory = join(
    Directory.current.path,
    Directory.current.path.endsWith('test') ? '' : 'test',
  );
  Future<String> _loadFromAsset() => File('$_testDirectory/resources/dummy.json').readAsString();
  List<ItemEntity> dummy;

  ServiceUtilityProviderMock serviceUtilityProviderMock;

  setUp(() async {
    final str = await _loadFromAsset();
    final json = jsonDecode(str) as List<dynamic>;
    dummy = json.map((dynamic e) => ItemEntity.fromMap(e as Map<String, dynamic>)).toList();

    firestoreServiceMock = FirestoreServiceMock();

    _listingService = ListingService(
      firebaseStorageService: FirebaseStorageServiceMock(),
      firestoreService: firestoreServiceMock,
    );
    serviceUtilityProviderMock = ServiceUtilityProviderMock();
    listingBloc = ListingBloc(service: _listingService, serviceProvider: serviceUtilityProviderMock);
  });

  tearDown(() {
    listingBloc?.close();
  });

  group('listing bloc test', () {
    test('initial state is correct', () {
      expect(listingBloc.state, isA<InitialState>());
    });

    test('load item successfully', () async {
      // Prepare
      final streamController = StreamController<List<ItemEntity>>.broadcast();
      when(firestoreServiceMock.collectionStream<ItemEntity>(path: 'items', builder: anyNamed('builder')))
          .thenAnswer((_) => streamController.stream);

      Timer(const Duration(seconds: 1), () {
        streamController.add(dummy);
      });

      // Act
      listingBloc.add(InActiveSearch());

      // Expect
      listingBloc.getItemStream().listen(
            expectAsync1((List<ItemEntity> event) {
              expect(event.first.price, dummy.first.price);
            }, max: 1),
          );

      expect(
        listingBloc,
        emits(isA<InitialState>()),
      );
    });

    test('navigate to detail page successfully', () async {
      final String str = await _loadFromAsset();
      final List<dynamic> json = jsonDecode(str) as List<dynamic>;
      final List<ItemEntity> dummy = json.map((dynamic e) => ItemEntity.fromMap(e as Map<String, dynamic>)).toList();

      listingBloc.add(ListItemClickEvent(dummy.first));

      expect(listingBloc, emits(isA<NavigateToDetail>()));
    });

    blocTest<ListingBloc, ListingState>(
      'Contact Seller success',
      build: () {
        when(serviceUtilityProviderMock.sendSms(
          ContactSellerType.whatsapp,
          dummy.first,
        )).thenAnswer((realInvocation) async => true);
        return listingBloc;
      },
      act: (bloc) async => bloc.add(ContactSellerEvent(
        ContactSellerType.whatsapp,
        dummy.first,
      )),
      expect: [isA<IsLoading>(), isA<ContactSellerState>()],
      verify: (bloc) => verify(serviceUtilityProviderMock.sendSms(ContactSellerType.whatsapp, dummy.first)).called(1),
    );

    blocTest<ListingBloc, ListingState>(
      'Contact Seller failure',
      build: () {
        when(serviceUtilityProviderMock.sendSms(
          ContactSellerType.whatsapp,
          dummy.first,
        )).thenThrow(Exception());
        return listingBloc;
      },
      act: (bloc) async => bloc.add(ContactSellerEvent(
        ContactSellerType.whatsapp,
        dummy.first,
      )),
      expect: [isA<IsLoading>(), isA<LoadingFailed>()],
    );
  });

  group('search bloc', () {
    test('load items successfully', () {
      final streamController = StreamController<List<ItemEntity>>.broadcast();
      when(firestoreServiceMock.collectionStream<ItemEntity>(path: 'items', builder: anyNamed('builder')))
          .thenAnswer((_) => streamController.stream);

      Timer(const Duration(seconds: 1), () {
        streamController.add(dummy);
      });

      // Act
      listingBloc.add(SearchEvent());

      listingBloc.getItemStream().listen(
            expectAsync1((List<ItemEntity> event) {
              expect(event.first.price, dummy.first.price);
            }, max: 1),
          );

      expect(
        listingBloc,
        emits(isA<SearchingState>()),
      );
    });

    test('search items successfully', () {
      final streamController = StreamController<List<ItemEntity>>.broadcast();
      when(firestoreServiceMock.collectionStream<ItemEntity>(path: 'items', builder: anyNamed('builder')))
          .thenAnswer((_) => streamController.stream);

      Timer(const Duration(seconds: 1), () {
        streamController.add(dummy);
      });

      // Act
      listingBloc.add(SearchEvent(''));

      listingBloc.getItemStream().listen(
            expectAsync1((List<ItemEntity> event) {
              expect(event.first.price, dummy.first.price);
            }, max: 1),
          );

      expect(
        listingBloc,
        emits(isA<SearchingState>()),
      );
    });

    test('returns full list on empty string', () {
      final streamController = StreamController<List<ItemEntity>>.broadcast();
      when(firestoreServiceMock.collectionStream<ItemEntity>(path: 'items', builder: anyNamed('builder')))
          .thenAnswer((_) => streamController.stream);

      Timer(const Duration(seconds: 1), () {
        streamController.add(dummy);
      });

      // Act
      listingBloc.add(SearchEvent(''));

      listingBloc.getItemStream().listen(
            expectAsync1((List<ItemEntity> items) {
              expect(items.length, dummy.length);
            }, max: 1),
          );
    });

    test('returns filtered list by search text', () async {
      final streamController = StreamController<List<ItemEntity>>.broadcast();
      when(firestoreServiceMock.collectionStream<ItemEntity>(path: 'items', builder: anyNamed('builder')))
          .thenAnswer((_) {
        return streamController.stream;
      });

      Timer(const Duration(seconds: 1), () {
        streamController.add(dummy);
      });

      listingBloc.add(SearchEvent('Apple'));

      // .add takes a while for event to pass thought
      await Future.delayed(const Duration(seconds: 1), () {});

      expect(listingBloc.state, SearchingState('Apple'));

      // Act
      listingBloc.getItemStream().listen(
            expectAsync1((List<ItemEntity> items) {
              print(items.length);
              expect(items.first.title.contains('Apple'), true);
            }, count: 1, max: 1),
          );
      // // cause emit on .listen
      Timer(const Duration(milliseconds: 150), () {
        streamController.add(dummy);
      });
    });
  });
}
