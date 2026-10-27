import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../screens/preparation_screen.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
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
/// "Reçete" düğmesine iner (pencerede açılır), yerini adım şeridi alır. En
/// altta kartın tek aksiyonu.
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.order, this.showStatus = false});

  final PrescriptionOrder order;

  /// Kartın başında durum çipi (tezgâhta asılı kartlarda; durum yalnız şeridin
  /// rengiyle anlatılmasın diye).
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final job = store.jobFor(order.magistralName);
    final status = OrderStatus.of(store, order);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: PrescriptionStubBorder(),
        shadows: [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
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
                            ],
                          ),
                        ),
                        if (job != null) ...[
                          const SizedBox(width: AppSpace.sm),
                          _RecipeButton(order: order),
                        ],
                      ],
                    ),
                    if (job == null) ...[
                      const SizedBox(height: AppSpace.xs),
                      Text(order.purpose, style: AppText.body(size: 14, color: AppColors.inkMuted)),
                      const SizedBox(height: AppSpace.md),
                      _Formula(order: order),
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

/// Süren işte reçetenin yerine küçük düğme: maddeler, miktarlar ve kullanım
/// alanı pencerede açılır.
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
        borderRadius: BorderRadius.circular(AppRadius.paperInner),
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
