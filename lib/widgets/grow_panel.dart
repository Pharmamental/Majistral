import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Widget'ın ekrandaki yeri: pencere buradan büyür, buraya küçülür.
Rect rectOf(BuildContext context) {
  final box = context.findRenderObject()! as RenderBox;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Pencereyi dokunulan şeyin yerinden ([from]) büyüterek ortada açar
/// (Tuğrul, 2026-10-27: alttan gelen pencere yerine "yerinden büyüyen kâğıt").
/// Arkadaki ekran kararır ama görünür; arkaya dokununca pencere küçülüp
/// geldiği yere döner.
Future<T?> openGrowing<T>(
  BuildContext context, {
  required Rect from,
  required WidgetBuilder builder,
  ShapeBorder shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.paper))),
}) => Navigator.of(context).push(GrowRoute<T>(origin: from, builder: builder, shape: shape));

class GrowRoute<T> extends PopupRoute<T> {
  GrowRoute({required this.origin, required this.builder, required this.shape});

  /// Büyümenin başladığı ve kapanınca dönülen yer. Kapanmadan önce
  /// değiştirilirse pencere oraya gider ("Al": reçete tezgâha iner).
  Rect origin;
  final WidgetBuilder builder;
  final ShapeBorder shape;

  static const double maxWidth = 480;

  @override
  Color? get barrierColor => const Color(0x66000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Kapat';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 320);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: size.height * 0.85),
            child: GrowPanel(
              shape: shape,
              child: Builder(builder: builder),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(size.width - 2 * AppSpace.lg, maxWidth);
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
    return AnimatedBuilder(
      animation: curved,
      child: child,
      builder: (context, child) {
        final t = curved.value;
        // Pencere ortada durur; başta dokunulan şeyin ortasında ve onun
        // genişliğinde görünür.
        final shift = origin.center - size.center(Offset.zero);
        final start = (origin.width / width).clamp(0.15, 1.0);
        return Opacity(
          opacity: (t / 0.35).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: shift * (1 - t),
            child: Transform.scale(scale: lerpDouble(start, 1, t), child: child),
          ),
        );
      },
    );
  }
}

/// Ortada açılan pencerenin kâğıdı.
class GrowPanel extends StatelessWidget {
  const GrowPanel({super.key, required this.shape, required this.child});

  final ShapeBorder shape;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      elevation: 12,
      shadowColor: const Color(0x55000000),
      child: child,
    );
  }
}
