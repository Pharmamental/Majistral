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
/// Rozet işin yapılacağı yerde: teslime hazır iş Reçeteler'de, adımı oyuncuyu
/// bekleyen iş Laboratuvar'da.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// Reçeteler sekmesinin sırası.
  static const orders = 0;

  /// Laboratuvar sekmesinin sırası.
  static const lab = 1;

  /// Profil sekmesinin sırası (bahçede hasattan sonra "Vitrine git").
  static const profile = 4;

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
    final ready = store.jobs.where(store.isReady).length;
    final waiting = store.jobs.where(store.needsAction).length;

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
        badges: {HomeScreen.orders: ready, HomeScreen.lab: waiting},
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
