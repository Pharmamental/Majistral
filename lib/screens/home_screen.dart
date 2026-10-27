import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../widgets/game_tab_bar.dart';
import 'lab_screen.dart';
import 'market_screen.dart';
import 'orders_screen.dart';

/// Uygulamanın kabuğu: üç ana bölüm alt gezinme çubuğunda (Tasarım Rehberi,
/// Navigasyon: 3–5 üst düzey hedef için alt çubuk; başparmak bölgesinde),
/// ortada laboratuvar ([GameTabBar]).
/// Hazır ya da oyuncuyu bekleyen iş varsa Reçeteler simgesinde rozet görünür.
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
      bottomNavigationBar: GameTabBar(
        index: _index,
        onSelect: (i) => setState(() => _index = i),
        badges: {0: ready},
        tabs: const [
          (label: 'Reçeteler', image: 'assets/images/ikon/ikon_sekme_receteler.png'),
          (label: 'Laboratuvar', image: 'assets/images/ikon/ikon_havan_porselen.png'),
          (label: 'Market', image: 'assets/images/ikon/ikon_sekme_market.png'),
        ],
      ),
    );
  }
}
