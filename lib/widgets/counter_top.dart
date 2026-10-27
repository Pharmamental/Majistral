import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Koyu ceviz tezgâh: üstte raf kenarı (açık üst yüz, koyu ön yüz, altına
/// düşen gölge), altında yatay tahtalar. Reçeteler raf kenarına bantla
/// yapıştırılıp asılır (2026-10-27).
class CounterTop extends StatelessWidget {
  const CounterTop({super.key, required this.child});

  /// Raf kenarının yüksekliği; asılan kartların bandı bu kenara biner.
  static const double lip = 15;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 5, color: AppColors.counterLip),
        Container(height: lip - 5, color: AppColors.counterEdge),
        Expanded(
          child: ColoredBox(
            color: AppColors.counterPlanks.first,
            child: CustomPaint(painter: _WalnutPainter(), child: child),
          ),
        ),
      ],
    );
  }
}

/// Yatay tahtalar, her biri biraz farklı tonda; tahta aralarında koyu derz,
/// içinde düzensiz dalgalı damarlar. Desen sabit tohumla çizilir, her karede
/// aynı kalır.
class _WalnutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    const h = 58.0;
    const planks = AppColors.counterPlanks;
    final grain = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i * h < size.height; i++) {
      final top = i * h;
      canvas.drawRect(Rect.fromLTWH(0, top, size.width, h), Paint()..color = planks[i % planks.length]);
      // Damarlar: tahta boyunca hafif dalgalanan ince çizgiler.
      for (var g = 0; g < 7; g++) {
        final y0 = top + 4 + rnd.nextDouble() * (h - 8);
        final amp = 0.6 + rnd.nextDouble() * 2.2;
        final freq = 0.008 + rnd.nextDouble() * 0.02;
        final phase = rnd.nextDouble() * math.pi * 2;
        grain.color = (rnd.nextBool() ? AppColors.counterGrain : AppColors.counterGrainLight)
            .withValues(alpha: 0.18 + rnd.nextDouble() * 0.18);
        final path = Path()..moveTo(0, y0);
        for (var x = 0.0; x <= size.width; x += 6) {
          path.lineTo(x, y0 + amp * math.sin(x * freq + phase));
        }
        canvas.drawPath(path, grain);
      }
      // Derz.
      canvas.drawRect(Rect.fromLTWH(0, top, size.width, 1.5), Paint()..color = AppColors.counterSeam);
      canvas.drawRect(Rect.fromLTWH(0, top + 1.5, size.width, 1), Paint()..color = const Color(0x1AFFFFFF));
    }
    // Raf kenarının altına düşen gölge.
    final shade = Rect.fromLTWH(0, 0, size.width, 12);
    canvas.drawRect(
      shade,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.35), Colors.black.withValues(alpha: 0)],
        ).createShader(shade),
    );
  }

  @override
  bool shouldRepaint(_WalnutPainter oldDelegate) => false;
}
