class CurrentUserSnapshot {
  const CurrentUserSnapshot({
    this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  bool get isAuthenticated => (uid ?? '').isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrentUserSnapshot &&
        other.uid == uid &&
        other.displayName == displayName &&
        other.email == email &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode => Object.hash(uid, displayName, email, photoUrl);
}

abstract interface class CurrentUser {
  CurrentUserSnapshot? now();
  Stream<CurrentUserSnapshot?> watch();
}

abstract interface class AccountActions {
  Future<void> signOut();
}
