import 'package:flutter/material.dart';

import '../data/economy.dart';
import '../data/market_items.dart';
import '../data/stations.dart';
import '../logic/job_store.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/coin_pill.dart';
import '../widgets/counter_top.dart';
import '../widgets/market_widgets.dart';

enum MarketTab { hizlandirma, istasyonlar, kimyasallar }

String _label(MarketTab tab) => switch (tab) {
      MarketTab.hizlandirma => 'Hızlandırma',
      MarketTab.istasyonlar => 'İstasyonlar',
      MarketTab.kimyasallar => 'Kimyasallar',
    };

/// Market sekmesi. Hızlandırma yalnız ödüllü reklamla (tasarım belgesi, bölüm 10).
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  MarketTab _tab = MarketTab.istasyonlar;

  @override
  Widget build(BuildContext context) {
    // Başlık ve sekmeler duvarda, ürünler tentenin altında kum tezgâhta (Tuğrul, 2026-10-27).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: Column(
            children: [
              const TabHeader(title: 'Market', subtitle: 'Alet ve kimyasal al', trailing: CoinPill()),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                child: PillTabs<MarketTab>(
                  values: MarketTab.values,
                  selected: _tab,
                  labelOf: _label,
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: MarketStall(child: _content())),
      ],
    );
  }

  Widget _content() {
    final store = JobScope.of(context);
    final bottom = AppSpace.x3 + MediaQuery.paddingOf(context).bottom;
    final listPadding = EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, bottom);
    switch (_tab) {
      case MarketTab.hizlandirma:
        return ListView(
          padding: listPadding,
          children: [
            const ShopItemTile(item: adSpeedUp, highlight: true),
            const SizedBox(height: AppSpace.md),
            Text(
              'Günde en çok 5 kez. Hızlandırma yalnız bekleme süresini kısaltır, '
              'hazırlama adımlarını atlatmaz. Her acele kaliteyi de yarıya indirir.',
              style: AppText.body(size: 13),
            ),
          ],
        );
      case MarketTab.istasyonlar:
        return ListView.separated(
          padding: EdgeInsets.only(top: AppSpace.lg, bottom: bottom),
          itemCount: stations.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpace.lg),
          itemBuilder: (context, index) => StationSection(station: stations[index]),
        );
      case MarketTab.kimyasallar:
        return ListView(
          padding: listPadding,
          children: [
            for (final group in chemicalGroups) ...[
              ChemicalGroupHeader(
                title: group.title,
                subtitle: group.subtitle,
                unlocked: group.items.where((i) => store.chemicalUnlocked(i.name)).length,
                total: group.items.length,
              ),
              const SizedBox(height: AppSpace.lg),
              // Açık maddeler önce, kilitliler grubun sonunda.
              for (final item in [
                ...group.items.where((i) => store.chemicalUnlocked(i.name)),
                ...group.items.where((i) => !store.chemicalUnlocked(i.name)),
              ]) ...[
                ShopItemTile(
                  item: item,
                  locked: !store.chemicalUnlocked(item.name),
                  detail: packs[item.name] == null
                      ? 'Eczanenin cihazından, bedava'
                      : 'Paketi ${item.price} para · Sahip olunan: ${store.packsOf(item.name)} adet',
                ),
                const SizedBox(height: AppSpace.md),
              ],
              const SizedBox(height: AppSpace.xl),
            ],
          ],
        );
    }
  }
}
