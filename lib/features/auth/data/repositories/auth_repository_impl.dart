import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:expense_manager/core/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      if (!_googleSignIn.supportsAuthenticate()) {
        throw AuthException(
          'Google sign-in failed',
        );
      }
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return _mapFirebaseUserToEntity(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        e.message ?? 'Google sign-in failed',
        tokenExpired: e.code == 'user-token-expired',
      );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    try {
      final LoginResult result =
          await _facebookAuth.login(permissions: ['email', 'public_profile']);
      if (result.status != LoginStatus.success) return null;

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return _mapFirebaseUserToEntity(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        e.message ?? 'Google sign-in failed',
        tokenExpired: e.code == 'user-token-expired',
      );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
    ]);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUserToEntity);
  }

  @override
  UserEntity? get currentUser =>
      _mapFirebaseUserToEntity(_firebaseAuth.currentUser);

  UserEntity? _mapFirebaseUserToEntity(User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      providerId: user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : null,
    );
  }
}
