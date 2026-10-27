import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/counter_top.dart';
import '../widgets/paper_tape.dart';
import '../widgets/prescription_card.dart';
import '../widgets/recipe_sheet.dart';

/// Reçeteler sekmesi (ana döngünün başladığı yer), duvar ve tezgâh (Tuğrul,
/// 2026-10-27). Duvarda hekimlerden gelen, henüz alınmamış reçetelerin küçük
/// fişleri asılı; fişe dokununca reçete açılır, "Al" ile tezgâha iner.
/// Tezgâhta elindeki reçeteler raf kenarına bantla asılı, yan yana durur ve
/// sağa sola kaydırılır (kartı alta uzatıp düğmeyi alta sabitleme denendi,
/// geri alındı). Tezgâhta sıra durumlara göre: seni bekleyen, hazır,
/// hazırlanan. Teslim edilen reçete tezgâhtan kalkar, duvara geri döner.
/// Elde tutma sınırı ve reçetenin kaybolması yok.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

typedef _DeckEntry = ({PrescriptionOrder order, OrderStatus status});

class _OrdersScreenState extends State<OrdersScreen> {
  final _controller = PageController(viewportFraction: 0.88);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Gelen reçeteyi alır; tezgâh yeniden çizilince yeni kart öne gelir.
  Future<void> _take(PrescriptionOrder order) async {
    final store = JobScope.of(context);
    await store.accept(order);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final i = _hand(store).indexWhere((e) => e.order == order);
      if (i >= 0) _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  List<_DeckEntry> _hand(JobStore store) => [
        for (final status in OrderStatus.values)
          if (status != OrderStatus.yeni)
            for (final o in prescriptionOrders)
              if (OrderStatus.of(store, o) == status) (order: o, status: status),
      ];

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final hand = _hand(store);
    final incoming = [for (final o in prescriptionOrders) if (store.jobFor(o.magistralName) == null) o];
    int count(OrderStatus s) => hand.where((e) => e.status == s).length;
    final parts = [
      '${hand.length} elinde',
      if (count(OrderStatus.hazir) > 0) '${count(OrderStatus.hazir)} hazır',
      if (count(OrderStatus.bekliyor) > 0) '${count(OrderStatus.bekliyor)} seni bekliyor',
      if (count(OrderStatus.suruyor) > 0) '${count(OrderStatus.suruyor)} hazırlanıyor',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.md, AppSpace.xl, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('Reçeteler', style: AppText.display(size: 24)),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Text(
                        parts.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label(size: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.sm, AppSpace.xl, 0),
                child: Text(
                  incoming.isEmpty ? 'Şimdilik yeni reçete yok' : 'Gelen reçeteler · ${incoming.length}',
                  style: AppText.label(size: 12, color: AppColors.ink),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.lg),
                clipBehavior: Clip.none,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (i, o) in incoming.indexed) ...[
                      if (i > 0) const SizedBox(width: AppSpace.sm),
                      _Slip(order: o, onTap: () => openRecipe(context, o, onTake: () => _take(o))),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CounterTop(
            child: hand.isEmpty
                ? const _EmptyCounter()
                // Kartlar raf kenarına bantla asılı: bant raf kenarına taşar, bu
                // yüzden sayfa kırpılmaz. Kartlar düz durur (Tuğrul, 2026-10-27).
                : PageView.builder(
                    controller: _controller,
                    clipBehavior: Clip.none,
                    itemCount: hand.length,
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpace.xs + 2,
                        0,
                        AppSpace.xs + 2,
                        AppSpace.md + MediaQuery.paddingOf(context).bottom,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            top: AppSpace.xs,
                            child: SingleChildScrollView(
                              child: PrescriptionCard(order: hand[i].order, showStatus: true),
                            ),
                          ),
                          const Positioned(top: -CounterTop.lip + 3, left: AppSpace.xxl, child: PaperTape(angle: -6)),
                          const Positioned(top: -CounterTop.lip + 4, right: AppSpace.xxl, child: PaperTape(angle: 5)),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Elde reçete yokken tezgâhta bantlı küçük not.
class _EmptyCounter extends StatelessWidget {
  const _EmptyCounter();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.xxl, AppSpace.xl, AppSpace.xxl, 0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.xl, AppSpace.xl, AppSpace.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.paper),
              ),
              child: Text(
                'Tezgâhın boş. Duvardan bir reçete al.',
                textAlign: TextAlign.center,
                style: AppText.body(size: 14, weight: FontWeight.w600),
              ),
            ),
            const Positioned(top: -8, child: PaperTape(width: 36, height: 14)),
          ],
        ),
      ),
    );
  }
}

/// Duvardaki gelen reçete fişi: hekim, ilacın adı ve süresi, üstünde bir parça
/// bant. Bütün fişler aynı boyda, düz ve yeni reçete renginde çerçeveli.
class _Slip extends StatelessWidget {
  const _Slip({required this.order, required this.onTap});

  final PrescriptionOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const status = OrderStatus.yeni;
    return Semantics(
      button: true,
      label: '${order.magistralName}, ${order.doctorName}, gelen reçete',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 112,
              padding: const EdgeInsets.fromLTRB(AppSpace.sm, AppSpace.md, AppSpace.sm, AppSpace.sm),
              decoration: ShapeDecoration(
                color: AppColors.surface,
                shape: const PrescriptionStubBorder(),
                shadows: [BoxShadow(color: status.color.withValues(alpha: 0.45), spreadRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: AppSpace.xs),
                      Flexible(
                        child: Text(
                          order.doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label(size: 11, color: status.text),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xs),
                  // İki satırlık yer hep ayrılır, kısa adlı fiş de aynı boyda kalır.
                  SizedBox(
                    height: 36,
                    child: Text(
                      order.magistralName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title(size: 13),
                    ),
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Row(
                    children: [
                      const Icon(Icons.hourglass_empty_rounded, size: 12, color: AppColors.inkMuted),
                      const SizedBox(width: 2),
                      Text('${order.prepTime.inMinutes} dk', style: AppText.label(size: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const Positioned(top: -8, child: PaperTape(width: 36, height: 14)),
          ],
        ),
      ),
    );
  }
}
