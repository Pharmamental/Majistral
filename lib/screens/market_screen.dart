import 'package:flutter/material.dart';

import '../data/market_items.dart';
import '../data/stations.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/market_widgets.dart';

enum MarketTab { hizlandirma, istasyonlar, kimyasallar }

extension on MarketTab {
  String get label {
    switch (this) {
      case MarketTab.hizlandirma:
        return 'Hızlandırma';
      case MarketTab.istasyonlar:
        return 'İstasyonlar';
      case MarketTab.kimyasallar:
        return 'Kimyasallar';
    }
  }

  Color get color {
    switch (this) {
      case MarketTab.hizlandirma:
        return const Color(0xFF14555A); // Derin Deniz Mavisi/Teal
      case MarketTab.istasyonlar:
        return const Color(0xFF96682E); // Bronz/Ocra
      case MarketTab.kimyasallar:
        return const Color(0xFF355E3B); // Av Yeşili
    }
  }
}

Route<void> marketScreenRoute() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 550),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => const MarketScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.55, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  MarketTab _selectedTab = MarketTab.hizlandirma;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.sm),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: const Color(0xFF3A3A3A), width: 7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13.0),
              child: ColoredBox(
                color: AppColors.cream,
                child: Column(
                  children: [
                    const ScreenHeader(title: 'Market'),
                    const SizedBox(height: AppSpace.md),
                    Row(
                      children: [
                        for (final tab in MarketTab.values)
                          Expanded(
                            child: MarketTabButton(
                              label: tab.label,
                              color: tab.color,
                              selected: _selectedTab == tab,
                              onTap: () => setState(() => _selectedTab = tab),
                            ),
                          ),
                      ],
                    ),
                    Expanded(child: _buildTabContent()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    const padding = EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.md, AppSpace.xl, AppSpace.xl);
    switch (_selectedTab) {
      case MarketTab.hizlandirma:
        return ListView(
          padding: padding,
          children: const [ShopItemTile(item: adSpeedUp)],
        );
      case MarketTab.istasyonlar:
        return ListView.builder(
          padding: padding,
          itemCount: stations.length,
          itemBuilder: (context, index) => StationSection(station: stations[index]),
        );
      case MarketTab.kimyasallar:
        return ListView.builder(
          padding: padding,
          itemCount: chemicals.length,
          itemBuilder: (context, index) => ShopItemTile(item: chemicals[index]),
        );
    }
  }
}
