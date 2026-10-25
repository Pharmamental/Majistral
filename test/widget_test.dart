import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game/main.dart';

void main() {
  testWidgets('App launches and shows the home page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Siparişler'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
