import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../screens/preparation_screen.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'job_status.dart';

/// Reçete kartı: üstte hekim, ortada "Rp." ile majistral ve içeriği, altta
/// kartın tek aksiyonu (Hazırla / süren iş / Teslim Et). Aksiyon kartın en
/// altında, başparmağın rahat ulaştığı yerde.
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    final job = JobScope.of(context).jobFor(order.magistralName);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DoctorStrip(order: order),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.lg, AppSpace.xl, AppSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('Rp.', style: AppText.display(size: 24, color: AppColors.kiremit)),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(child: Text(order.magistralName, style: AppText.title(size: 20))),
                  ],
                ),
                const SizedBox(height: AppSpace.xs),
                Text(order.purpose, style: AppText.body(size: 14, color: AppColors.inkMuted)),
                const SizedBox(height: AppSpace.lg),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.sm,
                  children: [for (final c in order.chemicals) _ChemicalChip(name: c)],
                ),
                const SizedBox(height: AppSpace.md),
                // Adımların sırası burada gösterilmez: hazırlama ekranında oyuncu
                // o sırayı kendisi kuruyor. Yalnız iş ne kadar sürer, o yazar.
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 16, color: AppColors.inkMuted),
                    const SizedBox(width: AppSpace.xs),
                    Text(
                      '${order.steps.length} adım · ${order.prepTime.inMinutes} dk',
                      style: AppText.label(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.lg),
                if (job != null)
                  JobStatus(job: job)
                else
                  SizedBox(
                    width: double.infinity,
                    child: ChunkyButton(
                      label: 'Hazırla',
                      icon: Icons.science_rounded,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) => PreparationScreen(order: order)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorStrip extends StatelessWidget {
  const _DoctorStrip({required this.order});

  final PrescriptionOrder order;

  String get _initials {
    final parts = order.doctorName.replaceFirst('Dr. ', '').split(' ');
    return parts.map((p) => p.isEmpty ? '' : p[0]).take(2).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.md, AppSpace.xl, AppSpace.md),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.kiremitSoft,
            child: Text(_initials, style: AppText.title(size: 16, color: AppColors.kiremit)),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.doctorName, style: AppText.body(size: 15, weight: FontWeight.w600)),
                Text(order.doctorBranch, style: AppText.label(size: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Hasta', style: AppText.label(size: 12)),
              Text(order.patientName, style: AppText.body(size: 14, weight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChemicalChip extends StatelessWidget {
  const _ChemicalChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(name, style: AppText.body(size: 13, weight: FontWeight.w500)),
    );
  }
}
