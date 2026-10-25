import 'package:flutter/material.dart';

/// Rounded-rectangle shape that fills a solid band along the bottom and
/// right edges only, giving buttons a flat, hard-edged "3D bezel" — as if a
/// second, darker copy of the button sits behind it and peeks out on the
/// side away from the (top-left) light source. `side.color` is drawn as a
/// translucent overlay so it darkens whatever background color the button
/// actually uses, rather than a fixed tone that would clash with it.
class BevelBorder extends OutlinedBorder {
  const BevelBorder({required this.borderRadius, super.side = BorderSide.none});

  final double borderRadius;

  @override
  ShapeBorder scale(double t) => this;

  @override
  BevelBorder copyWith({BorderSide? side, double? borderRadius}) {
    return BevelBorder(
      borderRadius: borderRadius ?? this.borderRadius,
      side: side ?? this.side,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect);

  double _clampedRadius(Rect rect) =>
      borderRadius < rect.shortestSide / 2 ? borderRadius : rect.shortestSide / 2;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = _clampedRadius(rect);
    return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width <= 0) return;
    canvas.drawPath(
      bevelBandPath(rect, _clampedRadius(rect), side.width),
      Paint()..color = side.color..style = PaintingStyle.fill,
    );
  }
}

/// The bottom+right bezel band as a fillable [Path]: the outer rounded-rect
/// minus an inner rounded-rect inset by [bandWidth] on the bottom and right
/// (flush on top/left). A rounded inner shape — rather than a square clip —
/// makes the band hug the true corner curve all the way round. Shared by
/// [BevelBorder] (for `ElevatedButton`s) and [BevelPainter] (for plain
/// `Container`s that aren't buttons).
Path bevelBandPath(Rect rect, double radius, double bandWidth) {
  final outer = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  final innerRect = Rect.fromLTRB(
    rect.left,
    rect.top,
    rect.right - bandWidth,
    rect.bottom - bandWidth,
  );
  final inner = Path()..addRRect(RRect.fromRectAndRadius(innerRect, Radius.circular(radius)));
  return Path.combine(PathOperation.difference, outer, inner);
}

/// Paints the same bottom+right bezel band as [BevelBorder], for widgets
/// (like `Container`-based tab buttons) that aren't `ElevatedButton`s. Draw
/// as a `CustomPaint(foregroundPainter:)` wrapping the decorated widget.
class BevelPainter extends CustomPainter {
  const BevelPainter({required this.borderRadius});

  static const Color _color = Color(0x40000000);
  static const double _width = 4;

  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = borderRadius < rect.shortestSide / 2 ? borderRadius : rect.shortestSide / 2;
    canvas.drawPath(
      bevelBandPath(rect, r, _width),
      Paint()..color = _color..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant BevelPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius;
}
