import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game/main.dart';

void main() {
  testWidgets('kiremit -> MarketScreen -> Geri, repeated', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final kiremitFinder = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == const Color(0xFFB7410E),
    );

    for (var i = 0; i < 3; i++) {
      await tester.tap(kiremitFinder);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after entering MarketScreen, iteration $i');

      await tester.tap(find.text('Geri'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after returning home, iteration $i');
    }
  });

  testWidgets('purple -> OrdersScreen -> Geri, repeated', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final purpleFinder = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == Colors.purple,
    );

    for (var i = 0; i < 3; i++) {
      await tester.tap(purpleFinder);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after entering OrdersScreen, iteration $i');

      await tester.tap(find.text('Geri'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after returning home, iteration $i');
    }
  });

  testWidgets('color buttons -> ColorPage -> Geri, repeated across different colors', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final colorButtonFinders = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).shape == BoxShape.circle &&
          (w.decoration as BoxDecoration).color != null &&
          (w.decoration as BoxDecoration).color != Colors.purple &&
          (w.decoration as BoxDecoration).color != const Color(0xFFB7410E),
    );

    for (var i = 0; i < colorButtonFinders.evaluate().length; i++) {
      await tester.tap(colorButtonFinders.at(i));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after entering ColorPage $i');

      await tester.tap(find.text('Geri'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after returning home from ColorPage $i');
    }
  });

  testWidgets('MarketScreen: Etken maddeler tab lists real active ingredients', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final kiremitFinder = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == const Color(0xFFB7410E),
    );
    await tester.tap(kiremitFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Etken maddeler'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'after opening Etken maddeler tab');
    expect(find.text('Salisilik Asit'), findsOneWidget);

    // Tapping the purchase button on the first ingredient should not crash.
    await tester.tap(find.text('Satın Al').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'after tapping Satın Al');

    await tester.tap(find.text('Geri'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'after returning home');
  });
}
