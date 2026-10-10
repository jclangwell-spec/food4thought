import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_user.dart';
import 'user_profile.dart';

/// Reading and creating profiles. Screens use this instead of Firestore.
abstract class ProfileRepository {
  Stream<UserProfile?> watch(String uid);

  /// Returns the user's profile, creating it on their first sign-in.
  Future<UserProfile> ensureProfile(AppUser user);
}

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository(this._db, {Random? random})
    : _random = random ?? Random();

  final FirebaseFirestore _db;
  final Random _random;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  /// One document per claimed handle, so no two people share one.
  CollectionReference<Map<String, dynamic>> get _handles =>
      _db.collection('handles');

  @override
  Stream<UserProfile?> watch(String uid) => _users
      .doc(uid)
      .snapshots()
      .map((s) => s.exists ? UserProfile.fromMap(uid, s.data()!) : null);

  @override
  Future<UserProfile> ensureProfile(AppUser user) async {
    final ref = _users.doc(user.uid);
    final existing = await ref.get();
    if (existing.exists) return UserProfile.fromMap(user.uid, existing.data()!);

    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : 'New member';
    final base = handleFromName(name);

    return _db.runTransaction((tx) async {
      final again = await tx.get(ref);
      if (again.exists) return UserProfile.fromMap(user.uid, again.data()!);

      String? handle;
      for (var attempt = 0; attempt < 6 && handle == null; attempt++) {
        final candidate = attempt == 0
            ? base
            : '${base}_${1000 + _random.nextInt(9000)}';
        final taken = await tx.get(_handles.doc(candidate));
        if (!taken.exists) handle = candidate;
      }
      if (handle == null) {
        throw StateError('Could not find a free handle for "$name".');
      }

      tx.set(_handles.doc(handle), {'uid': user.uid});
      tx.set(ref, {
        'displayName': name,
        'handle': handle,
        'photoUrl': null,
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
        'favourites': <Map<String, dynamic>>[],
        'followerCount': 0,
        'followingCount': 0,
        'reviewCount': 0,
      });
      return UserProfile(uid: user.uid, displayName: name, handle: handle);
    });
  }
}
