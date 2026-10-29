import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  // Tuğrul, 2026-10-29: dar kartta "Levigasyon", "Emülsifikasyon" hece ortasından bölünüyordu.
  testWidgets('laboratuvar kartında tek kelimelik adım adı tek satırda kalır (360 dp)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MajistralApp(store: await JobStore.load(now: () => DateTime(2026, 10, 29, 9))));
    await tester.tap(find.text('Laboratuvar').last);
    await tester.pumpAndSettle();
    for (final t in labTools().where((t) => !t.name.contains(' '))) {
      final text = find.text(t.name).first;
      final paragraph = tester.renderObject<RenderParagraph>(text);
      final lines = paragraph.getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: t.name.length));
      final rows = {for (final b in lines) b.top.round()};
      expect(rows, hasLength(1), reason: t.name);
    }
  });
}
