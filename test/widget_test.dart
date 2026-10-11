import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_for_thought/app.dart';
import 'package:food_for_thought/data/app_user.dart';
import 'package:food_for_thought/data/profile_repository.dart';

import 'support/fake_auth.dart';

const josh = AppUser(uid: 'josh-uid', displayName: 'Josh Langwell');

Future<void> pumpApp(WidgetTester tester, FakeAuthRepository auth) async {
  await tester.pumpWidget(
    FoodForThoughtApp(
      auth: auth,
      profiles: FirestoreProfileRepository(FakeFirebaseFirestore()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openTab(WidgetTester tester, String name) async {
  await tester.tap(find.byKey(ValueKey('tab-$name')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signing in creates a profile and opens the app', (tester) async {
    await pumpApp(tester, FakeAuthRepository(nextUser: josh));

    expect(find.text('Continue with Google'), findsOneWidget);
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Popular this week'), findsOneWidget);

    await openTab(tester, 'profile');
    expect(find.text('josh_langwell'), findsOneWidget);
    expect(find.text('Josh Langwell'), findsOneWidget);
    expect(find.text('JL'), findsOneWidget);
    expect(find.text('FAVOURITES'), findsOneWidget);
  });

  testWidgets('profile rows switch the segmented tabs', (tester) async {
    await pumpApp(tester, FakeAuthRepository(signedIn: josh));
    await openTab(tester, 'profile');

    await tester.tap(find.text('Wishlist').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Places you want to try'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('FAVOURITES'), findsOneWidget);
  });

  testWidgets('signing out from the menu returns to sign-in', (tester) async {
    await pumpApp(tester, FakeAuthRepository(signedIn: josh));
    await openTab(tester, 'profile');

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('search and activity tabs, and + opens the review sheet', (
    tester,
  ) async {
    await pumpApp(tester, FakeAuthRepository(signedIn: josh));

    await openTab(tester, 'search');
    expect(find.text('Browse by'), findsOneWidget);
    expect(find.text('Cuisine'), findsOneWidget);

    await openTab(tester, 'activity');
    expect(find.text('Activity'), findsOneWidget);

    await tester.tap(find.byTooltip('Write a review'));
    await tester.pumpAndSettle();
    expect(find.text('WRITE A REVIEW'), findsOneWidget);
  });
}
