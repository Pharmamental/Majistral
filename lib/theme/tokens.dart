import 'package:flutter/material.dart';

// Tasarım tokenları. Kaynak: Tuğrul'un ikinci beynindeki Tasarım Rehberi.
// - Renk 60-30-10: krem zemin (60) + beyaz kart (30) + kiremit vurgu (10, yalnız
//   birincil aksiyon ve önemli bilgi).
// - Boşluk yalnız 4-8-12-16-20-24-32-40-48; köşe kart/buton 20, çip tam yuvarlak.
// - Yazı: başlık ve düğme Baloo 2 (oyun hissi), gövde Rubik; sayaçta sabit genişlikli rakam.

class AppColors {
  AppColors._();

  // Pharmamental paleti (2026-10-25, "oyuncak blok şimdilik" kararı): kırık beyaz + yanık mercan.
  static const Color background = Color(0xFFF2EFE9); // kırık beyaz zemin
  static const Color surface = Color(0xFFFBFAF7); // kartlar
  static const Color surfaceMuted = Color(0xFFF6F3EE); // kart içi ikinci yüzey
  static const Color line = Color(0xFFDCD6CC);

  static const Color ink = Color(0xFF1E1B18);
  static const Color inkMuted = Color(0xFF5E5750);

  // Yanık mercan üzerinde beyaz 3,79:1 (ölçüldü): yalnız büyük kalın yazıya yeter.
  // Küçük vurgu yazısı [accentText] (5,21:1) kullanır.
  static const Color kiremit = Color(0xFFD4603F); // birincil aksiyon
  static const Color kiremitDark = Color(0xFFA9452A); // 3B düğmenin alt kenarı
  static const Color kiremitSoft = Color(0xFFFADBD0);
  static const Color accentText = Color(0xFFB04A2E);

  static const Color success = Color(0xFF2E7D32); // hazır / teslim
  static const Color successDark = Color(0xFF1F5A23);
  static const Color successSoft = Color(0xFFE3F1E3);

  static const Color star = Color(0xFFF2A900);

  // Reçete durumları (2026-10-27): şerit, açık zemin, yazı. Yazı açık zeminde
  // en az 5,1:1 (ölçüldü); şerit süs, durum her zaman yazıyla da söylenir.
  static const Color yeni = kiremit, yeniSoft = kiremitSoft, yeniText = Color(0xFF9C3F25);
  static const Color suruyor = Color(0xFF4C9BE8), suruyorSoft = Color(0xFFDCEBFA), suruyorText = Color(0xFF1D5C96);
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

  static const double card = 20;
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
      _style('Baloo2', size, FontWeight.w800, color, height: 1.1);

  static TextStyle title({double size = 20, Color color = AppColors.ink}) =>
      _style('Baloo2', size, FontWeight.w700, color, height: 1.15);

  static TextStyle button({double size = 18, Color color = Colors.white}) =>
      _style('Baloo2', size, FontWeight.w700, color, height: 1.1);

  static TextStyle body({double size = 15, Color color = AppColors.ink, FontWeight weight = FontWeight.w400}) =>
      _style('Rubik', size, weight, color, height: 1.4);

  static TextStyle label({double size = 13, Color color = AppColors.inkMuted}) =>
      _style('Rubik', size, FontWeight.w600, color, height: 1.3);

  /// Sayaç: rakamlar sabit genişlikte, saniye değişince yazı titremesin.
  static TextStyle timer({double size = 16, Color color = AppColors.accentText}) =>
      _style('Rubik', size, FontWeight.w700, color).copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
