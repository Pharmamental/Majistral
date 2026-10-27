import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Ahşap tezgâh: üstte raf kenarı (açık üst yüz, koyu ön yüz, altına düşen
/// gölge), altında hafif koyulaşan ahşap ve dikey tahta damarları. Reçeteler
/// raf kenarına bantla yapıştırılıp asılır (2026-10-27).
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
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.counter, AppColors.counterDeep],
              ),
            ),
            child: CustomPaint(painter: _GrainPainter(), child: child),
          ),
        ),
      ],
    );
  }
}

/// Tahta damarı: 23 pikselde bir kalın, 9 pikselde bir ince silik çizgi.
class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wide = Paint()..color = AppColors.counterGrain.withValues(alpha: 0.05);
    final thin = Paint()..color = AppColors.counterGrain.withValues(alpha: 0.03);
    for (var x = 0.0; x < size.width; x += 9) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 1, size.height), thin);
    }
    for (var x = 0.0; x < size.width; x += 23) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 2, size.height), wide);
    }
    // Raf kenarının altına düşen gölge.
    final shade = Rect.fromLTWH(0, 0, size.width, 10);
    canvas.drawRect(
      shade,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.counterGrain.withValues(alpha: 0.18), AppColors.counterGrain.withValues(alpha: 0)],
        ).createShader(shade),
    );
  }

  @override
  bool shouldRepaint(_GrainPainter oldDelegate) => false;
}
