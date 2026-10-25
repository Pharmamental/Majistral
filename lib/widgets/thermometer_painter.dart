import 'package:flutter/material.dart';

class ThermometerPainter extends CustomPainter {
  ThermometerPainter({
    required this.value,
    required this.idealMinFrac,
    required this.idealMaxFrac,
    required this.idealMinLabel,
    required this.idealMaxLabel,
    required this.color,
  });

  final double value;
  final double idealMinFrac;
  final double idealMaxFrac;
  final String idealMinLabel;
  final String idealMaxLabel;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bulbRadius = size.width * 0.28;
    final glassWidth = bulbRadius * 1.15;
    final channelWidth = glassWidth * 0.42;
    final tubeTop = bulbRadius * 0.7;
    final centerX = bulbRadius + 10; // nudged right within the canvas
    final bulbCenter = Offset(centerX, size.height - bulbRadius - 4);
    final tubeBottom = bulbCenter.dy - bulbRadius * 0.35;

    final glassRect = Rect.fromLTWH(centerX - glassWidth / 2, tubeTop, glassWidth, tubeBottom - tubeTop);
    final glassRRect = RRect.fromRectAndRadius(glassRect, Radius.circular(glassWidth / 2));
    final channelRect = Rect.fromLTWH(
      centerX - channelWidth / 2,
      tubeTop + 5,
      channelWidth,
      tubeBottom - tubeTop - 5,
    );
    final channelRRect = RRect.fromRectAndRadius(channelRect, Radius.circular(channelWidth / 2));

    // The tube (rounded rect) and bulb (circle) overlap at the neck; union
    // them into one silhouette so the shadow/fill/outline are seamless
    // instead of showing a double-drawn seam where the two shapes meet.
    final glassPath = Path.combine(
      PathOperation.union,
      Path()..addRRect(glassRRect),
      Path()..addOval(Rect.fromCircle(center: bulbCenter, radius: bulbRadius)),
    );

    // soft drop shadow beneath the glass body
    canvas.drawPath(
      glassPath.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // glass body
    canvas.drawPath(glassPath, Paint()..color = Colors.white);

    // ideal-range band across the glass
    final bandTop = channelRect.top + channelRect.height * (1 - idealMaxFrac);
    final bandBottom = channelRect.top + channelRect.height * (1 - idealMinFrac);
    canvas.drawRect(
      Rect.fromLTRB(glassRect.left, bandTop, glassRect.right, bandBottom),
      Paint()..color = Colors.green.withValues(alpha: 0.16),
    );
    final bandLinePaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.6)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(glassRect.left, bandTop), Offset(glassRect.right, bandTop), bandLinePaint);
    canvas.drawLine(Offset(glassRect.left, bandBottom), Offset(glassRect.right, bandBottom), bandLinePaint);

    // empty mercury channel
    canvas.drawRRect(channelRRect, Paint()..color = const Color(0xFFE7E7EC));

    // tick marks along the right edge
    final tickPaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.2;
    for (var t = 0; t <= 10; t++) {
      final frac = t / 10;
      final y = tubeBottom - (tubeBottom - tubeTop) * frac;
      final isMajor = t % 5 == 0;
      final tickLength = isMajor ? 7.0 : 3.5;
      canvas.drawLine(
        Offset(glassRect.right, y),
        Offset(glassRect.right + tickLength, y),
        tickPaint,
      );
    }

    // mercury fill: union the risen portion of the channel with the bulb
    // into one shape, so the mercury tapers smoothly from tube into bulb
    // instead of showing a seam where the two separately-drawn shapes met.
    final fillTop = channelRect.top + channelRect.height * (1 - value);
    final fillRect = Rect.fromLTRB(channelRect.left, fillTop, channelRect.right, channelRect.bottom);
    final bulbFillRadius = bulbRadius * 0.72;
    final bulbFillCircle = Rect.fromCircle(center: bulbCenter, radius: bulbFillRadius);
    final channelFillPath = Path.combine(
      PathOperation.intersect,
      Path()..addRRect(channelRRect),
      Path()..addRect(fillRect),
    );
    final mercuryPath = Path.combine(
      PathOperation.union,
      channelFillPath,
      Path()..addOval(bulbFillCircle),
    );
    final mercuryBounds = Rect.fromLTRB(
      channelRect.left,
      fillTop,
      channelRect.right,
      bulbFillCircle.bottom,
    );
    canvas.drawPath(
      mercuryPath,
      Paint()
        ..shader = LinearGradient(
          colors: [color.withValues(alpha: 0.85), color, color.withValues(alpha: 0.85)],
        ).createShader(mercuryBounds),
    );

    // glossy highlight on the bulb, as a soft radial sheen rather than a
    // flat dot, to read more like a lit sphere
    canvas.drawCircle(
      bulbCenter,
      bulbFillRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.9,
          colors: [Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0.0)],
          stops: const [0.0, 0.7],
        ).createShader(bulbFillCircle),
    );

    // glass reflection stripe running down the tube
    final highlightRect = Rect.fromLTWH(
      glassRect.left + glassRect.width * 0.16,
      tubeTop + 4,
      glassRect.width * 0.16,
      glassRect.height - 8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(highlightRect, Radius.circular(highlightRect.width / 2)),
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );

    // glass outline — one continuous stroke around the unioned silhouette
    canvas.drawPath(
      glassPath,
      Paint()
        ..color = Colors.black38
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // degree labels for the ideal band
    _drawLabel(canvas, idealMaxLabel, Offset(glassRect.right + 10, bandTop));
    _drawLabel(canvas, idealMinLabel, Offset(glassRect.right + 10, bandBottom));
  }

  void _drawLabel(Canvas canvas, String text, Offset anchor) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black54),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(anchor.dx, anchor.dy - painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant ThermometerPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.idealMinFrac != idealMinFrac ||
      oldDelegate.idealMaxFrac != idealMaxFrac ||
      oldDelegate.color != color;
}
