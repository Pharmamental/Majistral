import 'package:flutter/material.dart';

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
      Ingredient('Salisilik Asit', '%5', 2.5),
      Ingredient('Sıvı Parafin', '1,25 g', 1.25),
      Ingredient('Beyaz Vazelin', 'ad 50 g', 46.25),
    ],
    calcHint: 'Yüzde toplamdan hesaplanır: 50 g × %5 = 2,5 g salisilik asit. '
        '"ad 50 g" son maddeyle toplamı 50 g\'a tamamla demek: 50 − 2,5 − 1,25 = 46,25 g vazelin.',
    steps: [
      PrescriptionStep('Tartım', station: LabStation.terazi, minutes: 0, interactive: true, icon: Icons.scale_outlined),
      PrescriptionStep('Levigasyon', station: LabStation.havan, minutes: 3, icon: Icons.blender_outlined),
      PrescriptionStep('Karıştırma', station: LabStation.karistirma, minutes: 4, icon: Icons.autorenew),
      PrescriptionStep('Etiket', station: LabStation.ambalaj, minutes: 1, icon: Icons.label_outline),
    ],
    sequenceHint:
        'Salisilik asidi önce sıvı parafinle macun yapmadan vazeline kattığın için merhem kumlu oldu.',
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
      Ingredient('Çinko Oksit', '%20', 12),
      Ingredient('Sıvı Parafin', '%15', 9),
      Ingredient('Beyaz Vazelin', 'ad 60 g', 39),
    ],
    calcHint: 'Her yüzdeyi toplamla çarp: 60 g × %20 = 12 g çinko oksit, 60 g × %15 = 9 g sıvı parafin. '
        '"ad 60 g" vazelinin toplamı 60 g\'a tamamladığını söyler: 60 − 12 − 9 = 39 g.',
    steps: [
      PrescriptionStep('Tartım', station: LabStation.terazi, minutes: 0, interactive: true, icon: Icons.scale_outlined),
      PrescriptionStep('Levigasyon', station: LabStation.havan, minutes: 4, icon: Icons.blender_outlined),
      PrescriptionStep('Karıştırma', station: LabStation.karistirma, minutes: 6, icon: Icons.autorenew),
      PrescriptionStep('Etiket', station: LabStation.ambalaj, minutes: 2, icon: Icons.label_outline),
    ],
    sequenceHint: 'Çinko oksidi önce sıvı parafinle macun yapmadığın için merhem kumlu oldu.',
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
      Ingredient('Metilparaben', '0,25 g', 0.025),
      Ingredient('Propilparaben', '0,15 g', 0.015),
      Ingredient('Sodyum Lauril Sülfat', '10 g', 1),
      Ingredient('Propilen Glikol', '120 g', 12),
      Ingredient('Stearil Alkol', '250 g', 25),
      Ingredient('Beyaz Vazelin', '250 g', 25),
      Ingredient('Distile Su', '370 g', 37),
    ],
    batchNote: 'Formül 1000 g için yazılmış; sen 100 g hazırla.',
    calcHint: '100 g, 1000 g\'ın onda biri: her miktarı 10\'a böl. 250 g → 25 g, 0,25 g → 0,025 g.',
    steps: [
      PrescriptionStep('Tartım', station: LabStation.terazi, minutes: 0, interactive: true, icon: Icons.scale_outlined),
      PrescriptionStep('Isıtma', station: LabStation.isitma, minutes: 10, interactive: true, imagePath: 'assets/images/Burn_icon.webp'),
      PrescriptionStep('Emülsifikasyon', station: LabStation.karistirma, minutes: 9, icon: Icons.autorenew),
      // Krem soğuyana kadar karıştırılır; soğuma da karıştırma istasyonunda.
      PrescriptionStep('Soğuma', station: LabStation.karistirma, minutes: 8, imagePath: 'assets/images/Sogutma_ikon.webp'),
    ],
    sequenceHint: 'Yağ ve su fazı ısıtılmadan karıştırıldığı için krem ayrıştı.',
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
