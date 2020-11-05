import 'package:flutter_starterkit_firebase/core/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks/firebase_auth_mock.dart';

final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
final GoogleSignInMock googleSignInMock = GoogleSignInMock();
final FacebookSignInMock facebookSignInMock = FacebookSignInMock();
final GoogleUserMock googleUserMock = GoogleUserMock();
final FirebaseMockAuthResult firebaseMockAuthResult = FirebaseMockAuthResult();
final FirebaseAuthServiceMock firebaseServiceMock = FirebaseAuthServiceMock();
final AuthService auth = AuthService();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final _authService = AuthService.fromFirebaseService(firebaseServiceMock);

  group('auth unit test', () {
    test('successful login with email and password', () async {
      when(firebaseServiceMock.signInWithEmailPassword('adex9ja@yahoo.com', '1111')).thenAnswer((_) async {
        return firebaseMockAuthResult;
      });

      final signedIn = await _authService.verifyUser('adex9ja@yahoo.com', '1111');
      assert(signedIn != null);
      expect(signedIn, firebaseMockAuthResult);
    });

    test('failed login with email / password', () async {
      final signedIn = await _authService.verifyUser('mail', 'pass');
      assert(signedIn == null);
    });

    test('successful user registration', () async {
      when(_authService.registerUser('adex9ja@yahoo.com', '1111', 'Adeyemo Adeolu', '08166767271'))
          .thenAnswer((_) async {
        return firebaseMockAuthResult;
      });

      final userRegistered =
          await _authService.registerUser('adex9ja@yahoo.com', '1111', 'Adeyemo Adeolu', '08166767271');
      assert(userRegistered != null);
      expect(userRegistered, firebaseMockAuthResult);
    });

    test('validate sign out', () async {
      when(firebaseServiceMock.signOut()).thenAnswer((_) async {
        return null;
      });

      await _authService.signOut();
    });

    test('signInWithGoogle', () async {
      when(firebaseServiceMock.googleSignIn()).thenAnswer(
        (_) => Future<FirebaseMockAuthResult>.value(firebaseMockAuthResult),
      );

      await _authService.googleSignIn();
    });
  });
}
