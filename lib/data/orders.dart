import 'package:flutter/material.dart';

import '../models/prescription.dart';

// Örnek reçeteler. Hekim ve hasta adları uydurma. Formül miktarları bilerek
// yok; içerik yayından önce iki kaynakla doğrulanacak (AGENTS.md).

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
  ),
];
