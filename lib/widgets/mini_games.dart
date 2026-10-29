import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'grow_panel.dart';

/// Laboratuvar adımlarının mini oyunları (Tuğrul, 2026-10-28): her adımda süre
/// başlamadan önce oyuncu o tekniğin hareketini birkaç saniye yapar. Oyunlar
/// gerçek yapılıştan türetildi (ASHP bülteni, Ankara föyleri, Fırat kılavuzu):
/// ezmede havan elini dairesel sürtmek, şişirmede tozu yüzeye serpmek,
/// hacimde menisküsün alt kenarı gibi. Eritme kendi termometre oyununu kullanır
/// (heating_sheet.dart). Hata kaliteyi düşürür, oyun her zaman biter; kalite
/// şimdilik reçetenin yıldızını etkilemez (karar açık).
///
/// Testler adım akışını oyunsuz sınamak için bunu false yapar.
bool miniGamesEnabled = true;

/// Adımın mini oyunu; yoksa null (Eritme termometreyi kullanır).
MiniGame? miniGameFor(String step) => switch (step) {
      'Ezme' => _Ezme(),
      'Levigasyon' => _Levigasyon(),
      'Geometrik seyreltme' => _Seyreltme(),
      'Çözme' => _Cozme(),
      'Emülsifikasyon' => _Emulsifikasyon(),
      'Soğutma' => _Sogutma(),
      'Elekten geçirme' => _Elek(),
      'Karıştırma' => _Karistirma(),
      'Şişirme' => _Sisirme(),
      'Hacme tamamlama' => _Hacim(),
      'Kapsül doldurma' => _Kapsul(),
      _ => null,
    };

/// Mini oyunu adımın kartının yerinden büyüyen pencerede açar. Oyun bitince
/// [onDone] çağrılır (adımın süresi başlar), sonuç kısa bir an görünür ve
/// pencere kapanır.
Future<void> openMiniGame(
  BuildContext context, {
  required Rect from,
  required String magistralName,
  required String step,
  required MiniGame game,
  required VoidCallback onDone,
}) {
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(magistralName, textAlign: TextAlign.center, style: AppText.label(size: 13)),
          Text(step, textAlign: TextAlign.center, style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.xs),
          Text(game.hint, textAlign: TextAlign.center, style: AppText.body(size: 13, color: AppColors.inkMuted)),
          const SizedBox(height: AppSpace.sm),
          MiniGameView(
            game: game,
            onDone: (_) {
              onDone();
              Future.delayed(const Duration(milliseconds: 1400), () {
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              });
            },
          ),
        ],
      ),
    ),
  );
}

/// Parmağın durumu: basılı mı, nerede, bu karede yeni dokunuşlar.
class MiniInput {
  bool down = false;
  Offset pos = Offset.zero;
  final List<Offset> taps = [];
}

/// Bir mini oyun: [init] boyutu öğrenir, [update] her karede girdiyle ilerler,
/// [paint] çizer. Kalite 100'den düşer, hiçbir zaman sıfırın altına inmez.
abstract class MiniGame {
  String get hint;

  /// Alttaki düğmenin yazısı (Spatülle, Tamam, Bastır); düğme yoksa null.
  String? get action => null;
  double q = 100;
  bool done = false;
  double flash = 0;

  int get stars => q >= 85 ? 3 : q >= 60 ? 2 : 1;

  void hit(double n) {
    q = max(0, q - n);
    flash = .35;
  }

  void init(Size s) {}
  void update(double dt, MiniInput i, Size s);
  void act(Size s) {}
  void paint(Canvas c, Size s);
}

/// Oyunu kare kare çalıştıran ve dokunuşları ileten kutu.
class MiniGameView extends StatefulWidget {
  const MiniGameView({super.key, required this.game, required this.onDone});

  final MiniGame game;
  final ValueChanged<double> onDone;

  @override
  State<MiniGameView> createState() => _MiniGameViewState();
}

class _MiniGameViewState extends State<MiniGameView> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _input = MiniInput();
  Duration _last = Duration.zero;
  Size _size = Size.zero;
  bool _ready = false;
  bool _reported = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration t) {
    final dt = min(.05, (t - _last).inMicroseconds / 1e6);
    _last = t;
    if (!_ready) return;
    final g = widget.game;
    if (!g.done) g.update(dt, _input, _size);
    _input.taps.clear();
    if (g.flash > 0) g.flash -= dt;
    if (g.done && !_reported) {
      _reported = true;
      widget.onDone(g.q);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.game;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(builder: (context, box) {
          final w = min(box.maxWidth, 360.0);
          final size = Size(w, (w * 1.05).roundToDouble());
          if (!_ready) {
            _size = size;
            g.init(size);
            _ready = true;
          }
          _size = size;
          return Center(
            child: Listener(
              onPointerDown: (e) => _input
                ..down = true
                ..pos = e.localPosition
                ..taps.add(e.localPosition),
              onPointerMove: (e) => _input.pos = e.localPosition,
              onPointerUp: (_) => _input.down = false,
              onPointerCancel: (_) => _input.down = false,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.paper),
                  border: Border.all(color: AppColors.line),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.paper),
                  child: CustomPaint(size: size, painter: _GamePainter(g)),
                ),
              ),
            ),
          );
        }),
        if (g.action != null && !g.done) ...[
          const SizedBox(height: AppSpace.sm),
          ChunkyButton.secondary(label: g.action!, onPressed: () => setState(() => g.act(_size))),
        ],
      ],
    );
  }
}

class _GamePainter extends CustomPainter {
  _GamePainter(this.game);

  final MiniGame game;

  @override
  void paint(Canvas c, Size s) {
    game.paint(c, s);
    if (game.flash > 0) {
      c.drawRect(Offset.zero & s, Paint()..color = _red.withValues(alpha: game.flash.clamp(0, 1) * .35));
    }
    _text(c, 'Kalite %${game.q.round()}', const Offset(12, 14), size: 13, color: AppColors.inkMuted, align: TextAlign.left);
    if (game.done) {
      c.drawRect(Rect.fromLTWH(0, s.height * .3, s.width, s.height * .34), Paint()..color = AppColors.surface.withValues(alpha: .93));
      _text(c, 'Tamam!', Offset(s.width / 2, s.height * .38), size: 24);
      _text(c, '★' * game.stars + '☆' * (3 - game.stars), Offset(s.width / 2, s.height * .47), size: 40, color: AppColors.star);
      _text(c, 'Kalite %${game.q.round()}. Süre başladı.', Offset(s.width / 2, s.height * .57), size: 14, color: AppColors.inkMuted);
    }
  }

  @override
  bool shouldRepaint(_GamePainter old) => true;
}

// ---------------------------------------------------------------- çizim

const _red = Color(0xFFC0392B);
const _ok = AppColors.success;
const _okSoft = AppColors.successSoft;
const _porselen = Color(0xFFF4F6F8);
const _porselenD = Color(0xFFC9D0DA);
const _cam = Color(0xFFDCEEF7);
const _camD = Color(0xFF9EC3D6);

double _clamp(double v, [double a = 0, double b = 1]) => v.clamp(a, b).toDouble();

void _text(Canvas c, String t, Offset at,
    {double size = 15, Color color = AppColors.ink, TextAlign align = TextAlign.center, bool bold = true}) {
  final tp = TextPainter(
    text: TextSpan(
      text: t,
      style: bold ? AppText.title(size: size, color: color) : AppText.label(size: size, color: color),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final dx = switch (align) {
    TextAlign.left => at.dx,
    TextAlign.right => at.dx - tp.width,
    _ => at.dx - tp.width / 2,
  };
  tp.paint(c, Offset(dx, at.dy - tp.height / 2));
}

void _circle(Canvas c, Offset o, double r, {Color? fill, Color? stroke, double w = 2}) {
  if (fill != null) c.drawCircle(o, r, Paint()..color = fill);
  if (stroke != null) {
    c.drawCircle(o, r, Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = w);
  }
}

void _rect(Canvas c, Rect r, {Color? fill, Color? stroke, double radius = 4, double w = 2}) {
  final rr = RRect.fromRectAndRadius(r, Radius.circular(radius));
  if (fill != null) c.drawRRect(rr, Paint()..color = fill);
  if (stroke != null) {
    c.drawRRect(rr, Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = w);
  }
}

void _oval(Canvas c, Offset center, double w, double h, {Color? fill, Color? stroke, double sw = 3}) {
  final r = Rect.fromCenter(center: center, width: w, height: h);
  if (fill != null) c.drawOval(r, Paint()..color = fill);
  if (stroke != null) {
    c.drawOval(r, Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw);
  }
}

void _line(Canvas c, Offset a, Offset b, Color color, double w) =>
    c.drawLine(a, b, Paint()
      ..color = color
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round);

/// Alttaki gösterge: [fill] verilirse dolan çubuk, yoksa iğne; [lo]–[hi] yeşil aralık.
void _gauge(Canvas c, Size s, double y, String label, double v, {double? lo, double? hi, Color? fill}) {
  const x = 24.0;
  final w = s.width - 48;
  _text(c, label, Offset(x, y - 12), size: 12, color: AppColors.inkMuted, align: TextAlign.left, bold: false);
  _rect(c, Rect.fromLTWH(x, y, w, 14), fill: AppColors.iconWell, radius: 7);
  if (lo != null && hi != null) {
    final band = Rect.fromLTWH(x + w * lo, y, w * (hi - lo), 14);
    c.drawRect(band, Paint()..color = _okSoft);
    c.drawRect(band, Paint()
      ..color = _ok
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
  }
  if (fill != null) {
    _rect(c, Rect.fromLTWH(x, y, w * _clamp(v), 14), fill: fill, radius: 7);
  } else {
    _rect(c, Rect.fromLTWH(x + w * _clamp(v) - 3, y - 4, 6, 22), fill: AppColors.ink, radius: 3);
  }
}

void _mortar(Canvas c, Offset o, double r, double fill, Color color) {
  final bowl = Path()
    ..moveTo(o.dx - r, o.dy)
    ..arcTo(Rect.fromCircle(center: o, radius: r), pi, -pi, false)
    ..close();
  c.drawPath(bowl, Paint()..color = _porselen);
  c.drawPath(bowl, Paint()
    ..color = _porselenD
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3);
  _oval(c, o, r * 2, r * .6, fill: const Color(0xFFE7EBF0), stroke: _porselenD);
  if (fill > 0) {
    final k = sqrt(fill);
    _oval(c, o + Offset(0, r * .12), r * 1.6 * k, r * .44 * k, fill: color, stroke: const Color(0xFFD9DEE5), sw: 1);
  }
  _rect(c, Rect.fromLTWH(o.dx - r * .35, o.dy + r - 6, r * .7, 12), fill: _porselenD);
}

void _beaker(Canvas c, Rect r, double level, Color color) {
  _rect(c, r, fill: _cam, stroke: _camD, radius: 6);
  if (level > 0) {
    final lh = r.height * _clamp(level);
    _rect(c, Rect.fromLTWH(r.left + 3, r.bottom - lh, r.width - 6, lh - 3), fill: color);
  }
}

/// Bir merkez etrafında dönme: karede dönülen açı ve yumuşatılmış hız (rad/sn).
class _Spin {
  double? _a;
  double speed = 0;

  double step(double dt, MiniInput i, Offset center) {
    if (!i.down) {
      _a = null;
      speed *= .85;
      return 0;
    }
    final na = atan2(i.pos.dy - center.dy, i.pos.dx - center.dx);
    var d = 0.0;
    if (_a != null) {
      d = na - _a!;
      if (d > pi) d -= 2 * pi;
      if (d < -pi) d += 2 * pi;
    }
    _a = na;
    speed = speed * .8 + d.abs() / max(dt, 1e-3) * .2;
    return d.abs();
  }
}

// ---------------------------------------------------------------- oyunlar

/// Ezme: önce iri kristaller kırılır, sonra havan eli bastırarak dairesel sürtülür.
class _Ezme extends MiniGame {
  @override
  String get hint => 'Önce iri kristallere dokunup kır. Sonra havanın içinde parmağınla daire çiz. Çok hızlı çizersen toz kaçar.';
  final _big = [for (final d in const [Offset(-.35, .1), Offset(.1, -.05), Offset(.38, .12), Offset(-.05, .18)]) [d.dx, d.dy, 2.0]];
  final _spin = _Spin();
  double _p = 0, _spill = 0;

  Offset _c(Size s) => Offset(s.width / 2, s.height * .52);
  double _r(Size s) => s.width * .36;
  bool get _crystals => _big.any((b) => b[2] > 0);

  @override
  void update(double dt, MiniInput i, Size s) {
    final c = _c(s), r = _r(s);
    for (final t in i.taps) {
      for (final b in _big) {
        if (b[2] > 0 && (t - (c + Offset(b[0] * r, b[1] * r))).distance < 30) b[2]--;
      }
    }
    if (_crystals) {
      _spin.step(dt, i, c);
      return;
    }
    final d = _spin.step(dt, i, c);
    if (_spin.speed > 14) {
      _spill += dt;
      if (_spill > .25) {
        hit(6);
        _spill = 0;
      }
    } else {
      _p += d * .045;
    }
    if (_p >= 1) done = true;
  }

  @override
  void paint(Canvas c, Size s) {
    final o = _c(s), r = _r(s);
    _mortar(c, o, r, .5, Colors.white);
    for (final b in _big) {
      if (b[2] <= 0) continue;
      c.save();
      c.translate(o.dx + b[0] * r, o.dy + b[1] * r);
      c.rotate(.5);
      _rect(c, const Rect.fromLTWH(-14, -14, 28, 28), fill: const Color(0xFFF7F3EA), stroke: const Color(0xFFB9B2A3), radius: 3);
      if (b[2] < 2) _line(c, const Offset(-10, -8), const Offset(6, 10), const Color(0xFF8A8273), 2);
      c.restore();
    }
    if (!_crystals) {
      final sz = 6 * (1 - _p) + 1.2;
      for (var k = 0; k < 60; k++) {
        final a = k * 2.4, d = (k % 10) / 10 * r * .7;
        _circle(c, Offset(o.dx + cos(a) * d, o.dy + r * .12 + sin(a) * d * .28), sz,
            fill: const Color(0xFFFBF8F1), stroke: const Color(0xFFCFC8B8), w: 1);
      }
      _text(c, _spin.speed > 14 ? 'Yavaşla, toz kaçıyor!' : 'Daire çiz', Offset(s.width / 2, 40),
          color: _spin.speed > 14 ? _red : AppColors.inkMuted);
    }
    _gauge(c, s, s.height - 40, _crystals ? 'Kristalleri kır' : 'İncelik', _p, fill: AppColors.kobalt);
  }
}

/// Levigasyon: toza damla damla az sıvı, kıvam aralıkta; sonra spatülle sürtme.
class _Levigasyon extends MiniGame {
  @override
  String get hint => 'Damlalığa dokun: her dokunuş bir damla gliserol. Kıvam yeşil aralığa gelince "Spatülle"ye bas, sonra parmağını sağa sola sürterek taneleri yok et.';
  @override
  String? get action => _phase == 0 ? 'Spatülle' : null;
  double _k = 0;
  int _phase = 0;
  double? _lx;
  Offset? _finger;
  final _grains = [for (var k = 0; k < 14; k++) [.2 + .6 * ((k * 37) % 14) / 14, .4 + .25 * ((k * 53) % 14) / 14, 1.0]];

  @override
  void act(Size s) {
    if (_phase != 0) return;
    _phase = 1;
    final d = _k < .5 ? .5 - _k : _k > .7 ? _k - .7 : 0.0;
    if (d > 0) hit(d * 150);
  }

  @override
  void update(double dt, MiniInput i, Size s) {
    _finger = i.down ? i.pos : null;
    if (_phase == 0) {
      for (final t in i.taps) {
        if (t.dy < s.height * .3) _k += .085;
      }
      return;
    }
    if (i.down) {
      final lx = _lx;
      if (lx != null) {
        for (final g in _grains) {
          final gx = g[0] * s.width;
          if (g[2] > 0 && (i.pos.dy - g[1] * s.height).abs() < 34 && min(lx, i.pos.dx) <= gx && max(lx, i.pos.dx) >= gx) g[2] = 0;
        }
      }
      _lx = i.pos.dx;
    } else {
      _lx = null;
    }
    if (_grains.every((g) => g[2] == 0)) done = true;
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    _rect(c, Rect.fromLTWH(w / 2 - 14, 30, 28, 56), fill: _cam, stroke: _camD, radius: 6);
    _rect(c, Rect.fromLTWH(w / 2 - 18, 24, 36, 16), fill: const Color(0xFF8A5A3B), radius: 6);
    if (_phase == 0) _text(c, 'dokun', Offset(w / 2 + 52, 58), size: 12, color: AppColors.inkMuted, bold: false);
    _rect(c, Rect.fromLTWH(30, h * .36, w - 60, h * .38), fill: const Color(0xFFE6EEF2), stroke: const Color(0xFFB8C8D2), radius: 6);
    final paste = _k < .5 ? const Color(0xFFE8DFC8) : _k > .7 ? const Color(0xFFF3EEDF) : const Color(0xFFF2EAD6);
    if (_k > .7) _oval(c, Offset(w / 2, h * .6), w * .68, h * .26, fill: const Color(0x80F7F3E8));
    _oval(c, Offset(w / 2, h * .55), w * .56, h * .22, fill: paste, stroke: const Color(0xFFD3C7A8), sw: 1.5);
    for (final g in _grains) {
      if (g[2] > 0) _circle(c, Offset(g[0] * w, g[1] * h), _k < .5 ? 5 : 3.5, fill: const Color(0xFFCDBF9A));
    }
    final f = _finger;
    if (_phase == 1 && f != null) {
      _rect(c, Rect.fromCenter(center: f, width: 80, height: 12), fill: const Color(0xFFB8C2CC), stroke: const Color(0xFF8D98A4), radius: 6);
    }
    if (_phase == 0) {
      _gauge(c, s, h - 40, 'Kıvam', _k, lo: .5, hi: .7);
    } else {
      _gauge(c, s, h - 40, 'Taneler', 1 - _grains.where((g) => g[2] > 0).length / 14, fill: AppColors.kobalt);
    }
  }
}

/// Geometrik seyreltme: her turda havandakinin eşiti kadar baz eklenir (1 › 2 › 4 › 8).
class _Seyreltme extends MiniGame {
  @override
  String get hint => 'Havandaki kadar baz ekle. Basılı tut, sağdaki çubuk havandakiyle eşitlenince bırak. Bunu dört kez yapacaksın.';
  double _m = 1, _add = 0;
  int _round = 0;
  bool _holding = false;
  final _log = <double>[];

  @override
  void update(double dt, MiniInput i, Size s) {
    if (i.down) {
      _holding = true;
      _add += dt * _m * .9;
    } else if (_holding) {
      _holding = false;
      final err = (_add - _m).abs() / _m;
      hit(err * 45);
      _log.add(err);
      _m += _add;
      _add = 0;
      if (++_round >= 4) done = true;
    }
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    // Ölçek her turda havandakinin iki katı sığacak biçimde.
    final scale = (h * .5) / (_m * 2.2), base = h * .78;
    _text(c, 'Tur ${min(_round + 1, 4)} / 4', Offset(w / 2, 40), size: 16);
    _rect(c, Rect.fromLTWH(w * .18, base - _m * scale, 70, _m * scale), fill: const Color(0xFFF1E6CF), stroke: const Color(0xFFC9B98F));
    _text(c, 'Havanda', Offset(w * .18 + 35, base + 16), size: 12, color: AppColors.inkMuted, bold: false);
    _rect(c, Rect.fromLTWH(w * .62, base - _add * scale, 70, _add * scale), fill: const Color(0xFFEAF1F7), stroke: _camD);
    _text(c, 'Eklenen', Offset(w * .62 + 35, base + 16), size: 12, color: AppColors.inkMuted, bold: false);
    final ly = base - _m * scale;
    for (var x = w * .18; x < w * .62 + 80; x += 10) {
      _line(c, Offset(x, ly), Offset(x + 5, ly), AppColors.inkMuted, 1);
    }
    for (var k = 0; k < _log.length; k++) {
      _text(c, _log[k] < .1 ? '✓' : '≈', Offset(40 + k * 24, 66), size: 18, color: _log[k] < .1 ? _ok : AppColors.bekliyor);
    }
    _text(c, _holding ? 'Eşit olunca bırak' : 'Basılı tut', Offset(w / 2, h - 26), color: AppColors.inkMuted);
  }
}

/// Çözme: bagetle uygun hızda karıştırınca kristaller erir; çok hızlı taşar.
class _Cozme extends MiniGame {
  @override
  String get hint => 'Beherin içinde daire çiz. Yeşil hız aralığında karıştır: yavaşsan erimez, çok hızlıysan taşar.';
  final _spin = _Spin();
  double _p = 0, _spill = 0;

  @override
  void update(double dt, MiniInput i, Size s) {
    _finger = i.down ? i.pos : null;
    final d = _spin.step(dt, i, Offset(s.width / 2, s.height * .48));
    if (_spin.speed > 13) {
      _spill += dt;
      if (_spill > .3) {
        hit(6);
        _spill = 0;
      }
    } else if (_spin.speed > 4) {
      _p += d * .03;
    }
    if (_p >= 1) done = true;
  }

  Offset? _finger;

  @override
  void paint(Canvas c, Size s) {
    final r = Rect.fromLTWH(s.width * .2, s.height * .2, s.width * .6, s.height * .55);
    _beaker(c, r, .7, const Color(0xFFE7F3F8));
    final left = (10 * (1 - _p)).ceil();
    for (var k = 0; k < left; k++) {
      _rect(c, Rect.fromLTWH(r.left + 20 + (k * 47) % (r.width - 50), r.bottom - 22 - (k * 13) % 10, 12, 12),
          fill: Colors.white, stroke: const Color(0xFFB9C6CE), radius: 2);
    }
    final f = _finger;
    if (f != null) _line(c, f, Offset(f.dx + 30, r.top - 30), _camD, 6);
    _text(c, '$left kristal kaldı', Offset(s.width / 2, r.top - 20), color: AppColors.inkMuted);
    _gauge(c, s, s.height - 52, 'Karıştırma hızı', _spin.speed / 18, lo: 4 / 18, hi: 13 / 18);
  }
}

/// Emülsifikasyon: karıştırdıkça su fazı akar; çok hızlı karıştırınca çok akar, yağ ayrışır.
class _Emulsifikasyon extends MiniGame {
  @override
  String get hint => 'Kapsülün içinde daire çiz: çizdikçe su fazı ince akışla dökülür, durunca durur. Çok hızlı çizersen yağ damlaları ayrışır.';
  final _spin = _Spin();
  final _rand = Random(3);
  final _drops = <Offset>[];
  double _p = 0, _sep = 0;

  @override
  void update(double dt, MiniInput i, Size s) {
    final d = _spin.step(dt, i, Offset(s.width / 2, s.height * .55));
    if (_spin.speed > 3) _p += d * .025;
    if (_spin.speed > 12) {
      _sep += dt;
      if (_sep > .3) {
        hit(6);
        _sep = 0;
        _drops.add(Offset(_rand.nextDouble(), _rand.nextDouble()));
      }
    }
    if (_p >= 1) done = true;
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    _rect(c, Rect.fromLTWH(w / 2 - 10, 34, 20, 46), fill: _cam, stroke: _camD);
    if (_spin.speed > 3) _line(c, Offset(w / 2, 80), Offset(w / 2, h * .45), const Color(0xFFBFE0EE), _spin.speed > 12 ? 10 : 4);
    _oval(c, Offset(w / 2, h * .55), w * .76, h * .32, fill: _porselen, stroke: _porselenD);
    _oval(c, Offset(w / 2, h * .55), w * .64, h * .24,
        fill: Color.lerp(const Color(0xFFF5EEC8), const Color(0xFFF5F7FB), _clamp(_p)));
    for (final d in _drops) {
      _circle(c, Offset(w / 2 + (d.dx - .5) * w * .5, h * .55 + (d.dy - .5) * h * .16), 7,
          fill: const Color(0xFFF2D46B), stroke: const Color(0xFFC9A93E), w: 1);
    }
    _gauge(c, s, h - 62, 'Karıştırma hızı', _spin.speed / 18, lo: 3 / 18, hi: 12 / 18);
    _gauge(c, s, h - 24, 'Eklenen su fazı', _p, fill: AppColors.kobalt);
  }
}

/// Soğutma: krem 40 °C'ye inene dek ritimle karıştırılır; ritim kaçarsa topak.
class _Sogutma extends MiniGame {
  @override
  String get hint => 'Krem 70 dereceden 40 dereceye soğuyor. Dıştaki halka çembere oturduğu anda dokun. Kaçırırsan kremde topak oluşur.';
  static const _per = .9;
  final _rand = Random(5);
  final _lumps = <Offset>[];
  double _t = 70, _beat = 0;
  bool _ok = false;

  @override
  void update(double dt, MiniInput i, Size s) {
    _t -= dt * 3.4;
    _beat += dt;
    final f = (_beat / _per) % 1;
    for (final _ in i.taps) {
      if (f > .78 || f < .1) {
        _ok = true;
      } else {
        hit(4);
        _lumps.add(Offset(_rand.nextDouble(), _rand.nextDouble()));
      }
    }
    if (_beat >= _per) {
      _beat -= _per;
      if (!_ok) {
        hit(5);
        _lumps.add(Offset(_rand.nextDouble(), _rand.nextDouble()));
      }
      _ok = false;
    }
    if (_t <= 40) done = true;
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height, o = Offset(w / 2, h * .48);
    _oval(c, o, w * .76, h * .32, fill: _porselen, stroke: _porselenD);
    _oval(c, o, w * .64, h * .24, fill: const Color(0xFFFFF6E6));
    for (final l in _lumps) {
      _circle(c, o + Offset((l.dx - .5) * w * .5, (l.dy - .5) * h * .15), 6,
          fill: const Color(0xFFF3E2BF), stroke: const Color(0xFFCBB78F), w: 1);
    }
    final f = (_beat / _per) % 1;
    _circle(c, o, 28, stroke: AppColors.kobalt, w: 3);
    _circle(c, o, 28 + 60 * (1 - f), stroke: AppColors.kobalt.withValues(alpha: .45), w: 3);
    _text(c, '${_t.round()}°', Offset(w - 46, 40), size: 22);
    _gauge(c, s, h - 40, 'Soğuma', (70 - _t) / 30, fill: AppColors.kobalt);
  }
}

/// Elekten geçirme: elek sağa sola sallanır, kalan topaklar dokunarak ezilir.
class _Elek extends MiniGame {
  @override
  String get hint => 'Parmağını sağa sola kaydırarak eleği salla. Elekte kalan koyu topaklara dokunup ez.';
  final _rand = Random(7);
  final _lumps = <double>[];
  double _p = 0, _off = 0, _acc = 0;
  double? _lx;
  int _dir = 0;

  @override
  void update(double dt, MiniInput i, Size s) {
    if (i.down) {
      final lx = _lx;
      if (lx != null) {
        final dx = i.pos.dx - lx;
        _off = _clamp(_off + dx, -40, 40);
        final nd = dx.sign.toInt();
        if (nd != 0 && nd != _dir) {
          if (_acc > 30) {
            _p += .07;
            if (_rand.nextDouble() < .35 && _lumps.length < 3) _lumps.add(.3 + _rand.nextDouble() * .4);
          }
          _acc = 0;
          _dir = nd;
        }
        _acc += dx.abs();
      }
      _lx = i.pos.dx;
    } else {
      _lx = null;
      _off *= .8;
    }
    for (final t in i.taps) {
      _lumps.removeWhere((l) => (t - Offset(l * s.width + _off, s.height * .36)).distance < 26);
    }
    if (_p >= 1 && _lumps.isEmpty) done = true;
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final sieve = Offset(w / 2 + _off, h * .36);
    _oval(c, sieve, w * .72, h * .16, fill: const Color(0xFFE4D3B0), stroke: const Color(0xFF8A6A4A), sw: 5);
    for (var k = -6; k <= 6; k++) {
      _line(c, Offset(sieve.dx + k * 14, h * .29), Offset(sieve.dx + k * 14, h * .43), const Color(0x59786450), 1);
    }
    for (final l in _lumps) {
      _circle(c, Offset(l * w + _off, h * .36), 11, fill: const Color(0xFFC9B48C), stroke: const Color(0xFF8F7A55));
    }
    _oval(c, Offset(w / 2, h * .72), w * .6, h * .14, fill: _porselen, stroke: _porselenD);
    final k = sqrt(_clamp(_p));
    if (k > 0) _oval(c, Offset(w / 2, h * .72), w * .48 * k, h * .1 * k, fill: Colors.white, stroke: const Color(0xFFDDDDDD), sw: 1);
    if (_off.abs() > 5) {
      for (var n = 0; n < 6; n++) {
        _circle(c, Offset(w / 2 + _off * .5 + (n - 3) * 12, h * .47 + (_p * 400 + n * 17) % 60), 2, fill: const Color(0xFFF5EFE0));
      }
    }
    _gauge(c, s, h - 40, _p >= 1 && _lumps.isNotEmpty ? 'Topakları ez' : 'Elenen toz', _p, fill: AppColors.kobalt);
  }
}

/// Karıştırma: beherde bagetle; iki sıvının çizgileri tek renge döner.
class _Karistirma extends MiniGame {
  @override
  String get hint => 'Beherin içinde bagetle daire çiz. İki sıvının çizgileri kaybolup tek renk olunca biter.';
  final _spin = _Spin();
  double _p = 0;

  @override
  void update(double dt, MiniInput i, Size s) {
    final d = _spin.step(dt, i, Offset(s.width / 2, s.height * .48));
    if (_spin.speed > 3 && _spin.speed < 16) _p += d * .035;
    if (_p >= 1) done = true;
  }

  @override
  void paint(Canvas c, Size s) {
    final r = Rect.fromLTWH(s.width * .2, s.height * .18, s.width * .6, s.height * .6);
    _beaker(c, r, 0, Colors.transparent);
    const a = Color(0xFFE6785A), b = Color(0xFFFAD78C);
    const n = 8;
    final bh = r.height * .78 / n;
    for (var k = 0; k < n; k++) {
      final t = k.isOdd ? 1 - _p * .5 : _p * .5;
      c.drawRect(Rect.fromLTWH(r.left + 4, r.top + r.height * .2 + k * bh, r.width - 8, bh + 1), Paint()..color = Color.lerp(a, b, t)!);
    }
    _gauge(c, s, s.height - 40, 'Homojenlik', _p, fill: AppColors.kobalt);
  }
}

/// Şişirme: polimer suyun yüzeyine serpilir; aynı yere yığılırsa topak (balık gözü).
class _Sisirme extends MiniGame {
  @override
  String get hint => 'Suyun yüzeyinin her yerine dokunarak tozu serp. Aynı yere üst üste serpersen içi kuru topak ("balık gözü") olur.';
  final _cells = List<int>.filled(8, 0);
  final _lumps = <int>[];
  double _wait = 0;

  @override
  void update(double dt, MiniInput i, Size s) {
    final x0 = s.width * .12, w = s.width * .76;
    for (final t in i.taps) {
      if (t.dy < s.height * .2 || t.dy > s.height * .7) continue;
      final k = ((t.dx - x0) / w * 8).floor();
      if (k < 0 || k > 7) continue;
      if (++_cells[k] > 2) {
        hit(7);
        _lumps.add(k);
      }
    }
    if (_cells.every((v) => v >= 1)) {
      _wait += dt;
      if (_wait > .6) done = true;
    }
  }

  @override
  void paint(Canvas c, Size s) {
    final x0 = s.width * .12, w = s.width * .76, top = s.height * .32;
    _beaker(c, Rect.fromLTWH(x0 - 6, s.height * .2, w + 12, s.height * .55), .8, const Color(0xFFE9F4F8));
    for (var k = 0; k < 8; k++) {
      final v = _cells[k];
      if (v > 0) {
        _rect(c, Rect.fromLTWH(x0 + k * w / 8 + 3, top + 18, w / 8 - 6, 6 + min(v, 3) * 3.0),
            fill: v > 2 ? const Color(0xFFE8E0C8) : const Color(0xFFF7F4EC), radius: 3);
      }
    }
    for (var n = 0; n < _lumps.length; n++) {
      _circle(c, Offset(x0 + (_lumps[n] + .5) * w / 8, top + 60 + (n % 3) * 18), 8,
          fill: const Color(0xFFEDE6D2), stroke: const Color(0xFFB9AE90));
    }
    _gauge(c, s, s.height - 40, 'Yüzey kaplandı', _cells.where((v) => v >= 1).length / 8, fill: AppColors.kobalt);
  }
}

/// Hacme tamamlama: çizgiye yaklaşınca damla damla; menisküsün alt kenarı çizgide.
class _Hacim extends MiniGame {
  @override
  String get hint => 'Basılı tut, su aksın. Çizgiye yaklaşınca damla damla akar. Sıvının kavisli yüzeyinin alt kenarı çizgiye gelince "Tamam"a bas.';
  @override
  String get action => 'Tamam';
  double _v = 0;
  bool _down = false;

  @override
  void act(Size s) {
    final err = (_v - .9).abs() * 100;
    hit(_v > .9 ? err * 14 : err * 9);
    done = true;
  }

  @override
  void update(double dt, MiniInput i, Size s) {
    _down = i.down;
    if (i.down) _v = min(1, _v + (_v < .8 ? .25 : .025) * dt);
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final tube = Rect.fromLTWH(w * .15, h * .12, 60, h * .66);
    _rect(c, tube, fill: _cam, stroke: _camD, radius: 6);
    final lh = tube.height * _v;
    if (lh > 3) _rect(c, Rect.fromLTWH(tube.left + 3, tube.bottom - lh, tube.width - 6, lh - 3), fill: const Color(0xFFCFE6F2), radius: 3);
    final ly = tube.top + tube.height * .1;
    _line(c, Offset(tube.left, ly), Offset(tube.right, ly), AppColors.ink, 2);
    _text(c, '100 mL', Offset(tube.right + 30, ly), size: 12, color: AppColors.inkMuted, bold: false);
    // Büyütme: çizgi ortada, sıvı yüzeyi menisküs kavisiyle.
    final zc = Offset(w * .68, h * .38), zr = w * .2;
    c.save();
    c.clipPath(Path()..addOval(Rect.fromCircle(center: zc, radius: zr)));
    c.drawRect(Rect.fromCircle(center: zc, radius: zr), Paint()..color = _cam);
    final surf = zc.dy - (_v - .9) * tube.height * 4;
    final liquid = Path()
      ..moveTo(zc.dx - zr, surf - 14)
      ..quadraticBezierTo(zc.dx, surf + 16, zc.dx + zr, surf - 14)
      ..lineTo(zc.dx + zr, zc.dy + zr)
      ..lineTo(zc.dx - zr, zc.dy + zr)
      ..close();
    c.drawPath(liquid, Paint()..color = const Color(0xFFBFE0EE));
    _line(c, Offset(zc.dx - zr, zc.dy), Offset(zc.dx + zr, zc.dy), AppColors.ink, 2);
    c.restore();
    _circle(c, zc, zr, stroke: AppColors.line, w: 3);
    _text(c, 'büyütme', zc + Offset(0, zr + 14), size: 12, color: AppColors.inkMuted, bold: false);
    _text(c, _down ? (_v < .8 ? 'akıyor…' : 'damla damla') : 'basılı tut', Offset(w / 2, h - 26), color: AppColors.inkMuted);
  }
}

/// Kapsül doldurma: toz plakadaki kapsüllerin üstünden yayılır, sonra bastırılır.
class _Kapsul extends MiniGame {
  @override
  String get hint => 'Parmağını kapsül sıralarının üstünden sürükleyerek tozu yay. Hepsi dolunca "Bastır"a bas. Eksik kalan kapsül kaliteyi düşürür.';
  @override
  String get action => 'Bastır';
  static const _cols = 6;
  final _f = List<double>.filled(18, 0);
  Offset? _finger;

  Offset _center(int k, Size s) {
    final cw = s.width * .8 / _cols, rh = s.height * .16;
    return Offset(s.width * .1 + (k % _cols + .5) * cw, s.height * .22 + (k ~/ _cols) * rh + rh * .5);
  }

  @override
  void act(Size s) {
    hit(_f.where((v) => v < .8).length * 7.0);
    done = true;
  }

  @override
  void update(double dt, MiniInput i, Size s) {
    _finger = i.down ? i.pos : null;
    if (!i.down) return;
    final cw = s.width * .8 / _cols;
    for (var k = 0; k < _f.length; k++) {
      if ((i.pos - _center(k, s)).distance < cw * .6) _f[k] = min(1.2, _f[k] + dt * 2.6);
    }
  }

  @override
  void paint(Canvas c, Size s) {
    final cw = s.width * .8 / _cols, rh = s.height * .16;
    _rect(c, Rect.fromLTWH(s.width * .1 - 10, s.height * .22 - 14, s.width * .8 + 20, rh * 3 + 28),
        fill: const Color(0xFFE9EDF2), stroke: AppColors.line, radius: 8);
    for (var k = 0; k < _f.length; k++) {
      final o = _center(k, s), v = _f[k];
      _circle(c, o, cw * .32, fill: Colors.white, stroke: const Color(0xFFB9C3CE));
      if (v > 0) _circle(c, o, cw * .32 * _clamp(v), fill: v >= .8 ? const Color(0xFFF2EBDD) : const Color(0xFFF7F3EA));
      if (v >= .8) _text(c, '✓', o, size: 14, color: _ok);
    }
    if (_finger != null) _circle(c, _finger!, 20, fill: const Color(0xB3F0E8D6));
    _gauge(c, s, s.height - 40, 'Dolu kapsül', _f.where((v) => v >= .8).length / 18, fill: AppColors.kobalt);
  }
}
