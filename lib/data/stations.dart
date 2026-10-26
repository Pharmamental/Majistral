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
        imagePath: 'assets/images/ikon/ikon_terazi_kefeli.png',
        description: 'Ağırlık takımıyla tartar. Çok küçük miktarda hata payı büyür.',
        icon: Icons.scale_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Elektronik hassas terazi',
        imagePath: 'assets/images/ikon/ikon_terazi_elektronik.png',
        description: '0,01 g hassasiyet, hızlı tartım. Tartım adımını %15 kısaltır.',
        icon: Icons.scale_outlined,
        color: AppColors.goodCondition,
        price: 1000,
      ),
      ShopItem(
        name: 'Analitik terazi',
        imagePath: 'assets/images/ikon/ikon_terazi_analitik.png',
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
