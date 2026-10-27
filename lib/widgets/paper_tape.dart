import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Kâğıt bant parçası (Tuğrul, 2026-10-27): reçeteyi raf kenarına yapıştırır.
/// Hafif saydam bej, iki ucu elle koparılmış gibi tırtıklı, ince bir gölgesi
/// ve boyuna silik lifleri var. [angle] derece cinsinden eğim.
class PaperTape extends StatelessWidget {
  const PaperTape({super.key, this.width = 58, this.height = 22, this.angle = 0});

  final double width;
  final double height;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: CustomPaint(size: Size(width, height), painter: _TapePainter()),
    );
  }
}

class _TapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = _path(size);
    canvas.drawShadow(path, const Color(0xFF3A2418), 1.5, true);
    canvas.drawPath(path, Paint()..color = AppColors.tape);
    // Boyuna lifler.
    final fiber = Paint()
      ..color = AppColors.counterGrain.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (final y in [size.height * 0.3, size.height * 0.62]) {
      canvas.drawLine(Offset(4, y), Offset(size.width - 4, y), fiber);
    }
  }

  /// Uzun kenarlar düz, kısa uçlar dört dişli tırtık.
  Path _path(Size size) {
    const teeth = 4, depth = 2.5;
    final step = size.height / teeth;
    final p = Path()..moveTo(0, 0);
    p.lineTo(size.width, 0);
    for (var i = 0; i < teeth; i++) {
      p.lineTo(size.width - depth, step * i + step / 2);
      p.lineTo(size.width, step * (i + 1));
    }
    p.lineTo(0, size.height);
    for (var i = teeth; i > 0; i--) {
      p.lineTo(depth, step * i - step / 2);
      p.lineTo(0, step * (i - 1));
    }
    return p..close();
  }

  @override
  bool shouldRepaint(_TapePainter oldDelegate) => false;
}
