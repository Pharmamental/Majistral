import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import 'economy.dart';

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
/// ikonun kutusunu boyar (kutu bu rengin %16'sı). Fiyat bir paketin fiyatı
/// (data/economy.dart, [packs]).
ShopItem _chem(String name, String description, String image, Color color) => ShopItem(
      name: name,
      description: description,
      icon: Icons.science_outlined,
      color: color,
      imagePath: 'assets/images/ikon/ikon_$image.png',
      price: packs[name]?.price ?? 0,
    );

// Oyundaki reçetelerin bütün hammaddeleri (Tuğrul, 2026-10-28: "30-40 civarı
// madde, her madde en az 10 reçetede"): 39 madde, rollerine göre. Reçetelerde
// geçmeyen madde markette durmaz; reçeteye yeni madde girerse buraya da eklenir
// (test/market_items_test.dart). İlk liste ve kaynakları beyinde:
// knowledge/concepts/majistral-hammaddeler.md. Fiyatlar taslak; ekonomi önerisi
// knowledge/concepts/majistral-ekonomi.md.
final List<ChemicalGroup> chemicalGroups = [
  (
    title: 'Bazlar ve yağlar',
    subtitle: 'Merhemin gövdesi',
    items: [
      _chem('Beyaz Vazelin', 'Hidrokarbon baz: deriyi kapatır, suyla yıkanmaz', 'vazelin', _mavi),
      _chem('Sarı Vazelin', 'Ağartılmamış vazelin, koyu renkli merhemlerde baz', 'sari_vazelin', _altin),
      _chem('Sıvı Parafin', 'Levigasyonda tozu macun yapmak için kullanılır', 'sivi_parafin', _altin),
      _chem('Susuz Lanolin', 'Koyun yünü yağı; ağırlığının iki katı su çekebilir', 'lanolin', _yesil),
      _chem('Katı Parafin', 'Merhemi sertleştirip kıvam verir', 'kati_parafin', _mavi),
      _chem('Beyaz Balmumu', 'Kıvam artırır; USP beyaz merheminde', 'balmumu', _mercan),
    ],
  ),
  (
    title: 'Hazır bazlar',
    subtitle: 'Etkin madde katılan krem ve merhemler',
    items: [
      _chem('Sulu Krem', 'Suyla yıkanan yağ-su krem bazı (BP)', 'sulu_krem', _mavi),
      _chem('Yün Yağı Alkolleri Merhemi', 'Su çekebilen yağlı baz (DAB); suyla su-yağ kremi olur', 'yun_yagi_alkolleri', _altin),
      _chem('Setomakrogol Krem', 'Sodyum lauril sülfatsız, hassas cilde uygun krem bazı', 'setomakrogol_krem', _mor),
      _chem('Beyaz Merhem', 'Vazelin ve %5 beyaz balmumu: USP hidrokarbon bazı', 'beyaz_merhem', _mercan),
      _chem('PEG Merhemi', 'Suda çözünen polietilen glikol bazı; povidon iyotta', 'peg_merhemi', _yesil),
    ],
  ),
  (
    title: 'Kıvam ve emülgatör',
    subtitle: 'Kremi bir arada tutar',
    items: [
      _chem('Setostearil Alkol', 'Setil ve stearil alkol karışımı; kreme kıvam verir', 'setostearil_alkol', _mor),
      _chem('Stearil Alkol', 'Hidrofil merhemin yağ fazı, kıvam verir', 'stearil_alkol', _yesil),
      _chem('Sodyum Lauril Sülfat', 'Anyonik emülgatör (HLB 40), hidrofil merhemde', 'sodyum_lauril_sulfat', _mavi),
      _chem('Hidroksietilselüloz', 'Jel yapıcı; suda şişip berrak jel olur', 'hidroksietilseluloz', _yesil),
    ],
  ),
  (
    title: 'Çözücüler ve koruyucular',
    subtitle: 'Sıvının ve kremin sulu kısmı',
    items: [
      _chem('Distile Su', 'Çözeltilerin ve kremlerin su fazı', 'distile_su', _yesil),
      _chem('Gliserin', 'Nemlendirici, suyla karışır', 'gliserin', _altin),
      _chem('Propilen Glikol', 'Nemlendirici ve çözücü; hidrofil merhemin su fazında', 'propilen_glikol', _altin),
      _chem('İzopropil Alkol', 'Çözücü; ter kesici ve akne spiritlerinin taşıyıcısı', 'izopropil_alkol', _mercan),
      _chem('Metilparaben', 'Koruyucu; su fazında çözülür', 'metilparaben', _mercan),
      _chem('Propilparaben', 'Koruyucu; yağ fazına eklenir', 'propilparaben', _mavi),
    ],
  ),
  (
    title: 'Tozlar',
    subtitle: 'Pudra, pat ve kapsülün toz kısmı',
    items: [
      _chem('Nişasta', 'Pudrada ve patta toz kısım; USP çinko oksit patında %25', 'nisasta', _yesil),
      _chem('Talk', 'Kaydırıcı pudra tozu; asbestsiz, saflaştırılmış', 'talk', _yesil),
      _chem('Laktoz', 'Kapsülde dolgu: az miktardaki etkin maddeyi seyreltir', 'laktoz', _mavi),
    ],
  ),
  (
    title: 'Etkin maddeler',
    subtitle: 'Reçeteye adını veren maddeler',
    items: [
      _chem('Salisilik Asit', 'Keratolitik: kalınlaşmış deriyi yumuşatıp soyar', 'salisilik_asit', _mor),
      _chem('Çinko Oksit', 'Cildi korur, kurutur, bariyer oluşturur', 'cinko_oksit', _gri),
      _chem('Üre', 'Nemlendirici ve keratolitik, %10–40', 'ure', _mavi),
      _chem('Kükürt', 'Uyuz ve aknede; sık salisilik asitle birlikte', 'kukurt', _mor),
      _chem('İhtiyol', 'Koyu, kükürtlü sıvı; çıban ve iltihaplı deride', 'ihtiyol', _altin),
      _chem('Mentol', 'Serinletir, kaşıntıyı giderir', 'mentol', _altin),
      _chem('Ditranol', 'Sedef plaklarında; deriyi ve çamaşırı boyar', 'ditranol', _altin),
      _chem('Setrimid', 'Katyonik antiseptik; küçük yara kremlerinde', 'setrimid', _mor),
      _chem('Povidon İyot', 'İyotlu antiseptik; yara ve gargarada', 'povidon_iyot', _altin),
      _chem('Klorheksidin Glukonat %20', 'Antiseptik derişik çözelti; gargarada seyreltilir', 'klorheksidin', _mercan),
      _chem('Alüminyum Klorür', 'Ter bezlerini tıkayan ter kesici; hekzahidrat tuzu', 'aluminyum_klorur', _yesil),
      _chem('Sodyum Bikarbonat', 'Asidi nötralleştirir; asidozda ve kulak kirinde', 'sodyum_bikarbonat', _mavi),
      _chem('Sodyum Klorür', 'Tuz; sodyumu düşük hastada destek, kremde nem tutucu', 'sodyum_klorur', _gri),
      _chem('Sodyum Florür', 'Diş minesini güçlendirir, çürüğü önler', 'sodyum_florur', _mavi),
      _chem('Folik Asit', 'B9 vitamini; folat eksikliği anemisinde', 'folik_asit', _altin),
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
