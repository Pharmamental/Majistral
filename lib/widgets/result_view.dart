import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Hazırlık sonucunun yıldızları ve açıklamaları.
class ResultView extends StatelessWidget {
  const ResultView({super.key, required this.stars, required this.notes});

  final int stars;
  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= 3; i++)
              Icon(
                i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: const Color(0xFFF2A900),
                size: 44,
              ),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        Text(
          notes.isEmpty ? 'Kusursuz hazırlandı!' : '$stars yıldızlı ürün',
          style: const TextStyle(
            fontSize: AppFont.heading,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        for (final note in notes) ...[
          const SizedBox(height: AppSpace.sm),
          Text(
            note,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppFont.body, color: Colors.black.withValues(alpha: 0.7)),
          ),
        ],
      ],
    );
  }
}
