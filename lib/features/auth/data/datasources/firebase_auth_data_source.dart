import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../models/user_model.dart';

/// Provides access to Firebase Auth SDK and related social providers.
@LazySingleton()
class FirebaseAuthDataSource {
  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  /// Emits the current authenticated user whenever Firebase reports changes.
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
      UserModel.fromFirebaseUserNullable,
    );
  }

  /// Initiates the Google sign-in flow and returns the signed-in user.
  ///
  /// Returns `null` when the user cancels the flow before granting access.
  Future<UserModel?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      if (!_googleSignIn.supportsAuthenticate()) {
        throw AuthException('auth.provider_not_supported');
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return UserModel.fromFirebaseUserNullable(userCredential.user);
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'auth.sign_in_failed',
        tokenExpired: error.code == 'user-token-expired',
      );
    } on AuthException {
      rethrow;
    } catch (error) {
      throw AuthException(error.toString());
    }
  }

  /// Initiates the Facebook sign-in flow and returns the user on success.
  ///
  /// Returns `null` when the user cancels the flow before completing login.
  Future<UserModel?> signInWithFacebook() async {
    try {
      final result = await _facebookAuth.login(
        permissions: const ['email', 'public_profile'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final accessToken = result.accessToken;
          if (accessToken == null) {
            throw AuthException('facebook.access_token_missing');
          }
          final credential = FacebookAuthProvider.credential(
            accessToken.tokenString,
          );
          final userCredential = await _firebaseAuth.signInWithCredential(
            credential,
          );
          return UserModel.fromFirebaseUserNullable(userCredential.user);
        case LoginStatus.cancelled:
          return null;
        case LoginStatus.failed:
        case LoginStatus.operationInProgress:
          throw AuthException(result.message ?? 'facebook.sign_in_failed');
      }
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'auth.sign_in_failed',
        tokenExpired: error.code == 'user-token-expired',
      );
    } on AuthException {
      rethrow;
    } catch (error) {
      throw AuthException(error.toString());
    }
  }

  /// Signs out from Firebase and the linked social providers.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await Future.wait<void>([
      _googleSignIn.signOut().onError(
        (Object error, StackTrace stackTrace) => null,
      ),
      _facebookAuth.logOut().onError(
        (Object error, StackTrace stackTrace) => null,
      ),
    ]);
  }
}
