import 'package:flutter/material.dart';

import '../data/dried_plants.dart';
import '../data/economy.dart';
import '../data/market_items.dart';
import '../data/stations.dart';
import '../logic/job_store.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/coin_pill.dart';
import '../widgets/counter_top.dart';
import '../widgets/market_widgets.dart';

enum MarketTab { hizlandirma, istasyonlar, kimyasallar, cicekler }

String _label(MarketTab tab) => switch (tab) {
      MarketTab.hizlandirma => 'Hızlandırma',
      MarketTab.istasyonlar => 'İstasyonlar',
      MarketTab.kimyasallar => 'Kimyasallar',
      MarketTab.cicekler => 'Çiçekler',
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
              TabHeader(
                title: 'Market',
                subtitle: 'Alet ve kimyasal al, çiçek sat',
                sign: TabSign.market,
                trailing: CoinPill(onGlass: TabSign.market.leaf),
              ),
              const SizedBox(height: AppSpace.lg),
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
              'Günde 5 kez kullanabilirsin. Reklam yalnız bekleme süresini kısaltır, '
              'adımları senin yerine yapmaz. Her acele kaliteyi de yarıya indirir.',
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
                      ? 'Eczanenin cihazı üretir, bedava.'
                      : 'Paketi ${item.price} para. Sahip olunan: ${store.packsOf(item.name)} adet',
                ),
                const SizedBox(height: AppSpace.md),
              ],
              const SizedBox(height: AppSpace.xl),
            ],
          ],
        );
      // Oyuncu bahçeden topladığı çiçeği burada tek tek satar (Tuğrul, 2026-10-29).
      case MarketTab.cicekler:
        final plants = [...driedPlants]..sort((a, b) => a.tier.compareTo(b.tier));
        return ListView(
          padding: listPadding,
          children: [
            Text(
              'Bahçeden topladığın çiçekleri burada satabilirsin. Vitrine fanus koymak için '
              'aynı bitkiden çiçek biriktirmen gerektiğini unutma.',
              style: AppText.body(size: 13, color: AppColors.ink),
            ),
            const SizedBox(height: AppSpace.lg),
            for (final p in plants) ...[
              _FlowerTile(plant: p),
              const SizedBox(height: AppSpace.md),
            ],
          ],
        );
    }
  }
}

/// Markette bir kurutulmuş çiçek: fanus ikonu, adı, fanusunun etkisi, kaç tane
/// olduğu ve "Sat" (bir tane). Fiyat yazmaz (Tuğrul, 2026-10-29).
class _FlowerTile extends StatelessWidget {
  const _FlowerTile({required this.plant});

  final DriedPlant plant;

  static const _rarity = {1: 'Sıradan', 2: 'Sıradışı', 3: 'Nadir'};

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final have = store.garden.flowers[plant.name] ?? 0;
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.alphaBlend(Color(plant.color).withValues(alpha: 0.16), AppColors.surface),
              shape: BoxShape.circle,
            ),
            child: Image.asset(plant.imagePath, width: 42, height: 42),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.name, style: AppText.title(size: 17)),
                Text('${_rarity[plant.tier]} çiçek', style: AppText.label(size: 12)),
                const SizedBox(height: AppSpace.xs),
                Text('${plant.effectText}.', style: AppText.body(size: 13, color: AppColors.inkMuted)),
                const SizedBox(height: AppSpace.xs),
                Text(
                  have == 0 ? 'Elinde hiç yok' : 'Elinde $have tane var',
                  style: AppText.label(size: 12, color: AppColors.ink),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.md),
          SizedBox(
            width: 104,
            child: ChunkyButton(
              compact: true,
              label: 'Sat',
              onPressed: have > 0 ? () => store.sellFlower(plant.name) : null,
            ),
          ),
        ],
      ),
    );
  }
}
