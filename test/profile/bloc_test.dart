import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/core/profile_service.dart';
import 'package:flutter_starterkit_firebase/listing/profile/bloc/profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  authBlocTest();
}

void authBlocTest() {
  ProfileBloc _profileBloc;

  setUp(() {
    final _profileService = ProfileService(
      ListingService(
        firebaseStorageService: FirebaseStorageServiceMock(),
        firestoreService: FirestoreServiceMock(),
      ),
    );
    _profileBloc = ProfileBloc(service: _profileService);
  });

  group('auth bloc test', () {
    test('initial state is correct', () {
      expect(_profileBloc.state, ProfileInitial());
    });
  });
}
