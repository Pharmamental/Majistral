import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/back_pill.dart';

/// Profil sekmesi (Tuğrul, 2026-10-28): oyuncunun kendi sayfası. İçeriği henüz
/// yok; tasarım boş hâliyle duruyor.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ColoredBox(
          color: AppColors.wall,
          child: TabHeader(title: 'Profil', subtitle: 'Yakında'),
        ),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: ColoredBox(
            color: AppColors.background,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.x3),
                child: Text(
                  'Profil sayfası henüz hazır değil.',
                  textAlign: TextAlign.center,
                  style: AppText.body(color: AppColors.inkMuted),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
