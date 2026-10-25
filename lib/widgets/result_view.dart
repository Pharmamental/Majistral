import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Teslim anı (kutlama modu): yıldızlar sırayla büyüyerek gelir, altında
/// hatayı anlatan kısa açıklamalar. Hareket azaltma açıksa animasyon atlanır.
class ResultView extends StatelessWidget {
  const ResultView({super.key, required this.stars, required this.notes});

  final int stars;
  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= 3; i++)
              _Star(filled: i <= stars, delay: Duration(milliseconds: 120 * i), animate: !reduceMotion),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        Text(
          notes.isEmpty ? 'Kusursuz hazırlandı!' : '$stars yıldızlı ürün',
          textAlign: TextAlign.center,
          style: AppText.title(size: 24),
        ),
        if (notes.isNotEmpty) ...[
          const SizedBox(height: AppSpace.lg),
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppColors.kiremit),
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(child: Text(note, style: AppText.body(size: 14))),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.filled, required this.delay, required this.animate});

  final bool filled;
  final Duration delay;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      filled ? Icons.star_rounded : Icons.star_outline_rounded,
      color: filled ? AppColors.star : AppColors.line,
      size: 52,
    );
    if (!animate) return icon;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380) + delay,
      curve: Interval(delay.inMilliseconds / (380 + delay.inMilliseconds), 1, curve: Curves.elasticOut),
      builder: (context, t, child) => Transform.scale(scale: 0.4 + 0.6 * t, child: child),
      child: icon,
    );
  }
}
