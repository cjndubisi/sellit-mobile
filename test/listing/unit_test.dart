import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/firebase_auth_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final FirebaseAuthServiceMock firebaseServiceMock = FirebaseAuthServiceMock();
  final ListingService _listingService = ListingService.fromFirebaseService(firebaseServiceMock);

  group('listing service test', () {
    test('load item successfully', () async {});
  });
}
