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
  const GardenBed({super.key, required this.number, required this.open});

  final int number;
  final bool open;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Parsel $number, ${open ? 'boş' : 'kilitli'}',
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: open ? const _BedPainter() : const _LockedBedPainter())),
            if (!open)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppSpace.xl),
                  child: Icon(Icons.lock_rounded, color: AppColors.gardenGrassDark, size: 28),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpace.sm,
              child: Center(child: _Tag(text: open ? 'Parsel $number · boş' : 'Parsel $number · kilitli')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Parselin önüne iliştirilmiş küçük kâğıt etiket.
class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paperInner),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Text(text, style: AppText.label(size: 12, color: AppColors.ink)),
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
/// koyu ön yüz (yükseklik), içinde koyu toprak ve dört karık.
class _BedPainter extends CustomPainter {
  const _BedPainter();

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
  }

  @override
  bool shouldRepaint(_BedPainter oldDelegate) => false;
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
