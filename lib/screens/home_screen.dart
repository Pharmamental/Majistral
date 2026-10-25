import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/home_circle_button.dart';
import 'lab_screen.dart';
import 'market_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpace.xxl,
            runSpacing: AppSpace.xl,
            children: [
              HomeCircleButton(
                color: Colors.purple,
                icon: Icons.receipt_long_outlined,
                label: 'Reçeteler',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (context) => const OrdersScreen()),
                ),
              ),
              HomeCircleButton(
                color: Colors.teal,
                icon: Icons.science_outlined,
                label: 'Laboratuvar',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (context) => const LabScreen()),
                ),
              ),
              HomeCircleButton(
                color: AppColors.kiremit,
                icon: Icons.storefront_outlined,
                label: 'Market',
                onTap: () => Navigator.of(context).push(marketScreenRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
