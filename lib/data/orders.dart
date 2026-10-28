import '../models/prescription.dart';

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
// - Salisilik asitli vazelin: Prag Charles Üni. föyündeki %1 formülün
//   levigasyon oranı (asidin yarısı kadar sıvı parafin) %5'e uygulandı.
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

const List<PrescriptionOrder> prescriptionOrders = [
  PrescriptionOrder(
    doctorName: 'Dr. Selin',
    doctorBranch: 'Dermatoloji',
    patientName: 'M. Yılmaz',
    magistralName: '%5 Salisilik Asitli Vazelin',
    purpose: 'Kalınlaşmış, nasırlı deriyi yumuşatma',
    usedFor: 'Nasır, kallus ve siğil gibi kalınlaşmış deride',
    ingredients: [
      Ingredient('Salisilik Asit', '%5'),
      Ingredient('Sıvı Parafin', '1,25 g'),
      Ingredient('Beyaz Vazelin', 'ad 50 g'),
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
  PrescriptionOrder(
    doctorName: 'Dr. Kerem',
    doctorBranch: 'Aile Hekimi',
    patientName: 'A. Demir',
    magistralName: 'Çinko Oksit Merhemi',
    purpose: 'Cildi koruyan, kurutan bariyer merhem',
    usedFor: 'Pişik, sürtünme tahrişi ve hafif deri tahrişlerinde',
    ingredients: [
      Ingredient('Çinko Oksit', '%20'),
      Ingredient('Sıvı Parafin', '%15'),
      Ingredient('Beyaz Vazelin', 'ad 60 g'),
    ],
    steps: [
      // Çinko oksit ince tozdur; ezilmeden sıvı parafinle levige edilir (USP).
      PrescriptionStep('Levigasyon', tool: StepTool.havan, orWith: _levhada, minutes: 5, notWith: _tozHavani),
      PrescriptionStep('Geometrik seyreltme', tool: StepTool.karistirma, orWith: _havanda, minutes: 7),
    ],
  ),
  PrescriptionOrder(
    doctorName: 'Dr. Deniz',
    doctorBranch: 'Dermatoloji',
    patientName: 'E. Şahin',
    magistralName: 'Hidrofil Merhem',
    purpose: 'Suyla yıkanabilen krem tipi baz',
    usedFor: 'Etkin maddeleri taşıyan baz olarak; suyla kolay temizlenmesi istenen kremlerde',
    ingredients: [
      Ingredient('Metilparaben', '0,25 g'),
      Ingredient('Propilparaben', '0,15 g'),
      Ingredient('Sodyum Lauril Sülfat', '10 g'),
      Ingredient('Propilen Glikol', '120 g'),
      Ingredient('Stearil Alkol', '250 g'),
      Ingredient('Beyaz Vazelin', '250 g'),
      Ingredient('Distile Su', '370 g'),
    ],
    batchNote: 'Formül 1000 g için yazılmış; sen 100 g hazırla.',
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
  PrescriptionOrder(
    doctorName: 'Dr. Ayşe',
    doctorBranch: 'Çocuk Hastalıkları',
    patientName: 'B. Kaya',
    magistralName: 'Çinko Oksitli Nişasta Pudrası',
    purpose: 'Bez bölgesini kuru tutan, talksız koruyucu pudra',
    usedFor: 'Bebeklerde pişik ve nemli deride; yüze sürülmez',
    ingredients: [
      Ingredient('Çinko Oksit', '10 g'),
      Ingredient('Nişasta', 'ad 100 g'),
    ],
    steps: [
      PrescriptionStep('Ezme', tool: StepTool.havan, minutes: 2, notWith: _tozHavani),
      PrescriptionStep('Geometrik seyreltme', tool: StepTool.havan, minutes: 4, notWith: _tozHavani),
      PrescriptionStep('Elekten geçirme', tool: StepTool.elek, minutes: 3),
    ],
  ),
  PrescriptionOrder(
    doctorName: 'Dr. Murat',
    doctorBranch: 'Dermatoloji',
    patientName: 'S. Aksoy',
    magistralName: 'Hidroksietilselüloz Jeli %2,5',
    purpose: 'Serinletici, yağsız sulu jel bazı',
    usedFor: 'Etkin madde katılacak jellerde baz olarak; yağsız ürün istenen deride',
    ingredients: [
      Ingredient('Hidroksietilselüloz', '2,5 g'),
      Ingredient('Gliserin', '10 g'),
      Ingredient('Distile Su', 'ad 100 g'),
    ],
    steps: [
      // DAB/NRF: toz gliserinle ıslatılır (topak olmasın), su eklenip şişmeye
      // bırakılır, sonra suyla tamamlanır.
      PrescriptionStep('Karıştırma', tool: StepTool.beher, minutes: 2),
      PrescriptionStep('Şişirme', tool: StepTool.beher, minutes: 10),
      PrescriptionStep('Hacme tamamlama', tool: StepTool.mezur, minutes: 2),
    ],
  ),
  PrescriptionOrder(
    doctorName: 'Dr. Leyla',
    doctorBranch: 'Kadın Hastalıkları',
    patientName: 'N. Çelik',
    magistralName: 'Folik Asit Kapsülü 1 mg',
    purpose: 'Folat eksikliğini gideren vitamin kapsülü',
    usedFor: 'Folat eksikliği anemisinde ve gebelik öncesi destekte',
    ingredients: [
      Ingredient('Folik Asit', '30 mg'),
      Ingredient('Laktoz', 'ad 30 kapsül'),
    ],
    batchNote: '30 kapsül (3 numara) hazırla.',
    steps: [
      PrescriptionStep('Ezme', tool: StepTool.havan, minutes: 1, notWith: _tozHavani),
      PrescriptionStep('Geometrik seyreltme', tool: StepTool.havan, minutes: 4, notWith: _tozHavani),
      PrescriptionStep('Elekten geçirme', tool: StepTool.elek, minutes: 2),
      PrescriptionStep('Kapsül doldurma', tool: StepTool.kapsulAleti, minutes: 6),
    ],
  ),
];
