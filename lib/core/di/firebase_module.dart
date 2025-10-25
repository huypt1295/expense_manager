import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth firebaseAuth() => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore firebaseFirestore() => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseStorage firebaseStorage() => FirebaseStorage.instance;

  @lazySingleton
  GoogleSignIn googleSignIn() => GoogleSignIn.instance;

  @lazySingleton
  FacebookAuth facebookAuth() => FacebookAuth.instance;
}
