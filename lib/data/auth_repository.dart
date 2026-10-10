import 'package:firebase_auth/firebase_auth.dart';

import 'app_user.dart';

/// Signing in and out. Screens use this instead of Firebase directly.
abstract class AuthRepository {
  /// Emits the signed-in user, or null when signed out.
  Stream<AppUser?> authStateChanges();

  Future<void> signInWithGoogle();

  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<AppUser?> authStateChanges() => _auth.authStateChanges().map(
    (u) => u == null
        ? null
        : AppUser(uid: u.uid, displayName: u.displayName, email: u.email),
  );

  @override
  Future<void> signInWithGoogle() async {
    // A popup works in Safari as long as it starts from a tap.
    await _auth.signInWithPopup(GoogleAuthProvider());
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
