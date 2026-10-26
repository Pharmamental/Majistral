import 'package:flutter/material.dart';

import '../models/shop_item.dart';

// Hızlandırma yalnız ödüllü reklamla (tasarım belgesi, bölüm 10): bir reklam
// bir işin kalan süresini yarıya indirir, günde en çok 5 kez.
const ShopItem adSpeedUp = ShopItem(
  name: 'Reklam İzle',
  description: 'Bir işin kalan süresini yarıya indirir',
  icon: Icons.play_circle_outline,
  color: Color(0xFF2E7D32),
  buttonLabel: 'İzle 0/5',
  cardColor: Color(0xFF2E7D32),
);

// İlk bölümün (merhem ve krem) kimyasalları. Açıklamalar ve fiyatlar taslak;
// içerik yayından önce iki kaynakla doğrulanacak (AGENTS.md).
const List<ShopItem> chemicals = [
  ShopItem(
    name: 'Beyaz Vazelin',
    imagePath: 'assets/images/ikon/ikon_vazelin.png',
    description: 'Hidrokarbon merhem bazı, suyla yıkanmaz',
    icon: Icons.spa_outlined,
    color: Color(0xFF757575),
    price: 60,
  ),
  ShopItem(
    name: 'Sıvı Parafin',
    imagePath: 'assets/images/ikon/ikon_sivi_parafin.png',
    description: 'Levigasyonda tozu macun yapmak için kullanılır',
    icon: Icons.opacity,
    color: Color(0xFF8D6E63),
    price: 50,
  ),
  ShopItem(
    name: 'Gliserin',
    imagePath: 'assets/images/ikon/ikon_gliserin.png',
    description: 'Nemlendirici, suyla karışan bileşen',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF00838F),
    price: 70,
  ),
  ShopItem(
    name: 'Distile Su',
    imagePath: 'assets/images/ikon/ikon_distile_su.png',
    description: 'Kremlerin su fazı',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF1565C0),
    price: 20,
  ),
  ShopItem(
    name: 'Çinko Oksit',
    imagePath: 'assets/images/ikon/ikon_cinko_oksit.png',
    description: 'Cilt koruyucu ve kurutucu bariyer oluşturur',
    icon: Icons.shield_outlined,
    color: Color(0xFF757575),
    price: 120,
  ),
  ShopItem(
    name: 'Salisilik Asit',
    imagePath: 'assets/images/ikon/ikon_salisilik_asit.png',
    description: 'Keratolitik: kalınlaşmış deriyi yumuşatıp soyar',
    icon: Icons.science_outlined,
    color: Color(0xFF5D4037),
    price: 150,
  ),
];
