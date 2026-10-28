import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../widgets/game_tab_bar.dart';
import 'garden_screen.dart';
import 'lab_screen.dart';
import 'market_screen.dart';
import 'more_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

/// Uygulamanın kabuğu: ana bölümler alt gezinme çubuğunda, başparmak bölgesinde:
/// Reçeteler, Laboratuvar, Market, Bahçe, Profil, Diğer ([GameTabBar]). Bahçe
/// 2026-10-29'da altıncı sekme olarak eklendi (Tasarım Rehberi 3–5 öneriyor).
/// Hazır ya da oyuncuyu bekleyen iş varsa Reçeteler simgesinde rozet görünür.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// Laboratuvar sekmesinin sırası.
  static const lab = 1;

  /// Alt çubuktaki [index]. sekmeye geçer (kartın "Laboratuvara git" düğmesi).
  static void showTab(BuildContext context, int index) =>
      context.findAncestorStateOfType<_HomeScreenState>()?._select(index);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    // Teslim edilecek ya da sıradaki adımı oyuncuyu bekleyen işler.
    final ready = store.jobs.where((j) => store.isReady(j) || store.needsAction(j)).length;

    return Scaffold(
      // İçerik alt çubuğun arkasına uzanır; ortadaki daireyi saran boşlukta
      // tezgâh görünsün. Listeler alt boşluğu MediaQuery'den alır.
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            // Görünmeyen sekmenin animasyonları (termometre) dursun.
            for (final (i, tab) in const [
              OrdersScreen(),
              LabScreen(),
              MarketScreen(),
              GardenScreen(),
              ProfileScreen(),
              MoreScreen(),
            ].indexed)
              TickerMode(enabled: i == _index, child: tab),
          ],
        ),
      ),
      bottomNavigationBar: GameTabBar(
        index: _index,
        onSelect: _select,
        big: HomeScreen.lab,
        badges: {0: ready},
        tabs: const [
          (label: 'Reçeteler', image: 'assets/images/ikon/ikon_sekme_receteler.png'),
          (label: 'Laboratuvar', image: 'assets/images/ikon/ikon_havan_porselen.png'),
          (label: 'Market', image: 'assets/images/ikon/ikon_sekme_market.png'),
          (label: 'Bahçe', image: 'assets/images/ikon/ikon_sekme_bahce.png'),
          (label: 'Profil', image: 'assets/images/ikon/ikon_sekme_profil.png'),
          (label: 'Diğer', image: 'assets/images/ikon/ikon_sekme_diger.png'),
        ],
      ),
    );
  }
}
