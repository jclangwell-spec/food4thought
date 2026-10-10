import 'dart:async';

import 'package:food_for_thought/data/app_user.dart';
import 'package:food_for_thought/data/auth_repository.dart';

/// Signs in as [nextUser] without talking to Google.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? signedIn, this.nextUser}) : _current = signedIn;

  AppUser? _current;
  AppUser? nextUser;
  final _changes = StreamController<AppUser?>.broadcast();

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _current;
    yield* _changes.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    _current = nextUser;
    _changes.add(_current);
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _changes.add(null);
  }
}
