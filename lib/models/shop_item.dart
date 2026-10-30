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
    this.faster = 0,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String buttonLabel;
  final Color? cardColor;
  final String? imagePath;
  final int price;

  /// Alet elde olunca istasyonun adımı basit alete göre yüzde kaç kısa sürer.
  final int faster;
}

/// Bir laboratuvar adımının market istasyonu: [name] adımın adı, kartlar
/// basit → gelişmiş sırasıyla bir yükseltme yolu.
class Station {
  const Station({required this.name, required this.tiers});

  final String name;
  final List<ShopItem> tiers;
}
