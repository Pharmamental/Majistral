import 'package:flutter/material.dart';

import '../data/market_items.dart';
import '../data/stations.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
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
    return Column(
      children: [
        const TabHeader(title: 'Market', subtitle: 'İstasyonunu yükselt, kimyasal al'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: PillTabs<MarketTab>(
            values: MarketTab.values,
            selected: _tab,
            labelOf: _label,
            onChanged: (t) => setState(() => _tab = t),
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        Expanded(child: _content()),
      ],
    );
  }

  Widget _content() {
    const listPadding = EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.x3);
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
              style: AppText.body(size: 13, color: AppColors.inkMuted),
            ),
          ],
        );
      case MarketTab.istasyonlar:
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: AppSpace.x3),
          itemCount: stations.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpace.xxl),
          itemBuilder: (context, index) => StationSection(station: stations[index]),
        );
      case MarketTab.kimyasallar:
        return ListView(
          padding: listPadding,
          children: [
            for (final group in chemicalGroups) ...[
              Text(group.title, style: AppText.title(size: 20)),
              Text(group.subtitle, style: AppText.label(size: 12)),
              const SizedBox(height: AppSpace.md),
              for (final item in group.items) ...[
                ShopItemTile(item: item),
                const SizedBox(height: AppSpace.md),
              ],
              const SizedBox(height: AppSpace.lg),
            ],
          ],
        );
    }
  }
}
