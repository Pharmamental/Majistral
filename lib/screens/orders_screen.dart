import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/counter_top.dart';
import '../widgets/paper_tape.dart';
import '../widgets/prescription_card.dart';

/// Reçeteler sekmesi (ana döngünün başladığı yer). Başlık duvarda, reçeteler
/// ahşap tezgâhta yan yana durur ve sağa sola kaydırılır (Tuğrul, 2026-10-27).
/// Kartlar tezgâhın raf kenarına bantla asılı. Sıra durumlara göre: seni
/// bekleyen, hazır, hazırlanan, yeni; her kartın içinde durumu yazar, alttaki
/// noktalar durum renginde.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final deck = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: TabHeader(title: 'Reçeteler', subtitle: parts.join(' · ')),
        ),
        Expanded(child: CounterTop(child: _Deck(deck: deck))),
      ],
    );
  }
}

typedef _DeckEntry = ({PrescriptionOrder order, OrderStatus status});

/// Tezgâhtaki reçeteler: bir kart tam, yanındaki kartın kenarı görünür.
class _Deck extends StatefulWidget {
  const _Deck({required this.deck});

  final List<_DeckEntry> deck;

  @override
  State<_Deck> createState() => _DeckState();
}

class _DeckState extends State<_Deck> {
  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deck = widget.deck;
    final page = _page.clamp(0, deck.length - 1);
    return Column(
      children: [
        Expanded(
          // Kartlar raf kenarına bantla asılı (Tuğrul, 2026-10-27): bant raf
          // kenarına taşar, bu yüzden sayfa kırpılmaz. Kart bantla birlikte
          // hafif eğik durur; eğim kartın sırasına göre sağa sola değişir.
          child: PageView.builder(
            controller: _controller,
            clipBehavior: Clip.none,
            itemCount: deck.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs + 2),
              child: Transform.rotate(
                angle: (i.isEven ? -0.8 : 0.7) * math.pi / 180,
                alignment: Alignment.topCenter,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      top: AppSpace.xs,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: AppSpace.lg),
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
        Padding(
          padding: EdgeInsets.only(bottom: AppSpace.md + MediaQuery.paddingOf(context).bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final (i, e) in deck.indexed)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _controller.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.sm),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: i == page ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == page ? e.status.color : e.status.color.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
