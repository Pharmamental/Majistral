import 'package:flutter/material.dart';

import '../logic/profile_stats.dart';
import '../theme/tokens.dart';

/// Ustalık madalyası (Tuğrul, 2026-10-28, "A"): ikon metal halkada; halka seviyeyle
/// bronz, gümüş, altın olur, alttaki dört çentik seviyeyi sayar. Renk süs; seviye
/// yanında yazıyla da söylenir. Ölçüler 56'lık profil madalyasına göre oranlanır.
class MasteryMedal extends StatelessWidget {
  const MasteryMedal({super.key, required this.tier, required this.image, this.size = 56, this.notches = true});

  final int tier;
  final String image;
  final double size;
  final bool notches;

  @override
  Widget build(BuildContext context) {
    final k = size / 56;
    final dark = AppColors.medalDark[tier];
    // Başladın'da metal yok: ince gri halka, ikon dairesi büyük.
    final well = (tier == 0 ? 48.0 : 42.0) * k;
    return SizedBox(
      width: size,
      height: notches ? size + 4 : size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.medal[tier],
              shape: BoxShape.circle,
              border: Border.all(color: dark, width: 2),
            ),
          ),
          Positioned(
            top: 5 * k,
            child: Container(
              width: size - 10 * k,
              height: size - 10 * k,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.medalLight[tier], width: 1.5),
              ),
            ),
          ),
          Positioned(
            top: (size - well) / 2,
            child: Container(
              width: well,
              height: well,
              padding: EdgeInsets.all(5 * k),
              decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
              child: Image.asset(image),
            ),
          ),
          if (notches)
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < tiers.length; i++)
                      Container(
                        width: 6,
                        height: 6,
                        margin: EdgeInsets.only(left: i == 0 ? 0 : 3),
                        decoration: BoxDecoration(
                          color: i <= tier ? dark : AppColors.line,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
