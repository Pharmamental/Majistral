import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Bahçenin zemini (2026-10-29): soluk zeytin yeşili çimen. Çit ([GardenFence])
/// içeriğin başında durur ve onunla birlikte kayar (Tuğrul, 2026-10-29).
class GardenGround extends StatelessWidget {
  const GardenGround({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.gardenGrass,
      child: RepaintBoundary(child: CustomPaint(painter: _GrassPainter(), child: child)),
    );
  }
}

/// Badanalı tahta çit; Market'in tentesi gibi başlığı sahneden ayırır.
class GardenFence extends StatelessWidget {
  const GardenFence({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 44, child: RepaintBoundary(child: CustomPaint(painter: _FencePainter())));
  }
}

/// Bir parsel: ceviz tahtadan yükseltilmiş yatak, içinde karıklı toprak.
/// Kilitliyse yerinde çimene çizilmiş silik kesik çerçeve ve kilit durur.
/// Altında, parsele değmeden, kâğıt etikette parselin adı ve durumu (durum yalnız
/// renkle anlatılmaz; Tuğrul 2026-10-29: etiket parselin üstüne binmesin).
class GardenBed extends StatelessWidget {
  const GardenBed({
    super.key,
    required this.number,
    required this.open,
    this.label,
    this.plant,
    this.progress,
    this.color,
    this.ready = false,
    this.onTap,
  });

  final int number;
  final bool open;

  /// Etikette yazacak durum ("Papatya · 1 sa 20 dk"); boşsa parselin adı.
  final String? label;

  /// Ekili bitkinin adı; çiçeğin biçimi buna göre ([bloomFormOf]).
  final String? plant;

  /// Ekili bitkinin büyümesi (0–1); boş parselde null.
  final double? progress;

  /// Olgunlaşınca açan çiçeğin (ya da yaprağın) rengi.
  final Color? color;
  final bool ready;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = label ?? (open ? 'Parsel $number · tohum ek' : 'Parsel $number · kilitli');
    return Semantics(
      button: onTap != null,
      label: text,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: CustomPaint(
                painter: open
                    ? _BedPainter(progress: progress, color: color, plant: plant)
                    : const _LockedBedPainter(),
                child: open
                    ? null
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Icon(Icons.lock_rounded, color: AppColors.gardenGrassDark, size: 28),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Center(child: _Tag(text: text, ready: ready)),
          ],
        ),
      ),
    );
  }
}

/// Parselin önüne iliştirilmiş küçük kâğıt etiket. Olgun bitkide onay işareti
/// ve yeşil yazı (durum yalnız renkle anlatılmaz).
class _Tag extends StatelessWidget {
  const _Tag({required this.text, this.ready = false});

  final String text;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paperInner),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ready) ...[
            const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.hazirText),
            const SizedBox(width: AppSpace.xs),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.label(size: 12, color: ready ? AppColors.hazirText : AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// Çimen: kısa, çoğu dik duran teller ve seyrek açık benekler, sabit tohumla.
class _GrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Kenardaki teller başlığa taşmasın.
    canvas.clipRect(Offset.zero & size);
    final rnd = math.Random(11);
    final p = Paint()
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < size.width * size.height / 90; i++) {
      final dark = rnd.nextDouble() < 0.7;
      p.color = (dark ? AppColors.gardenGrassDark : AppColors.gardenGrassLight)
          .withValues(alpha: 0.18 + rnd.nextDouble() * 0.22);
      final o = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final a = -math.pi / 2 + (rnd.nextDouble() - 0.5) * 0.9; // çoğu yukarı bakar
      final l = 2.5 + rnd.nextDouble() * 3.5;
      canvas.drawLine(o, o + Offset(math.cos(a) * l, math.sin(a) * l), p);
    }
  }

  @override
  bool shouldRepaint(_GrassPainter oldDelegate) => false;
}

/// Badanalı tahta çit: sivri uçlu dikmeler, arkalarında iki kuşak; çitin dibine
/// çimene düşen gölge.
class _FencePainter extends CustomPainter {
  const _FencePainter();

  static const double _picket = 16;
  static const double _gap = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    // Çitin arkası duvar rengi: başlık duvarıyla birleşir.
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, h - 8), Paint()..color = AppColors.wall);
    // Kuşaklar.
    final rail = Paint()..color = AppColors.fenceShade;
    canvas.drawRect(Rect.fromLTWH(0, h * 0.30, size.width, 6), rail);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.66, size.width, 6), rail);
    // Dikmeler.
    final body = Paint()..color = AppColors.fence;
    final edge = Paint()
      ..color = AppColors.fenceShade
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var x = 2.0; x < size.width; x += _picket + _gap) {
      final path = Path()
        ..moveTo(x, 9)
        ..lineTo(x + _picket / 2, 1)
        ..lineTo(x + _picket, 9)
        ..lineTo(x + _picket, h - 4)
        ..lineTo(x, h - 4)
        ..close();
      canvas.drawPath(path, body);
      canvas.drawPath(path, edge);
      // Dikmenin sağ kenarında ince gölge: tahta kalınlığı.
      canvas.drawRect(Rect.fromLTWH(x + _picket - 3, 9, 3, h - 13), Paint()..color = AppColors.fenceShade);
    }
    // Çimene düşen gölge.
    final shade = Rect.fromLTWH(0, h - 4, size.width, 4);
    canvas.drawRect(shade, Paint()..color = Colors.black.withValues(alpha: 0.12));
  }

  @override
  bool shouldRepaint(_FencePainter oldDelegate) => false;
}

/// Çiçeğin biçimi, bitkinin gerçek görünüşünden (2026-10-29): papatya gibi
/// taç yapraklı baş, başak (lavanta), şemsiye (rezene, mürver), beş yapraklı
/// kâse (gelincik) ya da yalnız yaprak (nane, defne: yaprağı için yetişir).
enum BloomForm { daisy, spike, umbel, cup, leafy }

BloomForm bloomFormOf(String? plant) => switch (plant) {
      'Papatya' || 'Aynısefa' || 'Ekinezya' => BloomForm.daisy,
      'Lavanta' || 'Kekik' || 'Biberiye' => BloomForm.spike,
      'Rezene' || 'Ihlamur' || 'Mürver' => BloomForm.umbel,
      'Sarı kantaron' || 'Hatmi' || 'Gelincik' => BloomForm.cup,
      _ => BloomForm.leafy,
    };

/// Büyümenin evresi: tohum (toprak kabarığı), filiz (iki çenek yaprağı), fide
/// (gerçek yapraklar), tomurcuk, çiçek. Her evrenin içinde boy sürekli uzar.
enum GrowthStage { seed, sprout, seedling, bud, bloom }

GrowthStage growthStageAt(double p) => p >= 1
    ? GrowthStage.bloom
    : p >= 0.75
        ? GrowthStage.bud
        : p >= 0.4
            ? GrowthStage.seedling
            : p >= 0.12
                ? GrowthStage.sprout
                : GrowthStage.seed;

/// Ceviz çerçeveli yükseltilmiş yatak: üstte açık renkli çerçeve kenarı, önde
/// koyu ön yüz (yükseklik), içinde koyu toprak ve dört karık. Ekiliyse her
/// karıkta üç bitki evre evre büyür ([progress]); olgunlaşınca bitkiye özgü
/// biçimde çiçek açar ([color], [plant]).
class _BedPainter extends CustomPainter {
  const _BedPainter({this.progress, this.color, this.plant});

  final double? progress;
  final Color? color;
  final String? plant;

  static const _leaf = Color(0xFF7FA05A),
      _leafDark = Color(0xFF55723A),
      _stem = Color(0xFF6B8A47),
      _sprout = Color(0xFF9DC06A),
      _seed = Color(0xFFE6D7B0);

  static Color _shade(Color c, double t) => Color.lerp(c, Colors.black, t)!;

  /// Uçları sivri yaprak: [at]'tan [angle] yönüne uzar; altında koyu gölgesi.
  static void _leafAt(Canvas canvas, Offset at, double angle, double len, Color c) {
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle);
    final w = len * 0.42;
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(len * 0.45, -w, len, 0)
      ..quadraticBezierTo(len * 0.45, w, 0, 0)
      ..close();
    canvas.drawPath(path.shift(const Offset(0, 0.9)), Paint()..color = _shade(c, 0.3));
    canvas.drawPath(path, Paint()..color = c);
    canvas.restore();
  }

  static void _stemLine(Canvas canvas, Offset a, Offset b, double width) {
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = _stem
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Karıktaki bir bitki. [s] ölçek (parsel genişliğine göre), [tall] ve
  /// [lean] her bitkiye ayrı küçük fark: sıra dümdüz durmasın.
  void _plant(Canvas canvas, Offset base, double p, double s, double tall, double lean) {
    final stage = growthStageAt(p);
    final form = bloomFormOf(plant);
    final bloom = color ?? const Color(0xFFF4E9A8);
    final leafColor = form == BloomForm.leafy ? bloom : _leaf;

    if (stage == GrowthStage.seed) {
      // Toprak kabarığı ve içinden görünen tohum.
      canvas.drawOval(
        Rect.fromCenter(center: base - Offset(0, 0.8 * s), width: 9 * s, height: 4 * s),
        Paint()..color = AppColors.gardenSoilLight,
      );
      canvas.drawOval(
        Rect.fromCenter(center: base - Offset(0.5 * s, 1.6 * s), width: 2.6 * s, height: 1.8 * s),
        Paint()..color = _seed,
      );
      return;
    }

    if (stage == GrowthStage.sprout) {
      final t = (p - 0.12) / 0.28;
      final top = base + Offset(lean * 2 * s, -(3 + 5 * t) * tall * s);
      _stemLine(canvas, base, top, 1.4 * s);
      final len = (3 + 2.5 * t) * s;
      _leafAt(canvas, top, -math.pi + 0.5, len, _sprout);
      _leafAt(canvas, top, -0.5, len, _sprout);
      return;
    }

    // Fide, tomurcuk ve çiçekte sap uzar; yapraklar çift çift dizilir.
    final t = switch (stage) {
      GrowthStage.seedling => (p - 0.4) / 0.35,
      GrowthStage.bud => (p - 0.75) / 0.25,
      _ => 1.0,
    };
    final h = switch (stage) {
      GrowthStage.seedling => 8 + 9 * t,
      GrowthStage.bud => 17 + 6 * t,
      _ => 24.0,
    } * tall * s;
    final top = base + Offset(lean * 5 * s, -h);
    _stemLine(canvas, base, top, 1.7 * s);
    final pairs = stage == GrowthStage.seedling ? 2 : (form == BloomForm.leafy ? 4 : 3);
    for (var k = 0; k < pairs; k++) {
      final y = 0.22 + k * (form == BloomForm.leafy ? 0.24 : 0.2);
      final at = Offset.lerp(base, top, y)!;
      final len = (stage == GrowthStage.seedling ? 4 + 2.5 * t : 6.5) * s * (1 - k * 0.12);
      _leafAt(canvas, at, -math.pi + 0.45 + k * 0.1, len, leafColor);
      _leafAt(canvas, at + Offset(0, -1.2 * s), -0.45 - k * 0.1, len, leafColor);
    }
    if (form == BloomForm.leafy) {
      // Yaprağı için yetişen bitkide tepede yaprak demeti; çiçek yok.
      if (stage != GrowthStage.seedling) {
        final len = (stage == GrowthStage.bloom ? 7.0 : 5.5) * s;
        _leafAt(canvas, top, -math.pi / 2 - 0.55, len, leafColor);
        _leafAt(canvas, top, -math.pi / 2 + 0.55, len, leafColor);
        _leafAt(canvas, top, -math.pi / 2, len * 1.1, leafColor);
      }
      return;
    }
    if (stage == GrowthStage.bud) _bud(canvas, top, s, form, bloom, t);
    if (stage == GrowthStage.bloom) _flower(canvas, top, s, form, bloom);
  }

  /// Tomurcuk: yeşil, ucunda çiçeğin rengi beliriyor ([t] ile artar).
  void _bud(Canvas canvas, Offset top, double s, BloomForm form, Color c, double t) {
    final tip = Color.lerp(_sprout, c, 0.35 + 0.5 * t)!;
    switch (form) {
      case BloomForm.spike:
        for (var i = 0; i < 4; i++) {
          canvas.drawCircle(top + Offset((i.isEven ? -1 : 1) * 1.2 * s, (i * 2.4 - 1) * s), 1.5 * s, Paint()..color = i == 0 ? tip : _leafDark);
        }
      case BloomForm.umbel:
        for (final dx in const [-3.0, 0.0, 3.0]) {
          final end = top + Offset(dx * s, -2.5 * s + dx.abs() * 0.4 * s);
          _stemLine(canvas, top, end, 0.9 * s);
          canvas.drawCircle(end, 1.4 * s, Paint()..color = tip);
        }
      case BloomForm.daisy || BloomForm.cup || BloomForm.leafy:
        final r = Rect.fromCenter(center: top - Offset(0, 2 * s), width: 4.4 * s, height: 5.6 * s);
        canvas.drawOval(r, Paint()..color = _leafDark);
        canvas.drawOval(
          Rect.fromLTRB(r.left + 0.8 * s, r.top, r.right - 0.8 * s, r.top + r.height * 0.5),
          Paint()..color = tip,
        );
    }
  }

  /// Açmış çiçek, bitkinin biçiminde.
  void _flower(Canvas canvas, Offset top, double s, BloomForm form, Color c) {
    final dark = _shade(c, 0.28);
    switch (form) {
      case BloomForm.daisy:
        final center = top - Offset(0, 1.5 * s);
        for (var i = 0; i < 10; i++) {
          final a = i * math.pi / 5;
          canvas.save();
          canvas.translate(center.dx, center.dy);
          canvas.rotate(a);
          canvas.drawOval(Rect.fromLTWH(1.5 * s, -1.3 * s, 4.6 * s, 2.6 * s), Paint()..color = i.isEven ? c : _shade(c, 0.08));
          canvas.restore();
        }
        final disk = plant == 'Papatya' ? const Color(0xFFE9B93A) : plant == 'Ekinezya' ? const Color(0xFFA2582A) : _shade(c, 0.35);
        canvas.drawCircle(center, 2.4 * s, Paint()..color = disk);
        canvas.drawCircle(center - Offset(0.6 * s, 0.6 * s), 0.9 * s, Paint()..color = Colors.white.withValues(alpha: 0.25));
      case BloomForm.spike:
        // Sapın ucunda üst üste küçük çiçekler; uca doğru incelir.
        for (var i = 0; i < 6; i++) {
          final r = (1.9 - i * 0.18) * s;
          final o = top + Offset((i.isEven ? -1 : 1) * 1.3 * s, (2 - i * 2.2) * s);
          canvas.drawCircle(o, r, Paint()..color = i.isEven ? c : dark);
        }
      case BloomForm.umbel:
        // Şemsiye: tepeden yayılan ince saplar, uçlarında küçük çiçek ya da tane öbekleri.
        for (final dx in const [-6.0, -3.0, 0.0, 3.0, 6.0]) {
          final end = top + Offset(dx * s, (-4.5 + dx.abs() * 0.35) * s);
          _stemLine(canvas, top, end, 0.9 * s);
          for (final o in const [Offset(-1, 0), Offset(1, 0), Offset(0, -1.2)]) {
            canvas.drawCircle(end + o * s, 1.25 * s, Paint()..color = o.dy < 0 ? c : dark);
          }
        }
      case BloomForm.cup:
        final center = top - Offset(0, 2 * s);
        for (var i = 0; i < 5; i++) {
          final a = -math.pi / 2 + i * 2 * math.pi / 5;
          canvas.drawCircle(center + Offset(math.cos(a), math.sin(a)) * 2.6 * s, 2.8 * s, Paint()..color = i.isEven ? c : _shade(c, 0.1));
        }
        canvas.drawCircle(center, 1.7 * s, Paint()..color = plant == 'Gelincik' ? const Color(0xFF2A1E1E) : _shade(c, 0.45));
      case BloomForm.leafy:
        break;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    const frame = 7.0;
    const front = 10.0;
    final r = Radius.circular(AppRadius.paperInner);
    final outer = Rect.fromLTWH(0, 0, size.width, size.height - front);
    // Çimene düşen gölge.
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer.translate(0, front + 3), r),
      Paint()..color = Colors.black.withValues(alpha: 0.16),
    );
    // Ön yüz (yatağın yüksekliği).
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, front, size.width, size.height - front), r),
      Paint()..color = AppColors.counterEdge,
    );
    // Çerçevenin üst yüzü.
    canvas.drawRRect(RRect.fromRectAndRadius(outer, r), Paint()..color = AppColors.counterLip);
    // Toprak.
    final soil = outer.deflate(frame);
    canvas.drawRect(soil, Paint()..color = AppColors.gardenSoil);
    // Karıklar: koyu oluk, hemen üstünde açık sırt.
    for (var i = 1; i <= 4; i++) {
      final y = soil.top + soil.height * i / 5;
      final path = Path()..moveTo(soil.left + 6, y);
      for (var x = soil.left + 6; x <= soil.right - 6; x += 4) {
        path.lineTo(x, y + math.sin(x * 0.09 + i) * 0.8);
      }
      canvas.drawPath(
        path.shift(const Offset(0, -2)),
        Paint()
          ..color = AppColors.gardenSoilLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.gardenSoilDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }
    // Toprak taneleri, sabit tohumla.
    final rnd = math.Random(3);
    for (var i = 0; i < soil.width * soil.height / 60; i++) {
      canvas.drawCircle(
        Offset(soil.left + rnd.nextDouble() * soil.width, soil.top + rnd.nextDouble() * soil.height),
        0.6 + rnd.nextDouble() * 0.8,
        Paint()..color = (rnd.nextBool() ? AppColors.gardenSoilDark : AppColors.gardenSoilLight).withValues(alpha: 0.5),
      );
    }
    // Toprağın çerçeveye değdiği yerde ince gölge: toprak çerçevenin içinde, aşağıda.
    canvas.drawRect(
      soil,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Bitkiler: dört karıkta üçer, arkadan öne çizilir (öndeki arkadakini örter).
    if (progress case final p?) {
      // Arka sıranın çiçekleri çerçeveden biraz taşar, üstteki etikete değmez.
      canvas.clipRect(Rect.fromLTRB(-4, -6, size.width + 4, size.height));
      final s = soil.width / 95;
      final rnd = math.Random(5);
      for (var i = 1; i <= 4; i++) {
        final y = soil.top + soil.height * i / 5 - 1;
        for (var k = 0; k < 3; k++) {
          final x = soil.left + soil.width * (k + 0.5 + (i.isEven ? 0.35 : 0)) / 3.35;
          // Arka sıra biraz küçük: uzakta durur, çiçeği çerçeveden taşmaz.
          final far = 0.76 + 0.08 * i;
          _plant(canvas, Offset(x, y), p.clamp(0.0, 1.0), s * far, 0.9 + rnd.nextDouble() * 0.2, rnd.nextDouble() - 0.5);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BedPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.plant != plant;
}

/// Kilitli parsel: çimende kesik çizgili silik çerçeve (duvardaki boş reçete
/// yeri gibi).
class _LockedBedPainter extends CustomPainter {
  const _LockedBedPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const front = 10.0;
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - front - 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(AppRadius.paperInner)),
      Paint()..color = AppColors.gardenGrassDark.withValues(alpha: 0.10),
    );
    final dash = Paint()
      ..color = AppColors.gardenGrassDark.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(AppRadius.paperInner)));
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 12) {
        canvas.drawPath(metric.extractPath(d, d + 7), dash);
      }
    }
  }

  @override
  bool shouldRepaint(_LockedBedPainter oldDelegate) => false;
}
