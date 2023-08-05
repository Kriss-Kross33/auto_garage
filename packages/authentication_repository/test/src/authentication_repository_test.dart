// ignore_for_file: must_be_immutable
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'authentication_repository_test.mocks.dart';

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

class FakeAuthProvider extends Fake implements AuthProvider {}

class MockFirebasePlatform with MockPlatformInterfaceMixin {}

class Mocks extends Mock {}

@GenerateMocks([
  firebase_auth.FirebaseAuth,
  firebase_auth.User,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  firebase_auth.UserCredential,
  firebase_auth.AuthCredential,
  AuthProvider,
  FirebasePlatform,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const email = 'kriss@gmail.com';
  const password = 'pAssw0rd@';

  group('AuthenticationRepository', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late GoogleSignIn googleSignIn;
    late AuthenticationRepository authenticationRepository;

    setupFirebaseCoreMocks();

    setUpAll(() async {
      await Firebase.initializeApp();
    });

    setUp(() {
      final mockFirebaseCore = MockFirebaseCore();

      Firebase.delegatePackingProperty = mockFirebaseCore;

      mockFirebaseAuth = MockFirebaseAuth();
      googleSignIn = MockGoogleSignIn();
      authenticationRepository = AuthenticationRepository(
        firebaseAuth: mockFirebaseAuth,
        googleSignIn: googleSignIn,
      );
    });

    test('creates FirebaseAuth instance internally when not injected', () {
      expect(AuthenticationRepository.new, isNot(throwsException));
    });

    group('signup', () {
      setUp(() {
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls createUserWithEmailAndPassword', () async {
        await authenticationRepository.signup(email: email, password: password);
        verify(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.signup(email: email, password: password),
          completes,
        );
      });

      test(
          'throws signupWithEmailAndPasswordFailure '
          'when createUserWithEmailAndPassword throws', () async {
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.signup(email: email, password: password),
          throwsA(isA<SignupWithEmailAndPasswordError>()),
        );
      });
    });

    group('loginWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        when(googleSignInAuthentication.accessToken).thenReturn(accessToken);
        when(googleSignInAuthentication.idToken).thenReturn(idToken);
        when(googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuthentication);
        when(googleSignIn.signIn())
            .thenAnswer((_) async => googleSignInAccount);
        when(mockFirebaseAuth.signInWithCredential(any))
            .thenAnswer((_) => Future.value(MockUserCredential()));
        when(mockFirebaseAuth.signInWithPopup(any))
            .thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await authenticationRepository.loginWithGoogle();
        verify(googleSignIn.signIn()).called(1);
        verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(authenticationRepository.loginWithGoogle(), completes);
      });

      test('throws LoginWithGoogleError when exception occurs', () async {
        when(mockFirebaseAuth.signInWithCredential(any)).thenThrow(Exception());
        expect(
          authenticationRepository.loginWithGoogle(),
          throwsA(isA<LoginWithGoogleError>()),
        );
      });
    });

    group('loginWithEmailAndPassword', () {
      setUp(() {
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signInWithEmailAndPassword', () async {
        await authenticationRepository.loginWithEmailAndPassword(
          email: email,
          password: password,
        );
        verify(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when signInWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.loginWithEmailAndPassword(
            email: email,
            password: password,
          ),
          completes,
        );
      });

      test(
          'throws loginWithEmailAndPasswordFailure '
          'when signInWithEmailAndPassword throws', () async {
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.loginWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<LoginWithEmailAndPasswordFailure>()),
        );
      });
    });

    group('logout', () {
      test('calls signOut', () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        when(googleSignIn.signOut()).thenAnswer((_) async => null);
        await authenticationRepository.logout();
        verify(mockFirebaseAuth.signOut()).called(1);
        verify(googleSignIn.signOut()).called(1);
      });

      test('throws LogoutError when signOut throws', () async {
        when(mockFirebaseAuth.signOut()).thenThrow(Exception());
        expect(
          authenticationRepository.logout(),
          throwsA(isA<LogoutError>()),
        );
      });
    });

    group('user', () {
      test('emits User.empty when firebase user is null', () async {
        when(mockFirebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <UserModel>[UserModel.empty]),
        );
      });
    });
  });
}
