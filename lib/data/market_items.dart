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

const _mavi = Color(0xFF4C9BE8), _mor = Color(0xFF7C5CE6), _yesil = Color(0xFF3DBE7A);
const _altin = Color(0xFFF7BE38), _mercan = Color(0xFFE8553D), _gri = Color(0xFF757575);

/// [image]: tools/ikon_blok/uretici.html'deki oyuncak blok ikonu; [color]
/// ikonun kutusunu boyar (kutu bu rengin %16'sı).
ShopItem _chem(String name, String description, int price, String image, Color color) => ShopItem(
      name: name,
      description: description,
      icon: Icons.science_outlined,
      color: color,
      imagePath: 'assets/images/ikon/ikon_$image.png',
      price: price,
    );

// İlk bölümün (merhem, krem, pasta) hammaddeleri, rollerine göre. Liste ve
// kaynakları beyinde: knowledge/concepts/majistral-hammaddeler.md (Ankara
// Üni. föyleri, Letonya ve Etiyopya reçete çalışmaları, USP). Fiyatlar taslak;
// ekonomi Faz 2'de ayarlanacak.
final List<ChemicalGroup> chemicalGroups = [
  (
    title: 'Bazlar ve yağlar',
    subtitle: 'Merhemin gövdesi',
    items: [
      _chem('Beyaz Vazelin', 'Hidrokarbon baz: deriyi kapatır, suyla yıkanmaz', 60, 'vazelin', _mavi),
      _chem('Sarı Vazelin', 'Ağartılmamış vazelin, koyu renkli merhemlerde baz', 50, 'sari_vazelin', _altin),
      _chem('Sıvı Parafin', 'Levigasyonda tozu macun yapmak için kullanılır', 50, 'sivi_parafin', _altin),
      _chem('Susuz Lanolin', 'Koyun yünü yağı; ağırlığının iki katı su çekebilir', 90, 'lanolin', _yesil),
      _chem('Katı Parafin', 'Merhemi sertleştirip kıvam verir', 50, 'kati_parafin', _mavi),
      _chem('Beyaz Balmumu', 'Kıvam artırır; soğuk kremde ve USP beyaz merheminde', 80, 'balmumu', _mercan),
      _chem('PEG 400', 'Sıvı polietilen glikol; suda çözünen PEG merheminin yumuşak kısmı', 70, 'peg_400', _altin),
      _chem('PEG 3350', 'Katı polietilen glikol; PEG merhemine kıvam verir', 70, 'peg_3350', _mor),
    ],
  ),
  (
    title: 'Kıvam ve emülgatör',
    subtitle: 'Kremi bir arada tutar',
    items: [
      _chem('Setil Alkol', 'Kreme kıvam ve dayanıklılık verir', 70, 'setil_alkol', _mor),
      _chem('Stearil Alkol', 'Hidrofil merhemin yağ fazı, kıvam verir', 70, 'stearil_alkol', _yesil),
      _chem('Stearik Asit', 'Kremin yağ fazında kıvam verir', 60, 'stearik_asit', _mor),
      _chem('Gliseril Monostearat', 'Kıvam verir, yardımcı emülgatör', 80, 'gliseril_monostearat', _mavi),
      _chem('Sodyum Lauril Sülfat', 'Anyonik emülgatör (HLB 40), hidrofil merhemde', 80, 'sodyum_lauril_sulfat', _mavi),
      _chem('Polisorbat 80', 'Tween 80, HLB 15; Span 80 ile karıştırılıp HLB ayarlanır', 90, 'polisorbat_80', _yesil),
      _chem('Sorbitan Monooleat', 'Span 80, HLB 4,3; Tween 80 ile karıştırılır', 90, 'sorbitan_monooleat', _altin),
    ],
  ),
  (
    title: 'Su fazı ve nemlendirici',
    subtitle: 'Kremin sulu kısmı',
    items: [
      _chem('Distile Su', 'Kremlerin su fazı', 20, 'distile_su', _yesil),
      _chem('Gliserin', 'Nemlendirici, suyla karışır', 70, 'gliserin', _altin),
      _chem('Propilen Glikol', 'Nemlendirici ve çözücü; hidrofil merhemin su fazında', 70, 'propilen_glikol', _altin),
    ],
  ),
  (
    title: 'Koruyucular',
    subtitle: 'Sulu kremi mikroptan korur',
    items: [
      _chem('Metilparaben', 'Koruyucu; su fazında çözülür', 90, 'metilparaben', _mercan),
      _chem('Propilparaben', 'Koruyucu; yağ fazına eklenir', 90, 'propilparaben', _mavi),
    ],
  ),
  (
    title: 'Tozlar',
    subtitle: 'Pastaların toz kısmı',
    items: [
      _chem('Nişasta', 'Pastada toz kısım; USP çinko oksit pastasında %25', 40, 'nisasta', _yesil),
    ],
  ),
  (
    title: 'Etkin maddeler',
    subtitle: 'Reçetelerde en sık geçenler',
    items: [
      _chem('Salisilik Asit', 'Keratolitik: kalınlaşmış deriyi yumuşatıp soyar', 150, 'salisilik_asit', _mor),
      _chem('Çinko Oksit', 'Cildi korur, kurutur, bariyer oluşturur', 120, 'cinko_oksit', _gri),
      _chem('Üre', 'Nemlendirici ve keratolitik, %10–40', 120, 'ure', _mavi),
      _chem('Kükürt', 'Uyuz ve aknede; sık salisilik asitle birlikte', 110, 'kukurt', _mor),
      _chem('İhtiyol', 'Koyu, kükürtlü sıvı; çinko pastası ve ovülde', 140, 'ihtiyol', _altin),
      _chem('LCD', 'Kömür katranı çözeltisi; sedef hastalığında', 160, 'lcd', _gri),
      _chem('Rezorsin', 'Keratolitik; akne ve seborede', 130, 'rezorsin', _yesil),
      _chem('Mentol', 'Serinletir, kaşıntıyı giderir', 120, 'mentol', _altin),
      _chem('Kafur', 'Kaşıntı giderir, hafif uyuşturur', 110, 'kafur', _mor),
      _chem('Benzil Benzoat', 'Uyuz tedavisinde', 130, 'benzil_benzoat', _mercan),
    ],
  ),
];

/// Bir hammaddenin marketteki kısa açıklaması (reçetedeki görevi); yoksa null.
String? chemicalRole(String name) {
  for (final g in chemicalGroups) {
    for (final i in g.items) {
      if (i.name == name) return i.description;
    }
  }
  return null;
}
