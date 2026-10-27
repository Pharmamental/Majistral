import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import 'job_status.dart';
import 'recipe_sheet.dart';

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

  /// Alınmış reçetenin durumu; duvardaki gelen reçete her zaman [yeni].
  static OrderStatus of(JobStore store, PrepJob job) {
    if (store.needsAction(job)) return bekliyor;
    if (store.isReady(job)) return hazir;
    return suruyor;
  }
}

/// Reçete kartı (yan şerit yok, Tuğrul 2026-10-27; durum kartın başındaki çipte).
/// "Rp." ile majistral, altında hekim ve hasta; sağ üstte "Reçete" düğmesi
/// (maddeler ve miktarlar pencerede). Her durumda aynı düzen (Tuğrul,
/// 2026-10-27): ortada adım kutuları ve süre, en altta kartın tek aksiyonu.
/// Yalnız tezgâhtaki, alınmış reçeteler için.
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.job, this.showStatus = false});

  final PrepJob job;

  /// Kartın başında durum çipi (tezgâhta asılı kartlarda).
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final order = store.orderOf(job);
    final status = OrderStatus.of(store, job);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: PrescriptionStubBorder(),
        shadows: [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showStatus) ...[
              _StatusChip(status: status),
              const SizedBox(height: AppSpace.sm),
            ],
            Row(
              children: [
                Expanded(
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
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.sm),
                _RecipeButton(order: order),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            JobStatus(job: job),
          ],
        ),
      ),
    );
  }
}

/// Durumun adı açık zeminli hapta, önünde durum renginde nokta.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: 2),
      decoration: BoxDecoration(color: status.soft, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpace.xs + 2),
          Text(status.label, style: AppText.label(size: 12, color: status.text)),
        ],
      ),
    );
  }
}

/// Maddeler, miktarlar ve kullanım alanı için küçük düğme; pencerede açılır.
class _RecipeButton extends StatelessWidget {
  const _RecipeButton({required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      shape: const StadiumBorder(side: BorderSide(color: AppColors.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => openRecipe(context, order),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.inkMuted),
                const SizedBox(width: AppSpace.xs),
                Text('Reçete', style: AppText.label(size: 13, color: AppColors.ink)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reçete koçanı (Tuğrul, 2026-10-27): üst kenar koçandan koparılmış gibi
/// yarım daire delikli, alt köşeler yuvarlak. Delikler kenara ortalanır.
class PrescriptionStubBorder extends ShapeBorder {
  const PrescriptionStubBorder();

  static const double _pitch = 14;
  static const double _hole = 4.5;
  static const double _radius = AppRadius.paper;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Path()
      ..addRRect(RRect.fromRectAndCorners(
        rect,
        bottomLeft: const Radius.circular(_radius),
        bottomRight: const Radius.circular(_radius),
      ));
    final count = (rect.width / _pitch).floor();
    if (count == 0) return body;
    final first = rect.left + (rect.width - count * _pitch) / 2 + _pitch / 2;
    final holes = Path();
    for (var i = 0; i < count; i++) {
      holes.addOval(Rect.fromCircle(center: Offset(first + i * _pitch, rect.top), radius: _hole));
    }
    return Path.combine(PathOperation.difference, body, holes);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(
      getOuterPath(rect),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.line,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}
