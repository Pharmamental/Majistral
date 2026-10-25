import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import '../theme/tokens.dart';

// İlk bölümün (merhem ve krem) aletleri. Basamaklar uydurma "paslı/iyi"
// değil, eczanede gerçekten bulunan aletler (ASHP nonsteril majistral
// bülteni; beyin: majistral-alet-ve-makineler). Oyun etkileri (süre yüzdeleri)
// ve fiyatlar yer tutucu; kapalı testte ayarlanacak.

const List<Station> stations = [
  Station(
    name: 'Terazi',
    tiers: [
      ShopItem(
        name: 'Kefeli eczane terazisi',
        description: 'Ağırlık takımıyla tartar. Çok küçük miktarda hata payı büyür.',
        icon: Icons.scale_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Elektronik hassas terazi',
        description: '0,01 g hassasiyet, hızlı tartım. Tartım adımını %15 kısaltır.',
        icon: Icons.scale_outlined,
        color: AppColors.goodCondition,
        price: 1000,
      ),
      ShopItem(
        name: 'Analitik terazi',
        description: '0,1 mg hassasiyet; çok küçük miktarlar için. Tartım adımını %30 kısaltır.',
        icon: Icons.scale_outlined,
        color: AppColors.advanced,
        price: 3000,
      ),
    ],
  ),
  Station(
    name: 'Havanlar',
    upgradePath: false,
    tiers: [
      ShopItem(
        name: 'Porselen havan',
        description: 'Toz karıştırma, yumuşak kristalleri ezme, geometrik seyreltme.',
        icon: Icons.blender_outlined,
        color: AppColors.rusty,
        imagePath: 'assets/images/Havan_normal.webp',
      ),
      ShopItem(
        name: 'Cam havan',
        description: 'Sıvılar, boyayan ve yağlı maddeler. Kaygandır, toz ezmez.',
        icon: Icons.blender_outlined,
        color: AppColors.goodCondition,
        price: 600,
      ),
      ShopItem(
        name: 'Wedgwood havan',
        description: 'Pürüzlü: sert kristalleri küçültme ve emülsiyon. Boyayan maddeyi emer.',
        icon: Icons.blender_outlined,
        color: AppColors.advanced,
        imagePath: 'assets/images/havan_old.webp',
        price: 900,
      ),
    ],
  ),
  Station(
    name: 'Spatüller',
    upgradePath: false,
    tiers: [
      ShopItem(
        name: 'Çelik spatül',
        description: 'Kuru toz ve ağır merhem. Salisilik asit, iyot, fenolle kullanılmaz.',
        icon: Icons.horizontal_rule_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Plastik spatül',
        description: 'Metalle tepkimeye giren maddeler; krem ve jeli kazımak.',
        icon: Icons.horizontal_rule_rounded,
        color: AppColors.goodCondition,
      ),
    ],
  ),
  Station(
    name: 'Merhem karıştırma',
    tiers: [
      ShopItem(
        name: 'Merhem taşı',
        description: 'Cam levha üzerinde spatülle karıştırma. Krem için de uygun.',
        icon: Icons.crop_square_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Unguator',
        description: 'Elektronik havan: kapalı kavanozda karıştırır, kabarcık bırakmaz. '
            'Karıştırma adımını %30 kısaltır.',
        icon: Icons.autorenew,
        color: AppColors.goodCondition,
        price: 2500,
      ),
      ShopItem(
        name: 'Merhem değirmeni',
        description: 'Üç merdane topakları kırar, merhemi pürüzsüzleştirir. Kumlu merhem riski azalır.',
        icon: Icons.view_week_rounded,
        color: AppColors.advanced,
        price: 4000,
      ),
    ],
  ),
  Station(
    name: 'Isıtma',
    tiers: [
      ShopItem(
        name: 'Ocak ve su banyosu',
        description: 'Bazları eritme, yağ ve su fazını ısıtma.',
        icon: Icons.hot_tub_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Termostatlı su banyosu',
        description: 'Sıcaklığı sabit tutar. Isıtma adımını %25 kısaltır.',
        icon: Icons.hot_tub_outlined,
        color: AppColors.goodCondition,
        price: 1800,
      ),
    ],
  ),
  Station(
    name: 'Ambalaj',
    tiers: [
      ShopItem(
        name: 'Kavanoz',
        description: 'Merhem ve krem yeni, temiz kavanoza konur.',
        icon: Icons.inventory_2_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Tüp doldurma ve kıvırma aleti',
        description: 'Merhemi tüpe doldurup ağzını kıvırır. Etiket adımını %20 kısaltır.',
        icon: Icons.compress_rounded,
        color: AppColors.goodCondition,
        price: 1500,
      ),
    ],
  ),
];
