import 'package:flutter_test/flutter_test.dart';

import 'package:food_for_thought/app.dart';

void main() {
  testWidgets('tabs switch between Home, Search and Profile', (tester) async {
    await tester.pumpWidget(const FoodForThoughtApp());

    expect(find.text('POPULAR THIS WEEK'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('SEARCH'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text("You're not signed in yet"), findsOneWidget);
  });

  testWidgets('+ button opens the write-a-review sheet', (tester) async {
    await tester.pumpWidget(const FoodForThoughtApp());

    await tester.tap(find.byTooltip('Write a review'));
    await tester.pumpAndSettle();
    expect(find.text('WRITE A REVIEW'), findsOneWidget);
  });
}
