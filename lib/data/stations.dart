import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import '../theme/tokens.dart';

// İlk bölümün (merhem ve krem) aletleri. Basamaklar uydurma "paslı/iyi"
// değil, eczanede gerçekten bulunan aletler (ASHP nonsteril majistral
// bülteni; beyin: majistral-alet-ve-makineler). Oyun etkileri (süre yüzdeleri)
// ve fiyatlar yer tutucu; kapalı testte ayarlanacak.

const List<Station> stations = [
  Station(
    name: 'Havanlar',
    upgradePath: false,
    tiers: [
      ShopItem(
        name: 'Porselen havan',
        imagePath: 'assets/images/ikon/ikon_havan_porselen.png',
        description: 'Toz karıştırma, yumuşak kristalleri ezme, geometrik seyreltme.',
        icon: Icons.blender_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Cam havan',
        imagePath: 'assets/images/ikon/ikon_havan_cam.png',
        description: 'Sıvılar, boyayan ve yağlı maddeler. Kaygandır, toz ezmez.',
        icon: Icons.blender_outlined,
        color: AppColors.goodCondition,
        price: 600,
      ),
      ShopItem(
        name: 'Wedgwood havan',
        imagePath: 'assets/images/ikon/ikon_havan_wedgwood.png',
        description: 'Pürüzlü: sert kristalleri küçültme ve emülsiyon. Boyayan maddeyi emer.',
        icon: Icons.blender_outlined,
        color: AppColors.advanced,
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
        imagePath: 'assets/images/ikon/ikon_spatul_celik.png',
        description: 'Kuru toz ve ağır merhem. Salisilik asit, iyot, fenolle kullanılmaz.',
        icon: Icons.horizontal_rule_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Plastik spatül',
        imagePath: 'assets/images/ikon/ikon_spatul_plastik.png',
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
        imagePath: 'assets/images/ikon/ikon_merhem_tasi.png',
        description: 'Cam levha üzerinde spatülle karıştırma. Krem için de uygun.',
        icon: Icons.crop_square_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Unguator',
        imagePath: 'assets/images/ikon/ikon_unguator.png',
        description: 'Elektronik havan: kapalı kavanozda karıştırır, kabarcık bırakmaz. '
            'Karıştırma adımını %30 kısaltır.',
        icon: Icons.autorenew,
        color: AppColors.goodCondition,
        price: 2500,
      ),
      ShopItem(
        name: 'Merhem değirmeni',
        imagePath: 'assets/images/ikon/ikon_merhem_degirmeni.png',
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
        imagePath: 'assets/images/ikon/ikon_ocak_su_banyosu.png',
        description: 'Bazları eritme, yağ ve su fazını ısıtma.',
        icon: Icons.hot_tub_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Termostatlı su banyosu',
        imagePath: 'assets/images/ikon/ikon_su_banyosu_termostat.png',
        description: 'Sıcaklığı sabit tutar. Isıtma adımını %25 kısaltır.',
        icon: Icons.hot_tub_outlined,
        color: AppColors.goodCondition,
        price: 1800,
      ),
    ],
  ),
  // Eritme yönteminde kap: kremde yağ fazı burada ısıtılır, su fazı buna eklenir,
  // soğuyana kadar burada karıştırılır (Ankara Üni. föyleri, USP; 2026-10-28).
  Station(
    name: 'Kaplar',
    upgradePath: false,
    tiers: [
      ShopItem(
        name: 'Porselen kapsül',
        imagePath: 'assets/images/ikon/ikon_kapsul_porselen.png',
        description: 'Yayvan porselen kap. Bazlar burada eritilir; krem soğuyana kadar burada karıştırılır.',
        icon: Icons.soup_kitchen_outlined,
        color: AppColors.rusty,
      ),
    ],
  ),
  // Formül kitabında en sık geçen adımların aletleri (2026-10-28): karıştırma ve
  // şişirme beherde bagetle, hacme tamamlama mezürde, elekten geçirme elekte,
  // kapsül doldurma delikli plakada (Allen; Aulton; Ph. Eur. kapsül monografı).
  Station(
    name: 'Cam eşya',
    upgradePath: false,
    tiers: [
      ShopItem(
        name: 'Beher ve baget',
        imagePath: 'assets/images/ikon/ikon_beher_baget.png',
        description: 'Sıvıları karıştırma, jel yapıcıyı suda şişirme.',
        icon: Icons.science_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Mezür',
        imagePath: 'assets/images/ikon/ikon_mezur.png',
        description: 'Çözelti, jel ve süspansiyonu çizgiye kadar tamamlama.',
        icon: Icons.straighten_rounded,
        color: AppColors.rusty,
      ),
    ],
  ),
  Station(
    name: 'Toz aletleri',
    upgradePath: false,
    tiers: [
      ShopItem(
        name: 'Elek',
        imagePath: 'assets/images/ikon/ikon_elek.png',
        description: 'Toz karışımını topaksız, aynı incelikte yapar.',
        icon: Icons.grid_on_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Kapsül doldurma aleti',
        imagePath: 'assets/images/ikon/ikon_kapsul_makinesi.png',
        description: 'Delikli plaka: tozu aynı anda birçok kapsüle eşit doldurur.',
        icon: Icons.medication_outlined,
        color: AppColors.rusty,
      ),
    ],
  ),
  Station(
    name: 'Ambalaj',
    tiers: [
      ShopItem(
        name: 'Kavanoz',
        imagePath: 'assets/images/ikon/ikon_kavanoz.png',
        description: 'Merhem ve krem yeni, temiz kavanoza konur.',
        icon: Icons.inventory_2_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Tüp doldurma ve kıvırma aleti',
        imagePath: 'assets/images/ikon/ikon_tup.png',
        description: 'Merhemi tüpe doldurup ağzını kıvırır. Etiket adımını %20 kısaltır.',
        icon: Icons.compress_rounded,
        color: AppColors.goodCondition,
        price: 1500,
      ),
    ],
  ),
];
