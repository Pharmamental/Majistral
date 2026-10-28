import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Bahçenin zemini (2026-10-29): üstte badanalı tahta çit, altında soluk zeytin
/// yeşili çimen. İçerik çitin altından başlar; Market'in tentesi gibi çit de
/// başlığı sahneden ayırır.
class GardenGround extends StatelessWidget {
  const GardenGround({super.key, required this.child});

  static const double _fence = 44;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.gardenGrass,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _GrassPainter(),
                child: Padding(padding: const EdgeInsets.only(top: _fence), child: child),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: _fence,
            child: RepaintBoundary(child: CustomPaint(painter: _FencePainter())),
          ),
        ],
      ),
    );
  }
}

/// Bir parsel: ceviz tahtadan yükseltilmiş yatak, içinde karıklı toprak.
/// Kilitliyse yerinde çimene çizilmiş silik kesik çerçeve ve kilit durur.
/// Altında kâğıt etikette parselin adı ve durumu (durum yalnız renkle anlatılmaz).
class GardenBed extends StatelessWidget {
  const GardenBed({
    super.key,
    required this.number,
    required this.open,
    this.label,
    this.progress,
    this.color,
    this.ready = false,
    this.onTap,
  });

  final int number;
  final bool open;

  /// Etikette yazacak durum ("Papatya · 1 sa 20 dk"); boşsa parselin adı.
  final String? label;

  /// Ekili bitkinin büyümesi (0–1); boş parselde null.
  final double? progress;

  /// Olgunlaşınca açan çiçeğin rengi.
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
        child: AspectRatio(
          aspectRatio: 1.1,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: open ? _BedPainter(progress: progress, color: color) : const _LockedBedPainter(),
                ),
              ),
              if (!open)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSpace.xl),
                    child: Icon(Icons.lock_rounded, color: AppColors.gardenGrassDark, size: 28),
                  ),
                ),
              Positioned(
                left: AppSpace.xs,
                right: AppSpace.xs,
                bottom: AppSpace.sm,
                child: Center(child: _Tag(text: text, ready: ready)),
              ),
            ],
          ),
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

/// Ceviz çerçeveli yükseltilmiş yatak: üstte açık renkli çerçeve kenarı, önde
/// koyu ön yüz (yükseklik), içinde koyu toprak ve dört karık. Ekiliyse ilk üç
/// karıkta filizler büyür ([progress]); olgunlaşınca çiçek açar ([color]).
class _BedPainter extends CustomPainter {
  const _BedPainter({this.progress, this.color});

  final double? progress;
  final Color? color;

  static const _leaf = Color(0xFF7FA05A), _leafDark = Color(0xFF5C7A3E), _stem = Color(0xFF6B8A47);

  /// Karıktaki bir bitki: sapı ve iki yaprağı büyümeyle uzar; olgunsa tepesinde çiçek.
  void _plant(Canvas canvas, Offset base, double p, Color? bloom) {
    final h = 4 + p * 14;
    final top = base - Offset(0, h);
    canvas.drawLine(
      base,
      top,
      Paint()
        ..color = _stem
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
    final leaf = 2.5 + p * 3.5;
    for (final (side, y) in [(-1.0, 0.45), (1.0, 0.7)]) {
      final at = Offset.lerp(base, top, y)!;
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(side * 0.7);
      final r = Rect.fromCenter(center: Offset(side * leaf * 0.8, 0), width: leaf * 1.8, height: leaf);
      canvas.drawOval(r.translate(0, 0.8), Paint()..color = _leafDark);
      canvas.drawOval(r, Paint()..color = _leaf);
      canvas.restore();
    }
    if (bloom != null) {
      for (final o in const [Offset(-2.4, 0), Offset(2.4, 0), Offset(0, -2.6), Offset(0, 2.2)]) {
        canvas.drawCircle(top + o, 2.6, Paint()..color = bloom);
      }
      canvas.drawCircle(top, 1.6, Paint()..color = const Color(0xFFF2D06B));
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
    // Filizler: ilk üç karıkta dörder bitki (en alttaki karığı etiket örter).
    if (progress case final p?) {
      final bloom = p >= 1 ? color : null;
      for (var i = 1; i <= 3; i++) {
        final y = soil.top + soil.height * i / 5 - 1;
        for (var k = 0; k < 4; k++) {
          final x = soil.left + soil.width * (k + 0.5 + (i.isEven ? 0.25 : 0)) / 4.25;
          _plant(canvas, Offset(x, y), p, bloom);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BedPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
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
