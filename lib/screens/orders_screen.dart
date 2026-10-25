import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/prescription_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Reçeteler'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.xl),
                itemCount: prescriptionOrders.length,
                itemBuilder: (context, index) => PrescriptionCard(order: prescriptionOrders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
