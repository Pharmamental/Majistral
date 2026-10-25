import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import '../theme/tokens.dart';

// İlk sürümün 5 istasyonu (tasarım belgesi, bölüm 3). Kademe yükseltmesi işin
// süresini kısaltır. Yüzdeler ve fiyatlar yer tutucu; kapalı testte ayarlanacak.

const List<Station> stations = [
  Station(
    name: 'Hassas Terazi',
    tiers: [
      ShopItem(
        name: 'Paslı',
        description: 'Tartım yavaş, süreyi kısaltmaz',
        icon: Icons.scale_outlined,
        color: AppColors.rusty,
        price: 0,
      ),
      ShopItem(
        name: 'İyi durumda',
        description: 'Tartım hızlı, hazırlama süresini %10 kısaltır',
        icon: Icons.scale_outlined,
        color: AppColors.goodCondition,
        price: 1000,
      ),
      ShopItem(
        name: 'En gelişmiş',
        description: 'Dijital terazi, hazırlama süresini %20 kısaltır',
        icon: Icons.scale_outlined,
        color: AppColors.advanced,
        price: 3000,
      ),
    ],
  ),
  Station(
    name: 'Havan ve Havaneli',
    tiers: [
      ShopItem(
        name: 'Paslı',
        description: 'Öğütme ve levigasyon yavaş, süreyi kısaltmaz',
        icon: Icons.blender_outlined,
        color: AppColors.rusty,
        imagePath: 'assets/images/havan_old.webp',
        price: 0,
      ),
      ShopItem(
        name: 'İyi durumda',
        description: 'Öğütme verimi iyi, havan adımını %15 kısaltır',
        icon: Icons.blender_outlined,
        color: AppColors.goodCondition,
        imagePath: 'assets/images/Havan_normal.webp',
        price: 800,
      ),
      ShopItem(
        name: 'En gelişmiş',
        description: 'İnce ve eşit öğütme, havan adımını %30 kısaltır',
        icon: Icons.blender_outlined,
        color: AppColors.advanced,
        imagePath: 'assets/images/Havan_Modern.jpg',
        price: 2500,
      ),
    ],
  ),
  Station(
    name: 'Su Banyosu',
    tiers: [
      ShopItem(
        name: 'Paslı',
        description: 'Isınma yavaş, süreyi kısaltmaz',
        icon: Icons.hot_tub_outlined,
        color: AppColors.rusty,
        price: 0,
      ),
      ShopItem(
        name: 'İyi durumda',
        description: 'Isı dengeli, eritme ve ısıtma adımını %15 kısaltır',
        icon: Icons.hot_tub_outlined,
        color: AppColors.goodCondition,
        price: 1200,
      ),
      ShopItem(
        name: 'En gelişmiş',
        description: 'Termostatlı, eritme ve ısıtma adımını %30 kısaltır',
        icon: Icons.hot_tub_outlined,
        color: AppColors.advanced,
        price: 3500,
      ),
    ],
  ),
  Station(
    name: 'Unguator',
    tiers: [
      ShopItem(
        name: 'Paslı',
        description: 'Merhem ve krem karışımı yavaş, süreyi kısaltmaz',
        icon: Icons.autorenew,
        color: AppColors.rusty,
        price: 0,
      ),
      ShopItem(
        name: 'İyi durumda',
        description: 'Karışım dengeli, karıştırma adımını %15 kısaltır',
        icon: Icons.autorenew,
        color: AppColors.goodCondition,
        price: 1500,
      ),
      ShopItem(
        name: 'En gelişmiş',
        description: 'Otomatik karışım, karıştırma adımını %30 kısaltır',
        icon: Icons.autorenew,
        color: AppColors.advanced,
        price: 4000,
      ),
    ],
  ),
  Station(
    name: 'Soğutma Rafı',
    tiers: [
      ShopItem(
        name: 'Paslı',
        description: 'Tek raf, soğuma yavaş',
        icon: Icons.ac_unit,
        color: AppColors.rusty,
        price: 0,
      ),
      ShopItem(
        name: 'İyi durumda',
        description: 'İki raf, soğuma adımını %15 kısaltır',
        icon: Icons.ac_unit,
        color: AppColors.goodCondition,
        price: 1000,
      ),
      ShopItem(
        name: 'En gelişmiş',
        description: 'Üç raf, soğuma adımını %30 kısaltır',
        icon: Icons.ac_unit,
        color: AppColors.advanced,
        price: 3000,
      ),
    ],
  ),
];
