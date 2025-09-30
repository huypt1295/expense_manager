import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_core/flutter_core.dart';

import '../models/user_profile_model.dart';

@lazySingleton
class ProfileRemoteDataSource {
  ProfileRemoteDataSource(
    this._firestore,
    this._storage,
  );

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  DocumentReference<Map<String, dynamic>> _doc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Stream<UserProfileModel?> watchProfile(String uid) {
    return _doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserProfileModel.fromFirestore(snapshot);
    });
  }

  Future<UserProfileModel?> fetchProfile(String uid) async {
    final snapshot = await _doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    return UserProfileModel.fromFirestore(snapshot);
  }

  Future<void> upsertProfile(UserProfileModel model) {
    return _doc(model.uid).set(
      model.toFirestore(merge: true),
      SetOptions(merge: true),
    );
  }

  Future<String?> uploadAvatar(
    String uid,
    Uint8List bytes, {
    String? fileName,
  }) async {
    final sanitized = (fileName ?? 'avatar.jpg').replaceAll(RegExp('[^a-zA-Z0-9_.-]'), '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage
        .ref()
        .child('users/$uid/avatar/${timestamp}_$sanitized');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }
}
