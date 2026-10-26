import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import 'lab_screen.dart';
import 'market_screen.dart';
import 'orders_screen.dart';

/// Uygulamanın kabuğu: üç ana bölüm alt gezinme çubuğunda (Tasarım Rehberi,
/// Navigasyon: 3–5 üst düzey hedef için alt çubuk; başparmak bölgesinde).
/// Hazır iş varsa Reçeteler simgesinde rozet görünür.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    // Teslim edilecek ya da oyuncuyu bekleyen (ısıtma) işler.
    final ready = store.jobs.where((j) => store.isReady(j) || store.needsAction(j)).length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            // Görünmeyen sekmenin animasyonları (termometre) dursun.
            for (final (i, tab) in const [OrdersScreen(), LabScreen(), MarketScreen()].indexed)
              TickerMode(enabled: i == _index, child: tab),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: Badge(
              isLabelVisible: ready > 0,
              label: Text('$ready'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: ready > 0,
              label: Text('$ready'),
              child: const Icon(Icons.receipt_long_rounded),
            ),
            label: 'Reçeteler',
          ),
          const NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science_rounded),
            label: 'Laboratuvar',
          ),
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Market',
          ),
        ],
      ),
    );
  }
}
