import 'package:flutter/material.dart';

/// Marketteki bir satır ya da bir istasyon kademesi kartı.
class ShopItem {
  const ShopItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.buttonLabel = 'Satın Al',
    this.cardColor,
    this.imagePath,
    this.price = 0,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String buttonLabel;
  final Color? cardColor;
  final String? imagePath;
  final int price;
}

/// Bir alet grubu. [upgradePath] doğruysa kartlar basit → gelişmiş sırasıyla
/// bir yükseltme yoludur; yanlışsa (havanlar, spatüller) aynı işin değil,
/// farklı işlerin aletleridir ve kademe gösterilmez.
class Station {
  const Station({required this.name, required this.tiers, this.upgradePath = true});

  final String name;
  final List<ShopItem> tiers;
  final bool upgradePath;
}
