import 'package:authentication_repository/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'errors/errors.dart';

///
class AuthenticationRepository {
  final firebase_auth.FirebaseAuth? _firebaseAuth;
  final GoogleSignIn? _googleSignIn;

  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? cloudFireStore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LoginWithEmailAndPasswordFailure(
          errorMessage: e.message.toString());
    } catch (e) {
      throw LoginWithEmailAndPasswordFailure();
    }
  }

  ///
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      // await _firebaseAuth?.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      await convertUserWithEmail(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignupWithEmailAndPasswordError(errorMessage: e.message.toString());
    } catch (e) {
      throw SignupWithEmailAndPasswordError();
    }
  }

  Future<void> convertUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final _currentUser = currentUser;
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final linkedCred = await _currentUser?.linkWithCredential(credential);
      debugPrint(linkedCred?.user?.email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          debugPrint("The provider has already been linked to the user.");
          await _firebaseAuth?.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        case "invalid-credential":
          debugPrint("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          debugPrint(
              "The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        case "email-already-in-use":
          await _firebaseAuth?.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        default:
          debugPrint("Unknown error. ${e.message}");
      }
    }
  }

  Future<void> convertUserWithGmail(
      firebase_auth.AuthCredential credential) async {
    try {
      await _firebaseAuth?.currentUser?.linkWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          debugPrint("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          debugPrint("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          debugPrint(
              "The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          await _firebaseAuth?.signInWithCredential(credential);
        // See the API reference for the full list of error codes.
        case "email-already-in-use":
          await _firebaseAuth?.signInWithCredential(credential);
          break;

        // See the API reference for the full list of error codes.
        default:
          debugPrint("Unknown error.");
      }
    }
  }

  /// Initaites signin using google.
  ///
  /// Throws a [LoginWithGoogleFailure] when an error occurs.
  Future<void> loginWithGoogle() async {
    try {
      late firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn?.signIn();
      final googleAuth = await googleUser?.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await convertUserWithGmail(credential);
      //  await _firebaseAuth?.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LoginWithGoogleError(errorMessage: e.toString());
    } catch (e) {
      throw LoginWithGoogleError();
    }
  }

  ///
  Stream<UserModel> get user {
    return _firebaseAuth!.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
      debugPrint(user.id);
      return user;
    });
  }

  /// Check if user has started a session
  bool isLoggedIn() {
    if (firebase_auth.FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }

  firebase_auth.User? get currentUser =>
      firebase_auth.FirebaseAuth.instance.currentUser;

  /// Sign a user in anonymously
  Future<firebase_auth.UserCredential> signInAnonymously() async {
    late firebase_auth.UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth!.signInAnonymously();

      final user = userCredential.user!;
      await user.updateDisplayName('Anonymous');
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          debugPrint("Unknown error. ${e.message}");
      }
    }

    return userCredential;
  }

  /// Signs out logged in user
  Future<void> logout() async {
    try {
      await _firebaseAuth?.signOut();
      await _googleSignIn?.signOut();
    } catch (e) {
      throw LogoutError(errorMessage: e.toString());
    }
  }
}

///
extension on firebase_auth.User {
  UserModel get toUser => UserModel(
        id: uid,
        email: email,
        isAnonymous: isAnonymous,
      );
}
