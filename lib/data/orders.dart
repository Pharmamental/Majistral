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
// Alet kuralları ASHP nonsteril majistral bülteninden: cam havan kaygan ve
// toz ezmez (sıvı, boyayan madde için); porselen ve Wedgwood toz/kristal için.
// Salisilik asit çelikle tepkimeye girer. Parşömen kremin suyunu emer.

const _tozHavani = ToolRequirement(
  ToolKind.mortar,
  {'Porselen havan', 'Wedgwood havan'},
  hint: 'Cam havan kaygandır, tozu ezmez; toz için porselen ya da Wedgwood havan kullanılır.',
);

const List<PrescriptionOrder> prescriptionOrders = [
  PrescriptionOrder(
    doctorName: 'Dr. Selin Arı',
    doctorBranch: 'Dermatoloji',
    patientName: 'M. Yılmaz',
    magistralName: '%5 Salisilik Asitli Vazelin',
    purpose: 'Kalınlaşmış, nasırlı deriyi yumuşatma',
    ingredients: [
      Ingredient('Salisilik Asit', '%5'),
      Ingredient('Sıvı Parafin', '1,25 g'),
      Ingredient('Beyaz Vazelin', 'ad 50 g'),
    ],
    steps: [
      PrescriptionStep('Levigasyon', station: LabStation.havan, minutes: 3),
      PrescriptionStep('Karıştırma', station: LabStation.karistirma, minutes: 4),
      PrescriptionStep('Etiket', station: LabStation.ambalaj, minutes: 1),
    ],
    tools: [
      ToolRequirement(
        ToolKind.spatula,
        {'Plastik spatül'},
        hint: 'Salisilik asit çelik spatülle tepkimeye girer; plastik spatül kullanılır.',
      ),
      _tozHavani,
      ToolRequirement(ToolKind.surface, {'Merhem taşı', 'Parşömen blok'}),
    ],
  ),
  PrescriptionOrder(
    doctorName: 'Dr. Kerem Öz',
    doctorBranch: 'Aile Hekimi',
    patientName: 'A. Demir',
    magistralName: 'Çinko Oksit Merhemi',
    purpose: 'Cildi koruyan, kurutan bariyer merhem',
    ingredients: [
      Ingredient('Çinko Oksit', '%20'),
      Ingredient('Sıvı Parafin', '%15'),
      Ingredient('Beyaz Vazelin', 'ad 60 g'),
    ],
    steps: [
      PrescriptionStep('Levigasyon', station: LabStation.havan, minutes: 4),
      PrescriptionStep('Karıştırma', station: LabStation.karistirma, minutes: 6),
      PrescriptionStep('Etiket', station: LabStation.ambalaj, minutes: 2),
    ],
    tools: [
      ToolRequirement(ToolKind.spatula, {'Çelik spatül', 'Plastik spatül'}),
      _tozHavani,
      ToolRequirement(ToolKind.surface, {'Merhem taşı', 'Parşömen blok'}),
    ],
  ),
  PrescriptionOrder(
    doctorName: 'Dr. Deniz Kaya',
    doctorBranch: 'Dermatoloji',
    patientName: 'E. Şahin',
    magistralName: 'Hidrofil Merhem',
    purpose: 'Suyla yıkanabilen krem tipi baz',
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
      PrescriptionStep('Isıtma', station: LabStation.isitma, minutes: 10, interactive: true),
      PrescriptionStep('Emülsifikasyon', station: LabStation.karistirma, minutes: 9),
      // Krem soğuyana kadar karıştırılır; soğuma da karıştırma istasyonunda.
      PrescriptionStep('Soğuma', station: LabStation.karistirma, minutes: 8),
    ],
    tools: [
      ToolRequirement(ToolKind.spatula, {'Çelik spatül', 'Plastik spatül'}),
      ToolRequirement(
        ToolKind.surface,
        {'Merhem taşı'},
        hint: 'Parşömen kâğıt kremin suyunu emer; krem cam merhem taşında hazırlanır.',
      ),
    ],
  ),
];
