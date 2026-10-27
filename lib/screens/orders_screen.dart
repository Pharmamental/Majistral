import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/counter_top.dart';
import '../widgets/paper_tape.dart';
import '../widgets/prescription_card.dart';

/// Reçeteler sekmesi (ana döngünün başladığı yer). Duvarda başlık ve bütün
/// reçetelerin küçük fişleri: oyuncu hangisinin hazır, hangisinin kendisini
/// beklediğini kaydırmadan görür, fişe dokununca o kart gelir. Tezgâhta
/// reçeteler raf kenarına bantla asılı, yan yana durur ve sağa sola kaydırılır
/// (Tuğrul, 2026-10-27; kartı alta uzatıp düğmeyi alta sabitleme denendi, geri alındı).
/// Sıra durumlara göre: seni bekleyen, hazır, hazırlanan, yeni.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

typedef _DeckEntry = ({PrescriptionOrder order, OrderStatus status});

class _OrdersScreenState extends State<OrdersScreen> {
  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _show(int i) =>
      _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final List<_DeckEntry> deck = [
      for (final status in OrderStatus.values)
        for (final o in prescriptionOrders)
          if (OrderStatus.of(store, o) == status) (order: o, status: status),
    ];
    int count(OrderStatus s) => deck.where((e) => e.status == s).length;
    final parts = [
      '${prescriptionOrders.length} reçete',
      if (count(OrderStatus.hazir) > 0) '${count(OrderStatus.hazir)} hazır',
      if (count(OrderStatus.bekliyor) > 0) '${count(OrderStatus.bekliyor)} seni bekliyor',
      if (count(OrderStatus.suruyor) > 0) '${count(OrderStatus.suruyor)} hazırlanıyor',
    ];
    final page = _page.clamp(0, deck.length - 1);

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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.md),
                clipBehavior: Clip.none,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (i, e) in deck.indexed) ...[
                      if (i > 0) const SizedBox(width: AppSpace.sm),
                      _Slip(entry: e, index: i, selected: i == page, onTap: () => _show(i)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CounterTop(
            // Kartlar raf kenarına bantla asılı: bant raf kenarına taşar, bu
            // yüzden sayfa kırpılmaz. Kart bantla birlikte hafif eğik durur;
            // eğim kartın sırasına göre sağa sola değişir.
            child: PageView.builder(
              controller: _controller,
              clipBehavior: Clip.none,
              itemCount: deck.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpace.xs + 2,
                  0,
                  AppSpace.xs + 2,
                  AppSpace.md + MediaQuery.paddingOf(context).bottom,
                ),
                child: Transform.rotate(
                  angle: (i.isEven ? -0.8 : 0.7) * math.pi / 180,
                  alignment: Alignment.topCenter,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        top: AppSpace.xs,
                        child: SingleChildScrollView(
                          child: PrescriptionCard(order: deck[i].order, showStatus: true),
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
        ),
      ],
    );
  }
}

/// Duvardaki küçük reçete fişi: durumu ve ilacın adı, üstünde bir parça bant.
/// Tezgâhta gösterilen kartın fişi durum renginde çerçeveli ve biraz büyük.
class _Slip extends StatelessWidget {
  const _Slip({required this.entry, required this.index, required this.selected, required this.onTap});

  final _DeckEntry entry;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = entry.status;
    return Semantics(
      button: true,
      selected: selected,
      label: '${entry.order.magistralName}, ${status.label}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1 : 0.94,
          duration: const Duration(milliseconds: 200),
          child: Transform.rotate(
            angle: (index.isEven ? 1.2 : -1.0) * math.pi / 180,
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
                    shadows: [
                      BoxShadow(
                        color: selected ? status.color.withValues(alpha: 0.45) : const Color(0x1A3A2418),
                        blurRadius: selected ? 0 : 6,
                        spreadRadius: selected ? 2 : 0,
                        offset: selected ? Offset.zero : const Offset(0, 2),
                      ),
                    ],
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
                              status.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.label(size: 11, color: status.text),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpace.xs),
                      Text(
                        entry.order.magistralName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.title(size: 13),
                      ),
                    ],
                  ),
                ),
                const Positioned(top: -8, child: PaperTape(width: 36, height: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
