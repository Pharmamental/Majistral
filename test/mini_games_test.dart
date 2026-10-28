import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/orders.dart';
import 'package:game/widgets/mini_games.dart';

import 'test_fonts.dart';

const _s = Size(340, 357);
const _dt = 1 / 60;

/// Oyunu girdiyle kare kare ilerletir.
class _Play {
  _Play(this.g) {
    g.init(_s);
  }

  final MiniGame g;
  final i = MiniInput();

  void frames(int n, [void Function(int k)? each]) {
    for (var k = 0; k < n && !g.done; k++) {
      each?.call(k);
      g.update(_dt, i, _s);
      i.taps.clear();
    }
  }

  void tap(Offset p) {
    i
      ..taps.add(p)
      ..down = true
      ..pos = p;
    frames(1);
    i.down = false;
    frames(1);
  }

  void hold(Offset p, double secs) {
    i
      ..down = true
      ..pos = p;
    frames((secs * 60).round());
    i.down = false;
    frames(1);
  }

  /// [center] etrafında saniyede [rps] turla daire çizer.
  void circle(Offset center, double secs, {double rad = 60, double rps = 1.1}) {
    var t = 0.0;
    i.down = true;
    frames((secs * 60).round(), (_) {
      t += _dt;
      final a = t * rps * 2 * pi;
      i.pos = center + Offset(cos(a) * rad, sin(a) * rad);
    });
    i.down = false;
    frames(1);
  }

  void drag(double y, double from, double to, double step) {
    i
      ..down = true
      ..pos = Offset(from, y);
    for (var x = from; (step > 0 ? x <= to : x >= to) && !g.done; x += step) {
      i.pos = Offset(x, y);
      g.update(_dt, i, _s);
    }
    i.down = false;
    frames(1);
  }
}

void main() {
  final w = _s.width, h = _s.height;

  test('Eritme dışındaki her laboratuvar adımının mini oyunu var', () {
    for (final o in prescriptionOrders) {
      for (final s in o.steps) {
        expect(s.interactive || miniGameFor(s.label) != null, isTrue, reason: s.label);
      }
    }
  });

  test('11 mini oyun doğru oynanınca biter ve tam kalite verir', () {
    final results = <String, double>{};
    void play(String step, void Function(_Play p) how) {
      final p = _Play(miniGameFor(step)!);
      how(p);
      expect(p.g.done, isTrue, reason: '$step bitmedi');
      results[step] = p.g.q;
    }

    play('Ezme', (p) {
      final c = Offset(w / 2, h * .52), r = w * .36;
      for (final d in const [Offset(-.35, .1), Offset(.1, -.05), Offset(.38, .12), Offset(-.05, .18)]) {
        p.tap(c + Offset(d.dx * r, d.dy * r));
        p.tap(c + Offset(d.dx * r, d.dy * r));
      }
      p.circle(c, 8);
    });
    play('Levigasyon', (p) {
      for (var k = 0; k < 7; k++) {
        p.tap(Offset(w / 2, 50));
      }
      p.g.act(_s);
      for (var k = 0; k < 10; k++) {
        p.drag(h * (.4 + k * .03), 20, w - 20, 10);
      }
    });
    play('Geometrik seyreltme', (p) {
      for (var k = 0; k < 4; k++) {
        p.hold(Offset(w / 2, h / 2), 1 / .9);
      }
    });
    play('Çözme', (p) => p.circle(Offset(w / 2, h * .48), 10));
    play('Karıştırma', (p) => p.circle(Offset(w / 2, h * .48), 10));
    play('Emülsifikasyon', (p) => p.circle(Offset(w / 2, h * .55), 12));
    play('Soğutma', (p) {
      // Halka çembere otururken (ritmin sonu) bir kez dokun.
      var t = 0.0;
      var tapped = false;
      p.frames(4000, (_) {
        t += _dt;
        final f = (t / .9) % 1;
        if (f > .84 && !tapped) {
          p.i.taps.add(Offset(w / 2, h / 2));
          tapped = true;
        }
        if (f < .5) tapped = false;
      });
    });
    play('Elekten geçirme', (p) {
      p.i
        ..down = true
        ..pos = Offset(w / 2, h / 2);
      for (var k = 0; k < 60; k++) {
        for (var s = 0; s < 6; s++) {
          p.i.pos = Offset(w / 2 + (k.isOdd ? 1 : -1) * s * 12, h / 2);
          p.g.update(_dt, p.i, _s);
        }
      }
      p.i.down = false;
      p.frames(10);
      // Elekte kalan topaklar elek ortasında, yatayda %30–70 arasında.
      for (var x = w * .28; x < w * .72 && !p.g.done; x += 6) {
        p.tap(Offset(x, h * .36));
      }
    });
    play('Şişirme', (p) {
      for (var k = 0; k < 8; k++) {
        p.tap(Offset(w * .12 + (k + .5) * w * .76 / 8, h * .4));
      }
      p.frames(60);
    });
    play('Hacme tamamlama', (p) {
      // Hızlı akış %80'e 3,2 sn; sonra damla damla saniyede %2,5: %90'a 4 sn daha.
      p.hold(Offset(w / 2, h / 2), 3.2);
      p.hold(Offset(w / 2, h / 2), 4);
      p.g.act(_s);
    });
    play('Kapsül doldurma', (p) {
      for (var row = 0; row < 3; row++) {
        p.drag(h * .22 + row * h * .16 + h * .08, w * .1, w * .9, 2);
      }
      p.g.act(_s);
    });

    for (final MapEntry(key: step, value: q) in results.entries) {
      expect(q, greaterThanOrEqualTo(85), reason: '$step kalite $q');
    }
  });

  test('çok hızlı karıştırmak kaliteyi düşürür ama oyun yine biter', () {
    final p = _Play(miniGameFor('Çözme')!);
    p.circle(Offset(w / 2, h * .48), 3, rps: 4);
    expect(p.g.q, lessThan(100));
    p.circle(Offset(w / 2, h * .48), 12);
    expect(p.g.done, isTrue);
    expect(p.g.q, greaterThanOrEqualTo(0));
  });

  testWidgets('mini oyun penceresi telefonda taşmaz; bitince süre başlar', (tester) async {
    await loadAppFonts();
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    var started = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => openMiniGame(
              context,
              from: const Rect.fromLTWH(100, 400, 60, 60),
              magistralName: 'Hidroksietilselüloz Jeli %2,5',
              step: 'Hacme tamamlama',
              game: miniGameFor('Hacme tamamlama')!,
              onDone: () => started++,
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('aç'));
    // Oyun her karede çizildiği için pumpAndSettle bitmez; pencerenin açılışını bekle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Hacme tamamlama'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final gesture = await tester.startGesture(tester.getCenter(find.byType(CustomPaint).last));
    for (var k = 0; k < 40; k++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await gesture.up();
    await tester.tap(find.text('Tamam'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(started, 1);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Hacme tamamlama'), findsNothing);
  });
}
