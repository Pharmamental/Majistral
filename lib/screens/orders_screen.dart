import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/prescription_card.dart';

/// Reçeteler sekmesi (ana döngünün başladığı yer). Aksiyon bekleyen kart
/// üstte: önce hazır olanlar, sonra yeni reçeteler, en son süren işler.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    int rank(PrescriptionOrder o) {
      final job = store.jobFor(o.magistralName);
      if (job == null) return 1;
      return store.isReady(job) ? 0 : 2;
    }

    final orders = [...prescriptionOrders]..sort((a, b) => rank(a).compareTo(rank(b)));
    final running = store.jobs.where((j) => !store.isReady(j)).length;
    final ready = store.jobs.length - running;
    final parts = [
      '${prescriptionOrders.length} reçete',
      if (ready > 0) '$ready hazır',
      if (running > 0) '$running hazırlanıyor',
    ];

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpace.x3),
      itemCount: orders.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpace.lg),
      itemBuilder: (context, index) {
        if (index == 0) return TabHeader(title: 'Reçeteler', subtitle: parts.join(' · '));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: PrescriptionCard(order: orders[index - 1]),
        );
      },
    );
  }
}
