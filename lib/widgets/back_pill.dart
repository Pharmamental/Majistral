import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Pill-shaped back button reused across sub-screens.
class BackPill extends StatelessWidget {
  const BackPill({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x14000000),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded, color: AppColors.ink, size: 18),
              SizedBox(width: AppSpace.sm),
              Text(
                'Geri',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: AppFont.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alt ekranların başlık satırı: geri düğmesi + ekran adı.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, 0),
      child: Row(
        children: [
          BackPill(onPressed: () => Navigator.of(context).pop()),
          const SizedBox(width: AppSpace.md),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFont.heading,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
