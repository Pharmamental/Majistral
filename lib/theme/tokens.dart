import 'package:flutter/material.dart';

// Tasarım tokenları. Kaynak: Tuğrul'un ikinci beynindeki Tasarım Rehberi.
// - Renk 60-30-10: porselen beyazı zemin (60) + beyaz kart (30) + kobalt vurgu (10,
//   yalnız birincil aksiyon ve önemli bilgi); ahşap tezgâh sıcak karşıtlık.
// - Boşluk yalnız 4-8-12-16-20-24-32-40-48; köşe kart/buton 20, çip tam yuvarlak.
// - Yazı: hepsi Bitter (eski eczane etiketi gibi tırnaklı); başlık ve düğme en kalın (900),
//   sayaçta sabit genişlikli rakam.

class AppColors {
  AppColors._();

  // Eski eczane paleti (Tuğrul, 2026-10-27): porselen kavanoz beyazı + kobalt mavisi +
  // ahşap raf. Krem + kiremit yapay zekânın varsayılanı gibi durduğu için bırakıldı.
  static const Color background = Color(0xFFEEF1F5); // porselen zemin
  static const Color surface = Color(0xFFFCFDFE); // kartlar
  static const Color surfaceMuted = Color(0xFFF1F4F8); // kart içi ikinci yüzey
  static const Color line = Color(0xFFD5DCE4);
  // Adım ikonunun arkasındaki daire (Tuğrul, 2026-10-27): cam ikonlar beyaz kutuda
  // kayboluyordu.
  static const Color iconWell = Color(0xFFDDE3EB);

  static const Color ink = Color(0xFF172033); // mürekkep laciverti
  static const Color inkMuted = Color(0xFF545E70);

  // Kobalt üzerinde beyaz 7,66:1, açık zeminde kobalt yazı 7,01:1 (ölçüldü).
  static const Color kobalt = Color(0xFF1F4FA8); // birincil aksiyon
  static const Color kobaltDark = Color(0xFF163A7D); // 3B düğmenin alt kenarı
  static const Color kobaltSoft = Color(0xFFDCE6F7);
  static const Color accentText = kobalt;

  static const Color success = Color(0xFF2E7D32); // hazır / teslim
  static const Color successDark = Color(0xFF1F5A23);
  static const Color successSoft = Color(0xFFE3F1E3);

  static const Color star = Color(0xFFF2A900);

  // Tezgâh (Tuğrul, 2026-10-27): başlık açık duvarda, reçeteler ahşap tezgâhta.
  // Koyu ceviz (Tuğrul, 2026-10-27): açık, düz çizgili ahşap "yapay zekâ yaptı" diye
  // belli ediyordu; tahtalar tek tek farklı tonda, damarlar düzensiz.
  static const Color wall = Color(0xFFF4F6F9);
  static const List<Color> counterPlanks = [
    Color(0xFF6E4A31),
    Color(0xFF65432C),
    Color(0xFF74503A),
    Color(0xFF6A4630),
  ];
  static const Color counterLip = Color(0xFF8A5E3E); // raf kenarının üst yüzü
  static const Color counterEdge = Color(0xFF4A2F1E); // raf kenarının ön yüzü
  static const Color counterSeam = Color(0x66301C10); // tahta arası derz
  static const Color tape = Color(0xE6F2E4C2); // kâğıt bant, hafif saydam
  static const Color counterGrain = Color(0xFF3E2716); // koyu damar
  static const Color counterGrainLight = Color(0xFF8C6446); // açık damar

  // Laboratuvar tezgâhı (Tuğrul, 2026-10-27, "G1"): koyu gri arduvaz, ince benekli;
  // Reçeteler'in ceviz tezgâhından ayrı bir oda.
  static const Color labBench = Color(0xFF4B535C);
  static const Color labBenchLip = Color(0xFF6B747D); // kenarın üst yüzü
  static const Color labBenchEdge = Color(0xFF343A41); // kenarın ön yüzü

  // Market (Tuğrul, 2026-10-27, "T1"): bordo-beyaz çizgili tente, altında kum tezgâh.
  // Bordo hiçbir durum rengine benzemez. Tezgâhta doğrudan duran yazı `ink` olur
  // (inkMuted kumda soluk kalıyor).
  static const Color awning = Color(0xFF7E2A35);
  static const Color awningLight = Color(0xFFF4EFE6);
  static const Color marketBench = Color(0xFFC4B08F);
  static const Color marketBenchFleck = Color(0xFF7A6446);

  // Reçete durumları (2026-10-27): şerit, açık zemin, yazı. Yazı açık zeminde
  // en az 5,1:1 (ölçüldü); şerit süs, durum her zaman yazıyla da söylenir.
  // Mavi birincil renk olunca "hazırlanıyor" mora geçti.
  static const Color yeni = kobalt, yeniSoft = kobaltSoft, yeniText = Color(0xFF183F8A);
  static const Color suruyor = Color(0xFF7B5CC4), suruyorSoft = Color(0xFFECE6F8), suruyorText = Color(0xFF4D3391);
  static const Color bekliyor = Color(0xFFE9A21E), bekliyorSoft = Color(0xFFFCEBC7), bekliyorText = Color(0xFF7A5200);
  static const Color hazir = success, hazirSoft = successSoft, hazirText = successDark;

  // İstasyon kademeleri.
  static const Color rusty = Color(0xFF8D6E52);
  static const Color goodCondition = Color(0xFF607D8B);
  static const Color advanced = Color(0xFF00838F);
}

class AppSpace {
  AppSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3 = 32;
  static const double x4 = 40;
  static const double x5 = 48;
}

class AppRadius {
  AppRadius._();

  // Şekil görevini söyler (Tuğrul, 2026-10-27): bilgi taşıyan kutular kâğıt gibi
  // az yuvarlak, basılan her şey tam hap, eşya ikonlarının kutusu daire
  // (BoxShape.circle). Reçete kartı koçan (PrescriptionStubBorder).
  static const double paper = 6;
  static const double paperInner = 4;
  static const double pill = 999;
}

/// Metin stilleri. Fontlar değişken olduğu için kalınlık hem [FontWeight] hem
/// `wght` ekseniyle verilir; yoksa bazı cihazlarda hep normal kalınlıkta çizilir.
class AppText {
  AppText._();

  static TextStyle _style(String family, double size, FontWeight weight, Color color,
      {double? height}) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      fontVariations: [FontVariation.weight(weight.value.toDouble())],
      color: color,
      height: height,
    );
  }

  static TextStyle display({double size = 32, Color color = AppColors.ink}) =>
      _style('Bitter', size, FontWeight.w900, color, height: 1.1);

  static TextStyle title({double size = 20, Color color = AppColors.ink}) =>
      _style('Bitter', size, FontWeight.w900, color, height: 1.15);

  static TextStyle button({double size = 18, Color color = Colors.white}) =>
      _style('Bitter', size, FontWeight.w900, color, height: 1.1);

  static TextStyle body({double size = 15, Color color = AppColors.ink, FontWeight weight = FontWeight.w400}) =>
      _style('Bitter', size, weight, color, height: 1.4);

  static TextStyle label({double size = 13, Color color = AppColors.inkMuted}) =>
      _style('Bitter', size, FontWeight.w600, color, height: 1.3);

  /// Sayaç: rakamlar sabit genişlikte, saniye değişince yazı titremesin.
  static TextStyle timer({double size = 16, Color color = AppColors.accentText}) =>
      _style('Bitter', size, FontWeight.w700, color).copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
