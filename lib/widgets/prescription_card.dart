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
/// "Rp." ile majistral, altında hekim ve hasta. Yeni reçetede maddeler gerçek
/// reçetedeki gibi ad–miktar sütunlarında ve süre başlıkta; iş başlayınca liste
/// tek satıra katlanır, yerini adım şeridi alır. En altta kartın tek aksiyonu.
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
                        if (job == null) ...[
                          const SizedBox(width: AppSpace.sm),
                          Text('${order.prepTime.inMinutes} dk', style: AppText.label(size: 12)),
                        ],
                      ],
                    ),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '${order.doctorName} · ${order.doctorBranch} · Hasta '),
                        TextSpan(
                          text: order.patientName,
                          style: AppText.label(size: 12, color: AppColors.ink),
                        ),
                      ]),
                      style: AppText.label(size: 12),
                    ),
                    if (job == null) ...[
                      const SizedBox(height: AppSpace.xs),
                      Text(order.purpose, style: AppText.body(size: 14, color: AppColors.inkMuted)),
                      const SizedBox(height: AppSpace.md),
                      _Formula(order: order),
                    ] else ...[
                      const SizedBox(height: AppSpace.md),
                      _FoldedFormula(order: order),
                    ],
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

/// Süren işte reçete tek satır: madde sayısı ve amacı, varsa toplam notu;
/// dokununca madde listesi açılır.
class _FoldedFormula extends StatefulWidget {
  const _FoldedFormula({required this.order});

  final PrescriptionOrder order;

  @override
  State<_FoldedFormula> createState() => _FoldedFormulaState();
}

class _FoldedFormulaState extends State<_FoldedFormula> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpace.md),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpace.md),
            onTap: () => setState(() => _open = !_open),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order.ingredients.length} madde · ${order.purpose}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body(size: 14, weight: FontWeight.w600),
                          ),
                          if (order.batchNote != null)
                            Text(order.batchNote!, style: AppText.label(size: 12, color: AppColors.accentText)),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Text(_open ? 'Gizle' : 'Göster', style: AppText.label(size: 12)),
                    Icon(
                      _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      size: 20,
                      color: AppColors.inkMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_open) ...[
          const SizedBox(height: AppSpace.xs),
          _Formula(order: order, showNote: false),
        ],
      ],
    );
  }
}

/// Reçetenin madde satırları: solda ad, sağda reçetede yazan miktar; sayılar
/// hizalı. Formül başka toplam için yazıldıysa altta not.
class _Formula extends StatelessWidget {
  const _Formula({required this.order, this.showNote = true});

  final PrescriptionOrder order;
  final bool showNote;

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
          if (showNote && order.batchNote != null) ...[
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
