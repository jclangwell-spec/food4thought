import 'dart:math';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_for_thought/data/app_user.dart';
import 'package:food_for_thought/data/profile_repository.dart';
import 'package:food_for_thought/data/user_profile.dart';

void main() {
  group('handleFromName', () {
    test('lowercases and joins words with underscores', () {
      expect(handleFromName('Josh Langwell'), 'josh_langwell');
    });
    test('drops accents and punctuation', () {
      expect(handleFromName("  Zoë O'Neill! "), 'zo_o_neill');
    });
    test('caps length at 20 without a trailing underscore', () {
      expect(
        handleFromName('Bartholomew Fitzgerald Smith'),
        'bartholomew_fitzgera',
      );
    });
    test('falls back when nothing usable is left', () {
      expect(handleFromName('李雷'), 'member');
    });
  });

  test('initials use the first and last names', () {
    const p = UserProfile(uid: 'x', displayName: 'Josh Langwell', handle: 'h');
    expect(p.initials, 'JL');
  });

  group('ensureProfile', () {
    late FakeFirebaseFirestore db;
    late FirestoreProfileRepository repo;

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FirestoreProfileRepository(db, random: Random(1));
    });

    test('creates the profile once and returns it on later sign-ins', () async {
      const user = AppUser(uid: 'u1', displayName: 'Josh Langwell');
      final first = await repo.ensureProfile(user);
      final second = await repo.ensureProfile(user);

      expect(first.handle, 'josh_langwell');
      expect(second.handle, 'josh_langwell');
      final users = await db.collection('users').get();
      expect(users.docs, hasLength(1));
      final doc = users.docs.single.data();
      expect(doc['reviewCount'], 0);
      expect(doc['favourites'], isEmpty);
    });

    test(
      'gives a second person with the same name a different handle',
      () async {
        await repo.ensureProfile(
          const AppUser(uid: 'u1', displayName: 'Sam Lee'),
        );
        final other = await repo.ensureProfile(
          const AppUser(uid: 'u2', displayName: 'Sam Lee'),
        );

        expect(other.handle, startsWith('sam_lee_'));
        expect(other.handle, isNot('sam_lee'));
        final handles = await db.collection('handles').get();
        expect(handles.docs.map((d) => d['uid']), containsAll(['u1', 'u2']));
      },
    );

    test('uses a placeholder name when Google gives none', () async {
      final p = await repo.ensureProfile(const AppUser(uid: 'u3'));
      expect(p.displayName, 'New member');
      expect(p.handle, 'new_member');
    });
  });
}
