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

// Oyundaki reçetelerin bütün hammaddeleri, rollerine göre. Önce 39 madde
// (Tuğrul, 2026-10-28: "30-40 civarı madde, her madde en az 10 reçetede"),
// sonra farklı majistral sayısı artsın diye 62 (Tuğrul, 2026-10-29, "Madde +
// yeni formül"). Reçetelerde geçmeyen madde markette durmaz; reçeteye yeni madde
// girerse buraya da eklenir (test/market_items_test.dart). Liste ve kaynakları
// beyinde: knowledge/concepts/majistral-hammaddeler.md. Fiyatlar taslak; ekonomi
// önerisi knowledge/concepts/majistral-ekonomi.md.
final List<ChemicalGroup> chemicalGroups = [
  (
    title: 'Bazlar ve yağlar',
    subtitle: 'Merhemin gövdesi',
    items: [
      _chem('Beyaz Vazelin', 'Deriyi ince bir örtüyle kapatır, nemi içeride tutar. Suyla yıkanmaz; merhemlerin en temel bazı.', 'vazelin', _mavi),
      _chem('Sarı Vazelin', 'Ağartılmamış vazelin. Beyazı gibi deriyi örter; rengin önemli olmadığı merhemlerde kullanılır.', 'sari_vazelin', _altin),
      _chem('Sıvı Parafin', 'Akışkan, kokusuz yağ. Toza birkaç damla katılınca toz pürüzsüz bir macuna döner.', 'sivi_parafin', _altin),
      _chem('Susuz Lanolin', 'Koyun yününden gelen yağ. Kendi ağırlığının iki katı kadar suyu içine alabilir.', 'lanolin', _yesil),
      _chem('Katı Parafin', 'Mum gibi sert bir yağ. Merhemi koyulaştırır, akmasını önler.', 'kati_parafin', _mavi),
      _chem('Beyaz Balmumu', 'Ağartılmış arı mumu. Merhemi sıkılaştırır, sıcakta erimesini zorlaştırır.', 'balmumu', _mercan),
      _chem('Sarı Balmumu', 'Ağartılmamış arı mumu. Sarı merhemde vazelini koyulaştırır.', 'sari_balmumu', _altin),
      _chem('Kolesterol', 'Vazeline az miktarda katılınca vazelin su çekebilir hâle gelir.', 'kolesterol', _altin),
    ],
  ),
  (
    title: 'Hazır bazlar',
    subtitle: 'Etkin madde katılan krem ve merhemler',
    items: [
      _chem('Sulu Krem', 'Hazır, hafif bir krem. Deriye kolay yayılır, suyla kolayca yıkanır.', 'sulu_krem', _mavi),
      _chem('Yün Yağı Alkolleri Merhemi', 'Su çekebilen yağlı baz. Su katılınca yağlı bir kreme dönüşür.', 'yun_yagi_alkolleri', _altin),
      _chem('Setomakrogol Krem', 'Yumuşak, tahriş etmeyen krem bazı. Hassas deriye uygundur.', 'setomakrogol_krem', _mor),
      _chem('Beyaz Merhem', 'Vazelin ve biraz beyaz balmumundan hazır baz. Vazelinden biraz daha sıkıdır.', 'beyaz_merhem', _mercan),
      _chem('PEG Merhemi', 'Yağ içermeyen, suda çözünen baz. Deriden suyla kolayca çıkar.', 'peg_merhemi', _yesil),
      _chem('Noniyonik Hidrofil Krem', 'Deriyi tahriş etmeyen, suyla yıkanan krem bazı. Mantar kremlerinde sık kullanılır.', 'noniyonik_krem', _yesil),
      _chem('Basit Merhem', 'Lanolin, parafin ve setostearil alkolden yapılmış hazır yağlı baz.', 'basit_merhem', _altin),
      _chem('Emülsiye Edici Merhem', 'Suyla karışabilen susuz baz. Su katılınca sulu krem olur.', 'emulsiye_edici_merhem', _mercan),
    ],
  ),
  (
    title: 'Kıvam ve emülgatör',
    subtitle: 'Kremi bir arada tutar',
    items: [
      _chem('Setostearil Alkol', 'Mumsu bir yağ alkolü. Kreme kıvam verir, yağla suyun ayrılmasını zorlaştırır.', 'setostearil_alkol', _mor),
      _chem('Stearil Alkol', 'Mumsu bir yağ alkolü. Hidrofil merhemin yağlı kısmını oluşturur, kıvam verir.', 'stearil_alkol', _yesil),
      _chem('Sodyum Lauril Sülfat', 'Sabun gibi davranır. Yağı suyun içinde dağıtır, kremi bir arada tutar.', 'sodyum_lauril_sulfat', _mavi),
      _chem('Hidroksietilselüloz', 'Suda şişip berrak bir jel yapan toz. Şeffaf, yapışmayan jellerin temeli.', 'hidroksietilseluloz', _yesil),
      _chem('Hidroksipropilselüloz', 'Alkolde de şişebilen jel yapıcı. Alkollü jeller bununla hazırlanır.', 'hidroksipropilseluloz', _altin),
      _chem('Bentonit', 'Suda şişen ince bir kil. Sıvıdaki tozu askıda tutar, dibe çökmesini yavaşlatır.', 'bentonit', _yesil),
    ],
  ),
  (
    title: 'Çözücüler ve koruyucular',
    subtitle: 'Sıvının ve kremin sulu kısmı',
    items: [
      _chem('Distile Su', 'Saflaştırılmış su. Çözeltilerin ve kremlerin sulu kısmı.', 'distile_su', _yesil),
      _chem('Gliserin', 'Tatlımsı, koyu bir sıvı. Nemi çeker, deriyi yumuşak tutar.', 'gliserin', _altin),
      _chem('Propilen Glikol', 'Renksiz bir sıvı. Bazı maddeleri çözer, deriyi nemli tutar.', 'propilen_glikol', _altin),
      _chem('İzopropil Alkol', 'Çabuk uçan alkol. Maddeleri çözer; ter ve sivilce losyonlarını taşır.', 'izopropil_alkol', _mercan),
      _chem('Etanol %96', 'Güçlü alkol. Maddeleri çözer, mikrop öldürür; suyla seyreltilip %70 yapılır.', 'etanol', _mavi),
      _chem('Metilparaben', 'Koruyucu. Kremin sulu kısmında mikrop ve küf üremesini önler.', 'metilparaben', _mercan),
      _chem('Propilparaben', 'Koruyucu. Kremin yağlı kısmına katılır, metilparabenle birlikte çalışır.', 'propilparaben', _mavi),
      _chem('Potasyum Sorbat', 'Koruyucu. Jel ve kremde küf ve maya üremesini önler.', 'potasyum_sorbat', _mercan),
    ],
  ),
  (
    title: 'Tozlar',
    subtitle: 'Pudra, pat ve kapsülün toz kısmı',
    items: [
      _chem('Nişasta', 'Nemi çeken yumuşak bir toz. Pudraların ve patların toz kısmı.', 'nisasta', _yesil),
      _chem('Talk', 'Kaygan, ince bir toz. Pudrayı deriye kolay yayar, sürtünmeyi azaltır.', 'talk', _yesil),
      _chem('Laktoz', 'Süt şekeri. Kapsülde çok az olan ilacı seyreltir, kapsülü doldurur.', 'laktoz', _mavi),
    ],
  ),
  (
    title: 'Deri için etkin maddeler',
    subtitle: 'Reçeteye adını veren maddeler',
    items: [
      _chem('Salisilik Asit', 'Kalınlaşmış, pul pul deriyi yumuşatıp soyar. Nasır, siğil ve kepekte kullanılır.', 'salisilik_asit', _mor),
      _chem('Çinko Oksit', 'Beyaz bir toz. Deride koruyucu bir tabaka yapar, ıslak deriyi kurutur; pişikte sık kullanılır.', 'cinko_oksit', _gri),
      _chem('Üre', 'Deriye su bağlar. Az miktarda nemlendirir, çok miktarda sertleşmiş deriyi yumuşatır.', 'ure', _mavi),
      _chem('Laktik Asit', 'Deriyi nemlendirir, pullanan üst tabakayı yavaşça soyar.', 'laktik_asit', _mavi),
      _chem('Kükürt', 'Sivilcede ve uyuzda kullanılır. Çoğu zaman salisilik asitle birlikte yazılır.', 'kukurt', _mor),
      _chem('İhtiyol', 'Kükürtlü, koyu kahverengi bir sıvı. Çıbanı ve iltihaplı deriyi yatıştırır.', 'ihtiyol', _altin),
      _chem('Ditranol', 'Sedef hastalığının kalın plaklarında kullanılır. Deriyi ve çamaşırı boyar.', 'ditranol', _altin),
      _chem('Mentol', 'Deride serinlik hissi verir, kaşıntıyı hafifletir.', 'mentol', _altin),
      _chem('Kâfur', 'Serinletir; kaşıntıyı ve hafif ağrıyı azaltır.', 'kafur', _mor),
      _chem('Kalamin', 'Pembe renkli çinko oksit. Kaşıntılı, tahriş olmuş deriyi yatıştırır.', 'kalamin', _mercan),
      _chem('Krotamiton', 'Uyuz tedavisinde ve kaşıntıyı gidermede kullanılan yağlı bir sıvı.', 'krotamiton', _mor),
      _chem('Allantoin', 'Tahriş olmuş deriyi yatıştırır, kendini yenilemesine yardım eder.', 'allantoin', _mor),
      _chem('Mikonazol Nitrat', 'Mantar ilacı. Deri mantarında ve ağızdaki pamukçukta kullanılır.', 'mikonazol', _yesil),
      _chem('Klotrimazol', 'Mantar ilacı. Ayak ve kasık mantarında kullanılır.', 'klotrimazol', _mor),
      _chem('Benzoik Asit', 'Mantara karşı etkilidir. Whitfield merheminde salisilik asitle birlikte bulunur.', 'benzoik_asit', _altin),
      _chem('Alüminyum Klorür', 'Ter bezlerinin ağzını geçici olarak kapatır. Aşırı terlemede kullanılır.', 'aluminyum_klorur', _yesil),
    ],
  ),
  (
    title: 'Antiseptik ve uyuşturucu',
    subtitle: 'Yara, ağız ve kulak için',
    items: [
      _chem('Setrimid', 'Mikrop öldüren bir antiseptik. Küçük yara ve kesik kremlerinde kullanılır.', 'setrimid', _mor),
      _chem('Povidon İyot', 'İyotlu bir antiseptik. Yarayı temizler; gargarada da kullanılır.', 'povidon_iyot', _altin),
      _chem('Klorheksidin Glukonat %20', 'Derişik antiseptik çözelti. Seyreltilince gargarada ve ağız bakımında kullanılır.', 'klorheksidin', _mercan),
      _chem('Hidrojen Peroksit %30', 'Çok derişik peroksit, seyreltilmeden kullanılmaz. Seyreltilince yarayı ve ağzı köpürterek temizler.', 'hidrojen_peroksit', _gri),
      _chem('Buzlu Asetik Asit', 'Saf, susuz sirke asidi. Kulak damlasında kulağı asitleştirip mikrobun üremesini zorlaştırır.', 'asetik_asit', _mavi),
      _chem('Lidokain Hidroklorür', 'Yalnız sürüldüğü yeri uyuşturur. Deride ve ağızda ağrıyı keser.', 'lidokain', _mavi),
      _chem('Benzokain', 'Deri ve ağız yüzeyini uyuşturur. Ağrıyı ve kaşıntıyı hafifletir.', 'benzokain', _altin),
    ],
  ),
  (
    title: 'Ağızdan alınanlar ve tuzlar',
    subtitle: 'Çözelti, kapsül ve paket toz',
    items: [
      _chem('Sodyum Bikarbonat', 'Karbonat. Fazla asidi dengeler; kulak kirini yumuşatan damlada da kullanılır.', 'sodyum_bikarbonat', _mavi),
      _chem('Sodyum Klorür', 'Sofra tuzu. Sodyum desteğinde ve bazı kremlerde nem tutucu olarak kullanılır.', 'sodyum_klorur', _gri),
      _chem('Sodyum Florür', 'Diş minesini güçlendirir, çürüğü önler.', 'sodyum_florur', _mavi),
      _chem('Kalsiyum Karbonat', 'Kalsiyum desteği verir, mide asidini bağlar.', 'kalsiyum_karbonat', _gri),
      _chem('Folik Asit', 'B9 vitamini. Folat eksikliğine bağlı kansızlıkta kullanılır.', 'folik_asit', _altin),
      _chem('Askorbik Asit', 'C vitamini. Eksikliğinde ve destek olarak kullanılır.', 'askorbik_asit', _altin),
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
