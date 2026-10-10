import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
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

void main() {
  testWidgets('signing in creates a profile and opens the app', (tester) async {
    await pumpApp(tester, FakeAuthRepository(nextUser: josh));

    expect(find.text('Continue with Google'), findsOneWidget);
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('POPULAR THIS WEEK'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Josh Langwell'), findsOneWidget);
    expect(find.text('@josh_langwell'), findsOneWidget);
    expect(find.text('JL'), findsOneWidget);
  });

  testWidgets('signing out returns to the sign-in screen', (tester) async {
    await pumpApp(tester, FakeAuthRepository(signedIn: josh));

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('tabs switch and + opens the write-a-review sheet', (
    tester,
  ) async {
    await pumpApp(tester, FakeAuthRepository(signedIn: josh));

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('SEARCH'), findsOneWidget);

    await tester.tap(find.byTooltip('Write a review'));
    await tester.pumpAndSettle();
    expect(find.text('WRITE A REVIEW'), findsOneWidget);
  });
}
