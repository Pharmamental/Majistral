import '../models/prescription.dart';

// Ekonomi (Tuğrul, 2026-10-29, "Evet, önerilerle"; hesap beyinde
// knowledge/concepts/majistral-ekonomi.md, 2. tur). Tek para birimi.
//
// - Teslim = malzeme bedeli (hep tam) + adım başına [laborPerStep] × yıldız oranı.
//   Günün ilk [dailyBonusDeliveries] teslimi emeği iki kat öder.
// - Kimyasal paketle alınır ([packs]), gramla harcanır ([gramsFor]); reçete
//   "Al" anında malzemesini stoktan düşer. Eksik paket o anda alınır; para
//   yetmezse ecza deposu veresiye verir, borç sonraki teslimlerden kesilir.
// - Distile su eczanenin cihazından, bedava.
// - En kötü teslim (1★) bile malzemesini öder: oyuncu takılmaz.
// Sayılar yer tutucu; kapalı testte ayarlanacak.

/// Adım başına emek ücreti. Giderler 14 800'e (aletler + parsel 4-6) göre:
/// düzenli oyuncu ~30 günde, az oynayan ~50 günde hepsini alır.
const laborPerStep = 11;

/// Yıldıza göre emeğin ödenen kısmı (tasarım belgesi bölüm 05).
const starPay = {3: 1.0, 2: 0.7, 1: 0.4};

/// Günün ilk bu kadar teslimi emeği iki kat öder (dengeleyen döngü).
const dailyBonusDeliveries = 3;

/// İlk açılışta kasadaki para; ayrıca her maddeden bir paket rafta.
const startCoins = 100;

/// Bahçenin 4., 5. ve 6. parseli.
const parcelPrices = [800, 1600, 3200];

/// Oyuncu kurutulmuş çiçeğini markette tek tek satar: sıradan, orta, nadir
/// (Tuğrul, 2026-10-29, "marketten çiçeği 1er 1er satabilir"; dükkândan çiçek
/// alma kalktı). Yer tutucu: teslim başına ortalama ~13 para eder (tohum yarı
/// ihtimalle, kademe ağırlıkları %47/%43/%10), emek parasının üçte biri kadar.
/// Hasat 1/2/3 çiçek verince (2026-10-30) fiyat bölündü; bir tohumun parası
/// aynı kaldı (10, 30, 75).
const flowerSellPrices = {1: 10, 2: 15, 3: 25};

/// Hastanın sorusunu doğru bilince bıraktığı bahşiş (Tuğrul, 2026-10-30). Yer tutucu.
const patientTip = 10;

/// Hasta günde en çok bu kadar soru sorar: çift emek ödeyen teslimlerle aynı.
const dailyPatientQuestions = dailyBonusDeliveries;

const freeChemicals = {'Distile Su'};

/// Kimyasal paketi: kaç gram, kaç para. Bir paket o maddeyi kullanan yaklaşık 8
/// reçeteye yeter (500 reçetenin medyan gramajından, denge-sim/ekonomi2.py).
const packs = <String, ({int grams, int price})>{
  'Beyaz Vazelin': (grams: 250, price: 30),
  'Sarı Vazelin': (grams: 250, price: 25),
  'Sıvı Parafin': (grams: 50, price: 5),
  'Susuz Lanolin': (grams: 50, price: 15),
  'Katı Parafin': (grams: 25, price: 5),
  'Beyaz Balmumu': (grams: 25, price: 10),
  'Sulu Krem': (grams: 500, price: 90),
  'Yün Yağı Alkolleri Merhemi': (grams: 250, price: 55),
  'Setomakrogol Krem': (grams: 500, price: 110),
  'Beyaz Merhem': (grams: 500, price: 75),
  'PEG Merhemi': (grams: 500, price: 100),
  'Setostearil Alkol': (grams: 25, price: 5),
  'Stearil Alkol': (grams: 250, price: 60),
  'Sodyum Lauril Sülfat': (grams: 10, price: 5),
  'Hidroksietilselüloz': (grams: 25, price: 40),
  'Gliserin': (grams: 100, price: 15),
  'Propilen Glikol': (grams: 100, price: 20),
  'İzopropil Alkol': (grams: 250, price: 30),
  'Metilparaben': (grams: 1, price: 5),
  'Propilparaben': (grams: 1, price: 5),
  'Nişasta': (grams: 100, price: 5),
  'Talk': (grams: 250, price: 15),
  'Laktoz': (grams: 100, price: 15),
  'Salisilik Asit': (grams: 25, price: 20),
  'Çinko Oksit': (grams: 100, price: 40),
  'Üre': (grams: 100, price: 30),
  'Kükürt': (grams: 25, price: 10),
  'İhtiyol': (grams: 50, price: 60),
  'Mentol': (grams: 5, price: 10),
  'Ditranol': (grams: 1, price: 40),
  'Setrimid': (grams: 5, price: 20),
  'Povidon İyot': (grams: 50, price: 75),
  'Klorheksidin Glukonat %20': (grams: 5, price: 5),
  'Alüminyum Klorür': (grams: 50, price: 25),
  'Sodyum Bikarbonat': (grams: 100, price: 10),
  'Sodyum Klorür': (grams: 100, price: 5),
  'Sodyum Florür': (grams: 1, price: 5),
  'Folik Asit': (grams: 1, price: 30),
  // 62 maddeye çıkış (2026-10-29): aynı kural, fiyat benzer maddenin gram fiyatından.
  'Sarı Balmumu': (grams: 25, price: 10),
  'Kolesterol': (grams: 25, price: 20),
  'Noniyonik Hidrofil Krem': (grams: 500, price: 100),
  'Basit Merhem': (grams: 500, price: 70),
  'Emülsiye Edici Merhem': (grams: 250, price: 45),
  'Hidroksipropilselüloz': (grams: 10, price: 20),
  'Bentonit': (grams: 50, price: 5),
  'Etanol %96': (grams: 250, price: 30),
  'Potasyum Sorbat': (grams: 1, price: 5),
  'Laktik Asit': (grams: 50, price: 15),
  'Kâfur': (grams: 10, price: 10),
  'Kalamin': (grams: 100, price: 25),
  'Krotamiton': (grams: 50, price: 40),
  'Allantoin': (grams: 5, price: 10),
  'Mikonazol Nitrat': (grams: 10, price: 30),
  'Klotrimazol': (grams: 5, price: 30),
  'Benzoik Asit': (grams: 25, price: 10),
  'Hidrojen Peroksit %30': (grams: 100, price: 15),
  'Buzlu Asetik Asit': (grams: 10, price: 5),
  'Lidokain Hidroklorür': (grams: 10, price: 35),
  'Benzokain': (grams: 25, price: 30),
  'Kalsiyum Karbonat': (grams: 250, price: 10),
  'Askorbik Asit': (grams: 250, price: 25),
};

/// Sıvıların yoğunluğu (g/mL); stok gramla tutulur. Yuvarlak farmakope değerleri.
const _density = {
  'İzopropil Alkol': 0.785,
  'Gliserin': 1.26,
  'Propilen Glikol': 1.036,
  'Sıvı Parafin': 0.86,
  'Klorheksidin Glukonat %20': 1.06,
  'Etanol %96': 0.81,
  'Hidrojen Peroksit %30': 1.11,
  'Buzlu Asetik Asit': 1.05,
  'Laktik Asit': 1.21,
  'Krotamiton': 1.01,
};

/// Bir kapsüle giren laktoz (3 numara 0,30 mL × ~0,6 g/mL; tahmin).
const _capsuleFill = 0.20;

double _n(String s) => double.parse(s.replaceAll(',', '.'));

/// Reçetenin harcadığı maddeler, gram olarak (su dahil; su bedava). Yazılışı
/// okur: "%5", "1,5 g", "30 mg", "10 mL", "ad 100 g", "ad 30 kapsül". Reçete
/// hep 100 g ya da 100 mL için yazılı (2026-10-29), stok bu kadar düşer.
Map<String, double> gramsFor(PrescriptionOrder order) {
  double? total;
  ({String name, String written})? ad;
  for (final i in order.ingredients) {
    if (!i.written.startsWith('ad ')) continue;
    final [q, unit] = i.written.substring(3).split(' ');
    if (unit == 'g' || unit == 'mL') total = _n(q);
  }
  final grams = <String, double>{};
  for (final i in order.ingredients) {
    final w = i.written;
    if (w.startsWith('%')) {
      grams[i.name] = _n(w.substring(1)) / 100 * (total ?? 0);
    } else if (w.startsWith('ad ')) {
      ad = (name: i.name, written: w);
    } else {
      final [q, unit] = w.split(' ');
      var g = _n(q);
      if (unit == 'mg') g /= 1000;
      if (unit == 'mL') g *= _density[i.name] ?? 1;
      grams[i.name] = g;
    }
  }
  if (ad != null) {
    final [q, unit] = ad.written.substring(3).split(' ');
    final rest = grams.values.fold(0.0, (a, b) => a + b);
    grams[ad.name] = unit == 'kapsül'
        ? _n(q) * _capsuleFill - rest
        : _n(q) * (unit == 'mL' ? (_density[ad.name] ?? 1) : 1) - rest;
  }
  return grams;
}

/// Bir gramın fiyatı.
double gramPrice(String chemical) {
  final p = packs[chemical];
  return p == null ? 0 : p.price / p.grams;
}

/// Reçetenin malzeme bedeli (teslimde tam geri ödenir).
int materialCost(PrescriptionOrder order) {
  var cost = 0.0;
  for (final MapEntry(:key, :value) in gramsFor(order).entries) {
    if (!freeChemicals.contains(key)) cost += value * gramPrice(key);
  }
  return cost.round();
}

/// Teslimin dökümü: malzeme, emek (yıldız ve bonuslarla) ve toplam.
typedef Payout = ({int material, int labor, bool dailyBonus, int coins});

/// Teslim parası. [dailyBonus]: günün ilk teslimlerinden mi; [laborBonusPercent]:
/// vitrindeki cilt fanusu.
Payout payoutFor(PrescriptionOrder order, int stars, {required bool dailyBonus, int laborBonusPercent = 0}) {
  final material = materialCost(order);
  final base = order.steps.length * laborPerStep * (starPay[stars] ?? 1);
  final labor = (base * (dailyBonus ? 2 : 1) * (1 + laborBonusPercent / 100)).round();
  return (material: material, labor: labor, dailyBonus: dailyBonus, coins: material + labor);
}
