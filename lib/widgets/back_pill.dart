import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Alt ekranların (sekme dışı) başlık satırı: geri düğmesi + ekran adı.
/// Geri düğmesi 48×48 dokunma alanlı.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.sm, AppSpace.sm, AppSpace.lg, AppSpace.sm),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Geri',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
            style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
          ),
          const SizedBox(width: AppSpace.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.title(size: 22)),
                if (subtitle != null) Text(subtitle!, style: AppText.label()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sekme sayfalarının üst başlığı: büyük başlık + tek satır durum özeti.
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, required this.subtitle, this.trailing});

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.lg, AppSpace.xl, AppSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.display(size: 32)),
                const SizedBox(height: AppSpace.xs),
                Text(subtitle, style: AppText.body(color: AppColors.inkMuted)),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
