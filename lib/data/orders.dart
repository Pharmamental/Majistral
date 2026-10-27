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
// Salisilik asit çelikle tepkimeye girer. Karıştırma merhem taşı üstünde
// spatülle yapılır; Unguator ya da değirmen alınınca o makineyle.

// Levigasyonlar toz ezer: cam havan bu adımda kullanılamaz.
const _tozHavani = {'Cam havan': 'Cam havan kaygandır, tozu ezmez.'};

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
      PrescriptionStep('Levigasyon', tool: StepTool.havan, minutes: 3, notWith: _tozHavani),
      PrescriptionStep(
        'Karıştırma',
        tool: StepTool.karistirma,
        minutes: 4,
        notWith: {'Çelik spatül': 'Salisilik asit çelikle tepkimeye girer; plastik spatül kullanılır.'},
      ),
      PrescriptionStep('Etiket', tool: StepTool.ambalaj, minutes: 1),
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
      PrescriptionStep('Levigasyon', tool: StepTool.havan, minutes: 4, notWith: _tozHavani),
      PrescriptionStep('Karıştırma', tool: StepTool.karistirma, minutes: 6),
      PrescriptionStep('Etiket', tool: StepTool.ambalaj, minutes: 2),
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
      PrescriptionStep('Isıtma', tool: StepTool.isitma, minutes: 10, interactive: true),
      PrescriptionStep('Emülsifikasyon', tool: StepTool.karistirma, minutes: 9),
      // Krem soğuyana kadar karıştırılır; soğuma da karıştırma aletinde.
      PrescriptionStep('Soğuma', tool: StepTool.karistirma, minutes: 8),
    ],
  ),
];
