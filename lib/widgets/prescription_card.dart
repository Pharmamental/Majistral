import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../screens/preparation_screen.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'job_status.dart';

/// Bir reçetenin oyuncu açısından durumu; renk ve etiket buradan gelir.
enum OrderStatus {
  bekliyor('Seni bekliyor', AppColors.bekliyor, AppColors.bekliyorSoft, AppColors.bekliyorText),
  hazir('Hazır', AppColors.hazir, AppColors.hazirSoft, AppColors.hazirText),
  suruyor('Hazırlanıyor', AppColors.suruyor, AppColors.suruyorSoft, AppColors.suruyorText),
  yeni('Yeni reçete', AppColors.yeni, AppColors.yeniSoft, AppColors.yeniText);

  const OrderStatus(this.label, this.color, this.soft, this.text);

  final String label;
  final Color color;
  final Color soft;
  final Color text;

  static OrderStatus of(JobStore store, PrescriptionOrder order) {
    final job = store.jobFor(order.magistralName);
    if (job == null) return yeni;
    if (store.needsAction(job)) return bekliyor;
    if (store.isReady(job)) return hazir;
    return suruyor;
  }
}

/// Reçete kartı. Solda durum renginde şerit (durumun adı grup başlığında);
/// "Rp." ile majistral ve süresi, maddeler gerçek reçetedeki gibi ad–miktar
/// sütunlarında, altta hekim ve hasta, en altta kartın tek aksiyonu.
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final job = store.jobFor(order.magistralName);
    final status = OrderStatus.of(store, order);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 8, color: status.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('Rp.', style: AppText.display(size: 22, color: AppColors.accentText)),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(child: Text(order.magistralName, style: AppText.title(size: 20))),
                        const SizedBox(width: AppSpace.sm),
                        Text('${order.prepTime.inMinutes} dk', style: AppText.label(size: 12)),
                      ],
                    ),
                    Text(order.purpose, style: AppText.body(size: 14, color: AppColors.inkMuted)),
                    const SizedBox(height: AppSpace.md),
                    _Formula(order: order),
                    const SizedBox(height: AppSpace.md),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${order.doctorName} · ${order.doctorBranch}',
                            style: AppText.label(size: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('Hasta ', style: AppText.label(size: 12)),
                        Text(order.patientName, style: AppText.body(size: 13, weight: FontWeight.w600)),
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Reçetenin madde satırları: solda ad, sağda reçetede yazan miktar; sayılar
/// hizalı. Formül başka toplam için yazıldıysa altta not.
class _Formula extends StatelessWidget {
  const _Formula({required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpace.md),
      ),
      child: Column(
        children: [
          for (final (n, i) in order.ingredients.indexed) ...[
            if (n > 0) const Divider(height: 1, color: AppColors.line),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
              child: Row(
                children: [
                  Expanded(child: Text(i.name, style: AppText.body(size: 14))),
                  Text(
                    i.written,
                    style: AppText.body(size: 14, weight: FontWeight.w600).copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (order.batchNote != null) ...[
            const Divider(height: 1, color: AppColors.line),
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.sm, bottom: AppSpace.xs),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentText),
                  const SizedBox(width: AppSpace.xs),
                  Expanded(child: Text(order.batchNote!, style: AppText.label(size: 12, color: AppColors.accentText))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
