import 'package:flutter/material.dart';

import '../models/shop_item.dart';

// Hızlandırma yalnız ödüllü reklamla (tasarım belgesi, bölüm 10): bir reklam
// bir işin kalan süresini ve kalitesini yarıya indirir, günde en çok 5 kez.
const ShopItem adSpeedUp = ShopItem(
  name: 'Reklam İzle',
  description: 'Bir işin kalan süresini yarıya indirir, kalite de yarıya iner',
  icon: Icons.play_circle_outline,
  color: Color(0xFF2E7D32),
  buttonLabel: 'İzle 0/5',
  cardColor: Color(0xFF2E7D32),
);

/// Markette bir hammadde grubu: başlık, kısa açıklama ve maddeler.
typedef ChemicalGroup = ({String title, String subtitle, List<ShopItem> items});

ShopItem _chem(String name, String description, int price, {String? image, IconData icon = Icons.science_outlined}) =>
    ShopItem(
      name: name,
      description: description,
      icon: icon,
      color: const Color(0xFF8D6E63),
      imagePath: image == null ? null : 'assets/images/ikon/ikon_$image.png',
      price: price,
    );

// İlk bölümün (merhem, krem, pasta) hammaddeleri, rollerine göre. Liste ve
// kaynakları beyinde: knowledge/concepts/majistral-hammaddeler.md (Ankara
// Üni. föyleri, Letonya ve Etiyopya reçete çalışmaları, USP). Fiyatlar taslak;
// ekonomi Faz 2'de ayarlanacak. İkonu çizilmemiş maddede Material ikonu durur.
final List<ChemicalGroup> chemicalGroups = [
  (
    title: 'Bazlar ve yağlar',
    subtitle: 'Merhemin gövdesi',
    items: [
      _chem('Beyaz Vazelin', 'Hidrokarbon baz: deriyi kapatır, suyla yıkanmaz', 60, image: 'vazelin'),
      _chem('Sarı Vazelin', 'Ağartılmamış vazelin, koyu renkli merhemlerde baz', 50, icon: Icons.spa_outlined),
      _chem('Sıvı Parafin', 'Levigasyonda tozu macun yapmak için kullanılır', 50, image: 'sivi_parafin'),
      _chem('Susuz Lanolin', 'Koyun yünü yağı; ağırlığının iki katı su çekebilir', 90, icon: Icons.spa_outlined),
      _chem('Katı Parafin', 'Merhemi sertleştirip kıvam verir', 50, icon: Icons.view_agenda_outlined),
      _chem('Beyaz Balmumu', 'Kıvam artırır; soğuk kremde ve USP beyaz merheminde', 80, icon: Icons.hexagon_outlined),
      _chem('PEG 400', 'Sıvı polietilen glikol; suda çözünen PEG merheminin yumuşak kısmı', 70, icon: Icons.opacity),
      _chem('PEG 3350', 'Katı polietilen glikol; PEG merhemine kıvam verir', 70, icon: Icons.view_agenda_outlined),
    ],
  ),
  (
    title: 'Kıvam ve emülgatör',
    subtitle: 'Kremi bir arada tutar',
    items: [
      _chem('Setil Alkol', 'Kreme kıvam ve dayanıklılık verir', 70, icon: Icons.grain),
      _chem('Stearil Alkol', 'Hidrofil merhemin yağ fazı, kıvam verir', 70, icon: Icons.grain),
      _chem('Stearik Asit', 'Kremin yağ fazında kıvam verir', 60, icon: Icons.grain),
      _chem('Gliseril Monostearat', 'Kıvam verir, yardımcı emülgatör', 80, icon: Icons.grain),
      _chem('Sodyum Lauril Sülfat', 'Anyonik emülgatör (HLB 40), hidrofil merhemde', 80, icon: Icons.bubble_chart_outlined),
      _chem('Polisorbat 80', 'Tween 80, HLB 15; Span 80 ile karıştırılıp HLB ayarlanır', 90, icon: Icons.bubble_chart_outlined),
      _chem('Sorbitan Monooleat', 'Span 80, HLB 4,3; Tween 80 ile karıştırılır', 90, icon: Icons.bubble_chart_outlined),
    ],
  ),
  (
    title: 'Su fazı ve nemlendirici',
    subtitle: 'Kremin sulu kısmı',
    items: [
      _chem('Distile Su', 'Kremlerin su fazı', 20, image: 'distile_su'),
      _chem('Gliserin', 'Nemlendirici, suyla karışır', 70, image: 'gliserin'),
      _chem('Propilen Glikol', 'Nemlendirici ve çözücü; hidrofil merhemin su fazında', 70, icon: Icons.water_drop_outlined),
    ],
  ),
  (
    title: 'Koruyucular',
    subtitle: 'Sulu kremi mikroptan korur',
    items: [
      _chem('Metilparaben', 'Koruyucu; su fazında çözülür', 90, icon: Icons.health_and_safety_outlined),
      _chem('Propilparaben', 'Koruyucu; yağ fazına eklenir', 90, icon: Icons.health_and_safety_outlined),
    ],
  ),
  (
    title: 'Tozlar',
    subtitle: 'Pastaların toz kısmı',
    items: [
      _chem('Nişasta', 'Pastada toz kısım; USP çinko oksit pastasında %25', 40, icon: Icons.grain),
    ],
  ),
  (
    title: 'Etkin maddeler',
    subtitle: 'Reçetelerde en sık geçenler',
    items: [
      _chem('Salisilik Asit', 'Keratolitik: kalınlaşmış deriyi yumuşatıp soyar', 150, image: 'salisilik_asit'),
      _chem('Çinko Oksit', 'Cildi korur, kurutur, bariyer oluşturur', 120, image: 'cinko_oksit'),
      _chem('Üre', 'Nemlendirici ve keratolitik, %10–40', 120),
      _chem('Kükürt', 'Uyuz ve aknede; sık salisilik asitle birlikte', 110),
      _chem('İhtiyol', 'Koyu, kükürtlü sıvı; çinko pastası ve ovülde', 140),
      _chem('LCD', 'Kömür katranı çözeltisi; sedef hastalığında', 160),
      _chem('Rezorsin', 'Keratolitik; akne ve seborede', 130),
      _chem('Mentol', 'Serinletir, kaşıntıyı giderir', 120),
      _chem('Kafur', 'Kaşıntı giderir, hafif uyuşturur', 110),
      _chem('Benzil Benzoat', 'Uyuz tedavisinde', 130),
    ],
  ),
];
