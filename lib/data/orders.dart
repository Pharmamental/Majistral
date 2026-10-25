import 'package:flutter/material.dart';

import '../models/prescription.dart';

// Örnek reçeteler. Hekim ve hasta adları uydurma. Formül miktarları bilerek
// yok; içerik yayından önce iki kaynakla doğrulanacak (AGENTS.md).
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
    chemicals: ['Salisilik Asit', 'Sıvı Parafin', 'Beyaz Vazelin'],
    distractors: ['Gliserin', 'Distile Su', 'Çinko Oksit'],
    steps: [
      PrescriptionStep('Tartım', icon: Icons.scale_outlined),
      PrescriptionStep('Levigasyon', icon: Icons.blender_outlined),
      PrescriptionStep('Karıştırma', icon: Icons.autorenew),
      PrescriptionStep('Etiket', icon: Icons.label_outline),
    ],
    sequenceHint:
        'Salisilik asidi önce sıvı parafinle macun yapmadan vazeline kattığın için merhem kumlu oldu.',
    prepTime: Duration(minutes: 10),
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
    chemicals: ['Çinko Oksit', 'Sıvı Parafin', 'Beyaz Vazelin'],
    distractors: ['Salisilik Asit', 'Gliserin', 'Distile Su'],
    steps: [
      PrescriptionStep('Tartım', icon: Icons.scale_outlined),
      PrescriptionStep('Levigasyon', icon: Icons.blender_outlined),
      PrescriptionStep('Karıştırma', icon: Icons.autorenew),
      PrescriptionStep('Etiket', icon: Icons.label_outline),
    ],
    sequenceHint: 'Çinko oksidi önce sıvı parafinle macun yapmadığın için merhem kumlu oldu.',
    prepTime: Duration(minutes: 15),
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
    chemicals: ['Yağ fazı bileşenleri', 'Distile Su', 'Gliserin'],
    distractors: ['Çinko Oksit', 'Salisilik Asit', 'Sıvı Parafin'],
    steps: [
      PrescriptionStep('Tartım', icon: Icons.scale_outlined),
      PrescriptionStep('Isıtma', imagePath: 'assets/images/Burn_icon.webp'),
      PrescriptionStep('Emülsifikasyon', icon: Icons.autorenew),
      PrescriptionStep('Soğuma', imagePath: 'assets/images/Sogutma_ikon.webp'),
    ],
    sequenceHint: 'Yağ ve su fazı ısıtılmadan karıştırıldığı için krem ayrıştı.',
    prepTime: Duration(minutes: 30),
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
