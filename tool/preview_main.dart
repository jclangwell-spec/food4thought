// Runs the app signed in as Josh with no Firebase, for local screenshots
// where Firebase can't be reached. Not shipped.
//   flutter build web -t tool/preview_main.dart --no-web-resources-cdn
import 'package:flutter/material.dart';
import 'package:food_for_thought/app.dart';
import 'package:food_for_thought/data/app_user.dart';
import 'package:food_for_thought/data/profile_repository.dart';
import 'package:food_for_thought/data/user_profile.dart';

import '../test/support/fake_auth.dart';

const _josh = UserProfile(
  uid: 'josh',
  displayName: 'Josh Langwell',
  handle: 'josh_langwell',
);

class _PreviewProfiles implements ProfileRepository {
  @override
  Stream<UserProfile?> watch(String uid) => Stream.value(_josh);

  @override
  Future<UserProfile> ensureProfile(AppUser user) async => _josh;
}

void main() {
  runApp(
    FoodForThoughtApp(
      auth: FakeAuthRepository(
        signedIn: const AppUser(uid: 'josh', displayName: 'Josh Langwell'),
      ),
      profiles: _PreviewProfiles(),
    ),
  );
}
