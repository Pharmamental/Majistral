import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../logic/job_store.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/prescription_card.dart';

/// Reçeteler sekmesi (ana döngünün başladığı yer). Reçeteler durumlarına göre
/// gruplanır; oyuncunun bir şey yapması gerekenler üstte: seni bekleyen, hazır,
/// hazırlanan, yeni. Her grubun rengi kartın şeridiyle aynı.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final groups = {
      for (final status in OrderStatus.values)
        status: [for (final o in prescriptionOrders) if (OrderStatus.of(store, o) == status) o],
    };
    final waiting = groups[OrderStatus.bekliyor]!.length;
    final ready = groups[OrderStatus.hazir]!.length;
    final running = groups[OrderStatus.suruyor]!.length;
    final parts = [
      '${prescriptionOrders.length} reçete',
      if (ready > 0) '$ready hazır',
      if (waiting > 0) '$waiting seni bekliyor',
      if (running > 0) '$running hazırlanıyor',
    ];

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpace.x3),
      children: [
        TabHeader(title: 'Reçeteler', subtitle: parts.join(' · ')),
        for (final MapEntry(key: status, value: orders) in groups.entries)
          if (orders.isNotEmpty) ...[
            _GroupHeader(status: status, count: orders.length),
            for (final o in orders)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                child: PrescriptionCard(order: o),
              ),
          ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.status, required this.count});

  final OrderStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.sm, AppSpace.xl, AppSpace.md),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpace.sm),
          Text(status.label, style: AppText.title(size: 17)),
          const SizedBox(width: AppSpace.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
            decoration: BoxDecoration(color: status.soft, borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text('$count', style: AppText.label(size: 12, color: status.text)),
          ),
        ],
      ),
    );
  }
}
