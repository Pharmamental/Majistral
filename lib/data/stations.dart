import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import '../theme/tokens.dart';

// Market istasyonları laboratuvarın adımlarıdır (Tuğrul, 2026-10-29): her adımın
// bir istasyonu var, adı adımın adı. İlk kart ücretsiz basit alet, sonrakiler
// satın alınan daha iyi alet. Yükseltme yalnız o adımın süresini kısaltır
// ([ShopItem.faster]). Aletler eczanede gerçekten bulunan aletler (ASHP nonsteril
// majistral bülteni. Beyin: majistral-alet-ve-makineler). Yüzdeler ve fiyatlar
// yer tutucu. Kapalı testte ayarlanacak. Yeni aletlerin ikonu henüz çizilmedi.

const List<Station> stations = [
  Station(
    name: 'Ezme',
    tiers: [
      ShopItem(
        name: 'Porselen havan',
        imagePath: 'assets/images/ikon/ikon_havan_porselen.png',
        description: 'Yumuşak kristalleri ezer, tozları karıştırır.',
        icon: Icons.blender_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Wedgwood havan',
        imagePath: 'assets/images/ikon/ikon_havan_wedgwood.png',
        description: 'Pürüzlü iç yüzü sert kristalleri çabuk küçültür. Ezmeyi %30 kısaltır.',
        icon: Icons.blender_outlined,
        color: AppColors.advanced,
        price: 900,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Levigasyon',
    tiers: [
      ShopItem(
        name: 'Merhem taşı ve spatül',
        imagePath: 'assets/images/ikon/ikon_merhem_tasi.png',
        description: 'Cam levhada spatülle macun yapma. Salisilik asitte çelik değil plastik spatül.',
        icon: Icons.crop_square_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Merhem değirmeni',
        imagePath: 'assets/images/ikon/ikon_merhem_degirmeni.png',
        description: 'Üç merdane topakları kırar, macunu pürüzsüzleştirir. Levigasyonu %50 kısaltır.',
        icon: Icons.view_week_rounded,
        color: AppColors.advanced,
        price: 4000,
        faster: 50,
      ),
    ],
  ),
  Station(
    name: 'Geometrik seyreltme',
    tiers: [
      ShopItem(
        name: 'Merhem taşı ve spatül',
        imagePath: 'assets/images/ikon/ikon_merhem_tasi.png',
        description: 'Bazı eşit miktarlarla azar azar katma.',
        icon: Icons.crop_square_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Unguator',
        imagePath: 'assets/images/ikon/ikon_unguator.png',
        description: 'Elektronik havan: kapalı kavanozda karıştırır, kabarcık bırakmaz. '
            'Geometrik seyreltmeyi %30 kısaltır.',
        icon: Icons.autorenew,
        color: AppColors.goodCondition,
        price: 2500,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Eritme',
    tiers: [
      ShopItem(
        name: 'Ocak ve su banyosu',
        imagePath: 'assets/images/ikon/ikon_ocak_su_banyosu.png',
        description: 'Bazları ve yağ fazını eritme.',
        icon: Icons.hot_tub_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Termostatlı su banyosu',
        imagePath: 'assets/images/ikon/ikon_su_banyosu_termostat.png',
        description: 'Sıcaklığı sabit tutar. Eritmeyi %25 kısaltır.',
        icon: Icons.hot_tub_outlined,
        color: AppColors.goodCondition,
        price: 1800,
        faster: 25,
      ),
    ],
  ),
  Station(
    name: 'Çözme',
    tiers: [
      ShopItem(
        name: 'Beher ve baget',
        imagePath: 'assets/images/ikon/ikon_beher_baget.png',
        description: 'Maddeyi bagetle karıştırarak çözme.',
        icon: Icons.science_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Isıtıcılı manyetik karıştırıcı',
        description: 'Beherin dibindeki mıknatıslı çubuk döner, tabla ılıtır. Çözmeyi %30 kısaltır.',
        icon: Icons.science_outlined,
        color: AppColors.goodCondition,
        price: 800,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Emülsifikasyon',
    tiers: [
      ShopItem(
        name: 'Porselen kapsül',
        imagePath: 'assets/images/ikon/ikon_kapsul_porselen.png',
        description: 'Su fazını yağ fazına katıp spatülle karıştırma.',
        icon: Icons.soup_kitchen_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'El homojenizatörü',
        description: 'Hızla dönen başlık damlacıkları küçültür. Emülsifikasyonu %30 kısaltır.',
        icon: Icons.soup_kitchen_outlined,
        color: AppColors.goodCondition,
        price: 1200,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Soğutma',
    tiers: [
      ShopItem(
        name: 'Porselen kapsül',
        imagePath: 'assets/images/ikon/ikon_kapsul_porselen.png',
        description: 'Krem soğuyana kadar buzsuz, karıştırarak bekleme.',
        icon: Icons.soup_kitchen_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Su ceketli kap',
        description: 'Çeperinden musluk suyu dolaşır. Krem buzsuz ve düzenli soğur. Soğutmayı %30 kısaltır.',
        icon: Icons.soup_kitchen_outlined,
        color: AppColors.goodCondition,
        price: 600,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Elekten geçirme',
    tiers: [
      ShopItem(
        name: 'Elek',
        imagePath: 'assets/images/ikon/ikon_elek.png',
        description: 'Tozu elle sallayarak topaksız, aynı incelikte yapma.',
        icon: Icons.grid_on_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Titreşimli elek',
        description: 'Motor eleği sallar, toz kendiliğinden geçer. Elekten geçirmeyi %30 kısaltır.',
        icon: Icons.grid_on_rounded,
        color: AppColors.goodCondition,
        price: 600,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Karıştırma',
    tiers: [
      ShopItem(
        name: 'Beher ve baget',
        imagePath: 'assets/images/ikon/ikon_beher_baget.png',
        description: 'Sıvıları bagetle karıştırma.',
        icon: Icons.science_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Pervaneli karıştırıcı',
        description: 'Üstten inen pervane karışımı durmadan çevirir. Karıştırmayı %30 kısaltır.',
        icon: Icons.science_outlined,
        color: AppColors.goodCondition,
        price: 800,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Şişirme',
    tiers: [
      ShopItem(
        name: 'Beher ve baget',
        imagePath: 'assets/images/ikon/ikon_beher_baget.png',
        description: 'Jel yapıcıyı suyun yüzüne serpip bekleme.',
        icon: Icons.science_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Yüksek devirli karıştırıcı',
        description: 'Jel yapıcıyı girdapta dağıtır. Topak olmaz, çabuk şişer. Şişirmeyi %30 kısaltır.',
        icon: Icons.science_outlined,
        color: AppColors.goodCondition,
        price: 500,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Hacme tamamlama',
    tiers: [
      ShopItem(
        name: 'Mezür',
        imagePath: 'assets/images/ikon/ikon_mezur.png',
        description: 'Çözelti, jel ve süspansiyonu çizgiye kadar tamamlama.',
        icon: Icons.straighten_rounded,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Şişe üstü dispenser',
        description: 'Taşıyıcıyı ayarlı hacimde tek basışta verir. Çizgiye son damlalar kalır. '
            'Hacme tamamlamayı %30 kısaltır.',
        icon: Icons.straighten_rounded,
        color: AppColors.goodCondition,
        price: 400,
        faster: 30,
      ),
    ],
  ),
  Station(
    name: 'Kapsül doldurma',
    tiers: [
      ShopItem(
        name: 'Kapsül doldurma aleti',
        imagePath: 'assets/images/ikon/ikon_kapsul_makinesi.png',
        description: 'Delikli plaka: tozu aynı anda birçok kapsüle eşit doldurur.',
        icon: Icons.medication_outlined,
        color: AppColors.rusty,
      ),
      ShopItem(
        name: 'Yarı otomatik kapsül makinesi',
        description: 'Kapsülleri kendisi dizer, açar, kapatır. Kapsül doldurmayı %30 kısaltır.',
        icon: Icons.medication_outlined,
        color: AppColors.goodCondition,
        price: 1000,
        faster: 30,
      ),
    ],
  ),
];

/// Adımın market istasyonu. Reçetede olup markette olmayan adımda null.
Station? stationFor(String step) {
  for (final s in stations) {
    if (s.name == step) return s;
  }
  return null;
}
