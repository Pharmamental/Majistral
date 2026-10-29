import '../models/order_template.dart';
import '../models/prescription.dart';
import 'order_book.dart';

// Örnek reçeteler. Hekim ve hasta adları uydurma. İçerik yayından önce
// öğretim üyesi/eczacı onayından geçecek (AGENTS.md).
//
// Formül kaynakları (2026-10-26):
// - Hidrofil merhem: USP Hydrophilic Ointment (1000 g formülü); Ankara Üni.
//   açık ders föyü aynı oranı 100 g için veriyor.
// - Çinko oksit merhemi: USP Zinc Oxide Compounded Ointment oranları (%20 ZnO,
//   %15 mineral yağ). USP bazı "beyaz merhem" (vazelin + %5 beyaz balmumu);
//   oyunda beyaz vazelin kullanıldı, bu bir uyarlamadır (Tuğrul'un kararı,
//   2026-10-26; USP'ye çevirme).
// - Salisilik asitli vazelin: İspanya Formulario Nacional FN/2003/PO/032
//   (salisilik asit 5 g, sıvı parafin 3 g, vazelin ad 100 g) 50 g'a indirildi;
//   2026-10-28 formül kontrolünden önce Prag Charles Üni. föyünün oranıydı.
//
// Kullanım alanları (usedFor, 2026-10-27): salisilik asit Drugs.com (AHFS)
// monografı ve beyindeki majistral-ilaclar notu; çinko oksit merhemi
// Kaiser Permanente ve MedicineNet ilaç bilgileri; hidrofil merhem suyla
// uzaklaştırılabilen baz (farmasötik teknoloji ders notları, içerik haritası).
//
// Alet kuralları ASHP nonsteril majistral bülteninden: cam havan kaygan ve
// toz ezmez (sıvı, boyayan madde için); porselen ve Wedgwood toz/kristal için.
// Salisilik asit çelikle tepkimeye girer. Seyreltme merhem taşı üstünde
// spatülle yapılır; Unguator ya da değirmen alınınca o makineyle.

// Adımlar gerçek teknikler (Tuğrul, 2026-10-28; Fırat Üni. merhem beceri kılavuzu,
// Ankara Üni. föyleri, PTCB): katı etkin madde ezilir, sıvıyla macun yapılır
// (levigasyon), baz azar azar ve eşit miktarlarla katılır (geometrik seyreltme).
// Ezme ve levigasyon havanda ya da merhem taşında spatülle; seyreltme spatülle
// ya da havan eliyle. Toz ezildiği için cam havan ezme ve levigasyonda kullanılamaz.
const _levhada = {StepTool.karistirma};
const _havanda = {StepTool.havan};
const _tozHavani = {'Cam havan': 'Cam havan kaygandır, tozu ezmez.'};
const _celikSA = 'Salisilik asit çelikle tepkimeye girer; plastik spatül kullanılır.';

/// Oyunun ilk altı reçetesi, elle yazıldı; ilk hâlleri hep aynı hekim ve
/// hastayla gelir. Hâl sayıları scratchpad'deki uret.py'deki ELLE ile aynı.
const List<OrderTemplate> _handwritten = [
  OrderTemplate(
    doctor: 'Dr. Selin',
    branch: 'Dermatoloji',
    patient: 'M. Yılmaz',
    magistralName: '%5 Salisilik Asitli Vazelin',
    formula: 'Salisilik asitli vazelin %5',
    purpose: 'Kalınlaşmış, nasırlı deriyi yumuşatma',
    usedFor: 'Nasır, kallus ve siğil gibi kalınlaşmış deride',
    base: 50,
    unit: 'g',
    amounts: [
      Amount('Salisilik Asit', 5, '%'),
      Amount('Sıvı Parafin', 1.5, 'g'),
      Amount('Beyaz Vazelin', 50, 'g', ad: true),
    ],
    steps: [
      PrescriptionStep(
        'Ezme',
        tool: StepTool.havan,
        orWith: _levhada,
        minutes: 1,
        notWith: {..._tozHavani, 'Çelik spatül': _celikSA},
      ),
      PrescriptionStep(
        'Levigasyon',
        tool: StepTool.havan,
        orWith: _levhada,
        minutes: 3,
        notWith: {..._tozHavani, 'Çelik spatül': _celikSA},
      ),
      PrescriptionStep(
        'Geometrik seyreltme',
        tool: StepTool.karistirma,
        orWith: _havanda,
        minutes: 4,
        notWith: {'Çelik spatül': _celikSA},
      ),
    ],
  ),
  OrderTemplate(
    doctor: 'Dr. Kerem',
    branch: 'Aile Hekimi',
    patient: 'A. Demir',
    magistralName: 'Çinko Oksit Merhemi',
    formula: 'Çinko oksit merhemi %20 (USP)',
    purpose: 'Cildi koruyan, kurutan bariyer merhem',
    usedFor: 'Pişik, sürtünme tahrişi ve hafif deri tahrişlerinde',
    base: 60,
    unit: 'g',
    amounts: [
      Amount('Çinko Oksit', 20, '%'),
      Amount('Sıvı Parafin', 15, '%'),
      Amount('Beyaz Vazelin', 60, 'g', ad: true),
    ],
    steps: [
      // Çinko oksit ince tozdur; ezilmeden sıvı parafinle levige edilir (USP).
      PrescriptionStep('Levigasyon', tool: StepTool.havan, orWith: _levhada, minutes: 5, notWith: _tozHavani),
      PrescriptionStep('Geometrik seyreltme', tool: StepTool.karistirma, orWith: _havanda, minutes: 7),
    ],
  ),
  OrderTemplate(
    doctor: 'Dr. Deniz',
    branch: 'Dermatoloji',
    patient: 'E. Şahin',
    magistralName: 'Hidrofil Merhem',
    formula: 'Hidrofil merhem (USP, yağ-su krem bazı)',
    purpose: 'Suyla yıkanabilen krem tipi baz',
    usedFor: 'Etkin maddeleri taşıyan baz olarak; suyla kolay temizlenmesi istenen kremlerde',
    base: 1000,
    unit: 'g',
    amounts: [
      Amount('Metilparaben', 0.25, 'g'),
      Amount('Propilparaben', 0.15, 'g'),
      Amount('Sodyum Lauril Sülfat', 10, 'g'),
      Amount('Propilen Glikol', 120, 'g'),
      Amount('Stearil Alkol', 250, 'g'),
      Amount('Beyaz Vazelin', 250, 'g'),
      Amount('Distile Su', 370, 'g'),
    ],
    steps: [
      // Ankara Üni. föyleri ve USP (2026-10-28): stearil alkol ve vazelin porselen
      // kapsülde su banyosunda eritilir (70–72 °C, termometre oyunu); diğer maddeler
      // beherde suda çözülüp aynı sıcaklığa getirilir; su fazı yağ fazına kapsülde
      // karıştırılarak eklenir; krem banyodan alınıp soğuyana kadar karıştırılır.
      PrescriptionStep('Eritme', tool: StepTool.isitma, minutes: 6, interactive: true),
      PrescriptionStep('Çözme', tool: StepTool.isitma, minutes: 4),
      PrescriptionStep('Emülsifikasyon', tool: StepTool.kapsul, minutes: 9),
      PrescriptionStep('Soğutma', tool: StepTool.kapsul, minutes: 8),
    ],
  ),
  // Formül kitabından (2026-10-28): en sık adımlar laboratuvarda. Elekten
  // geçirme (pudra, kapsül), karıştırma, şişirme ve hacme tamamlama (jel),
  // kapsül doldurma. Formül ve kaynaklar data/formulary/ içinde.
  OrderTemplate(
    doctor: 'Dr. Ayşe',
    branch: 'Çocuk Hastalıkları',
    patient: 'B. Kaya',
    magistralName: 'Çinko Oksitli Nişasta Pudrası',
    formula: 'Talksız çinko oksitli nişasta pudrası %10',
    purpose: 'Bez bölgesini kuru tutan, talksız koruyucu pudra',
    usedFor: 'Bebeklerde pişik ve nemli deride; yüze sürülmez',
    base: 100,
    unit: 'g',
    amounts: [
      Amount('Çinko Oksit', 10, 'g'),
      Amount('Nişasta', 100, 'g', ad: true),
    ],
    steps: [
      PrescriptionStep('Ezme', tool: StepTool.havan, minutes: 2, notWith: _tozHavani),
      PrescriptionStep('Geometrik seyreltme', tool: StepTool.havan, minutes: 4, notWith: _tozHavani),
      PrescriptionStep('Elekten geçirme', tool: StepTool.elek, minutes: 3),
    ],
  ),
  OrderTemplate(
    doctor: 'Dr. Murat',
    branch: 'Dermatoloji',
    patient: 'S. Aksoy',
    magistralName: 'Hidroksietilselüloz Jeli %2,5',
    formula: 'Hidroksietilselüloz jeli %2,5',
    purpose: 'Serinletici, yağsız sulu jel bazı',
    usedFor: 'Etkin madde katılacak jellerde baz olarak; yağsız ürün istenen deride',
    base: 100,
    unit: 'g',
    amounts: [
      Amount('Hidroksietilselüloz', 2.5, 'g'),
      Amount('Gliserin', 10, 'g'),
      Amount('Distile Su', 100, 'g', ad: true),
    ],
    steps: [
      // DAB/NRF: toz gliserinle ıslatılır (topak olmasın), su eklenip şişmeye
      // bırakılır, sonra suyla tamamlanır.
      PrescriptionStep('Karıştırma', tool: StepTool.beher, minutes: 2),
      PrescriptionStep('Şişirme', tool: StepTool.beher, minutes: 10),
      PrescriptionStep('Hacme tamamlama', tool: StepTool.mezur, minutes: 2),
    ],
  ),
  OrderTemplate(
    doctor: 'Dr. Leyla',
    branch: 'Kadın Hastalıkları',
    patient: 'N. Çelik',
    magistralName: 'Folik Asit Kapsülü 1 mg',
    formula: 'Folik asit kapsülü 1 mg',
    purpose: 'Folat eksikliğini gideren vitamin kapsülü',
    usedFor: 'Folat eksikliği anemisinde ve gebelik öncesi destekte',
    base: 30,
    unit: 'kapsül',
    capsule: '3 numara',
    amounts: [
      Amount('Folik Asit', 30, 'mg'),
      Amount('Laktoz', 30, 'kapsül', ad: true),
    ],
    steps: [
      PrescriptionStep('Ezme', tool: StepTool.havan, minutes: 1, notWith: _tozHavani),
      PrescriptionStep('Geometrik seyreltme', tool: StepTool.havan, minutes: 4, notWith: _tozHavani),
      PrescriptionStep('Elekten geçirme', tool: StepTool.elek, minutes: 2),
      PrescriptionStep('Kapsül doldurma', tool: StepTool.kapsulAleti, minutes: 6),
    ],
  ),
];

/// Oyundaki bütün reçeteler (112): elle yazılmış altı reçete ve formül
/// kitabından gelenler, her formül bir kez (Tuğrul, 2026-10-29, "her formül tek
/// reçete"). Duvar bunları sırayla döndürür.
final List<PrescriptionOrder> prescriptionOrders = buildOrders([..._handwritten, ...bookTemplates]);

// Hekimlerin dallara göre adları (yalnız unvan ve ilk ad; Tuğrul, 2026-10-27)
// ve hastaların baş harfi + soyadı. Hepsi uydurma.
const _doctors = {
  'Dermatoloji': ['Selin', 'Deniz', 'Murat', 'Ece', 'Kaan', 'Zeynep', 'Barış'],
  'Aile Hekimi': ['Kerem', 'Elif', 'Burak', 'Aslı', 'Onur'],
  'Çocuk Hastalıkları': ['Ayşe', 'Can', 'Nil', 'Emre', 'Sena'],
  'Kadın Hastalıkları': ['Leyla', 'Gizem', 'Mert'],
  'Diş Hekimi': ['Ozan', 'Pınar', 'Cem'],
  'Kulak Burun Boğaz': ['Tolga', 'İpek', 'Volkan'],
  'Genel Cerrahi': ['Serkan', 'Derya', 'Kemal'],
  'Üroloji': ['Okan', 'Melis', 'Tarık'],
  'İç Hastalıkları': ['Hakan', 'Esra', 'Levent', 'Nur'],
};
const _initials = 'ABCDEFGHİKLMNOPRSTUYZ';
const _surnames = [
  'Yılmaz', 'Demir', 'Şahin', 'Kaya', 'Aksoy', 'Çelik', 'Öztürk', 'Arslan', 'Doğan', 'Koç', 'Kurt', 'Özkan',
  'Polat', 'Aydın', 'Erdem', 'Güneş', 'Tekin', 'Yıldız', 'Bulut', 'Keskin', 'Avcı', 'Kılıç', 'Uçar', 'Duman',
];

/// Şablonları reçetelere çevirir, her şablondan bir reçete.
List<PrescriptionOrder> buildOrders(List<OrderTemplate> templates) =>
    [for (final (i, t) in templates.indexed) _order(t, i)];

/// Miktar oyunun mekaniği değil, bilgi (Tuğrul, 2026-10-29): gram ve mL'li
/// formül hep 100 g ya da 100 mL için yazılır; kapsül ve paket kendi sayısıyla.
PrescriptionOrder _order(OrderTemplate t, int i) {
  final counted = t.unit == 'kapsül' || t.unit == 'paket';
  final scale = counted ? 1 : 100 / t.base;
  final names = _doctors[t.branch]!;
  return PrescriptionOrder(
    doctorName: t.doctor ?? 'Dr. ${names[i % names.length]}',
    doctorBranch: t.branch,
    patientName: t.patient ?? '${_initials[(i * 7) % _initials.length]}. ${_surnames[(i * 11) % _surnames.length]}',
    magistralName: t.magistralName,
    formula: t.formula,
    purpose: t.purpose,
    usedFor: t.usedFor,
    ingredients: [for (final a in t.amounts) Ingredient(a.name, _written(a, a.qty * scale))],
    note: t.capsule == null ? null : '${t.capsule} kapsül',
    steps: t.steps,
  );
}

/// Maddenin reçetedeki yazılışı: "%5", "1,5 g", "ad 50 g"; 0,1 g'dan azı
/// miligramla (0,0375 g → "37,5 mg").
String _written(Amount a, num qty) {
  if (a.unit == '%') return '%${_num(a.qty)}';
  final small = a.unit == 'g' && !a.ad && qty < 0.1;
  return '${a.ad ? 'ad ' : ''}${small ? '${_num(qty * 1000)} mg' : '${_num(qty)} ${a.unit}'}';
}

/// 1.5 → "1,5"; 50.0 → "50"; en çok üç ondalık.
String _num(num x) {
  final r = (x * 1000).round() / 1000;
  if (r == r.roundToDouble()) return r.round().toString();
  return r.toString().replaceAll('.', ',');
}
