import 'package:flutter/material.dart';

import '../models/prescription.dart';
import '../screens/preparation_screen.dart';
import '../theme/tokens.dart';

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    final muted = Colors.black.withValues(alpha: 0.6);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.lg),
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.kiremit.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medical_services_outlined, color: AppColors.kiremit),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.doctorName,
                      style: const TextStyle(
                        fontSize: AppFont.title,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '${order.doctorBranch} · Hasta: ${order.patientName}',
                      style: TextStyle(fontSize: AppFont.caption, color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpace.xxl),
          Text(
            'Rp.',
            style: TextStyle(
              fontSize: AppFont.caption,
              fontWeight: FontWeight.w800,
              color: AppColors.kiremit.withValues(alpha: 0.85),
            ),
          ),
          Text(
            order.magistralName,
            style: const TextStyle(
              fontSize: AppFont.title,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            order.purpose,
            style: TextStyle(fontSize: AppFont.body, color: Colors.black.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            'Gerekli kimyasallar',
            style: TextStyle(fontSize: AppFont.caption, fontWeight: FontWeight.w700, color: muted),
          ),
          const SizedBox(height: AppSpace.sm),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final chemical in order.chemicals)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xs),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Text(
                    chemical,
                    style: const TextStyle(
                      fontSize: AppFont.caption,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            'Adımlar',
            style: TextStyle(fontSize: AppFont.caption, fontWeight: FontWeight.w700, color: muted),
          ),
          const SizedBox(height: AppSpace.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < order.steps.length; i++) ...[
                  _StepIcon(step: order.steps[i]),
                  if (i != order.steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kiremit,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => PreparationScreen(order: order)),
              ),
              child: const Text('Hazırla'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({required this.step});

  final PrescriptionStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: SizedBox(
            width: 64,
            height: 64,
            child: step.imagePath != null
                ? Image.asset(step.imagePath!, fit: BoxFit.cover)
                : Container(
                    color: AppColors.kiremit.withValues(alpha: 0.12),
                    alignment: Alignment.center,
                    child: Icon(step.icon, color: AppColors.kiremit, size: 32),
                  ),
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        SizedBox(
          width: 80,
          child: Text(
            step.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppFont.caption,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
