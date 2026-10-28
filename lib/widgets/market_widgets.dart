import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/shop_item.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';

// Satın alma (2026-10-29): aletler ve kimyasal paketleri kasadaki parayla
// alınır (data/economy.dart). Reklam düğmesi henüz bağlı değil.

/// İstasyon adı + yatay kaydırılan kademe kartları (paslı → iyi → gelişmiş).
class StationSection extends StatelessWidget {
  const StationSection({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(station.name, style: AppText.title(size: 20)),
              Text(
                station.upgradePath
                    ? 'Basitten gelişmişe'
                    : 'Her işin ayrı aleti',
                style: AppText.label(size: 12, color: AppColors.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          // Kartlar en uzun açıklamaya göre eşit boyda; düğmeler aynı hizada.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < station.tiers.length; i++) ...[
                  StationTierCard(
                    tier: station.tiers[i],
                    level: station.upgradePath ? i + 1 : null,
                    levels: station.tiers.length,
                  ),
                  if (i != station.tiers.length - 1)
                    const SizedBox(width: AppSpace.md),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StationTierCard extends StatelessWidget {
  const StationTierCard({
    super.key,
    required this.tier,
    this.level,
    this.levels = 3,
  });

  final ShopItem tier;

  /// Yükseltme yolundaki yeri; farklı işlerin aletlerinde (havanlar) yok.
  final int? level;
  final int levels;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final owned = store.ownsTool(tier);
    return Container(
      width: 184,
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(
          color: owned ? tier.color : AppColors.line,
          width: owned ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Thumb(item: tier, size: 56),
              const Spacer(),
              if (level != null)
                _LevelPips(level: level!, levels: levels, color: tier.color),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(tier.name, style: AppText.title(size: 18)),
          const SizedBox(height: AppSpace.xs),
          Text(
            tier.description,
            style: AppText.body(size: 13, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.md),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: owned
                ? Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.inkMuted,
                        ),
                        const SizedBox(width: AppSpace.xs),
                        Text('Elinde', style: AppText.label()),
                      ],
                    ),
                  )
                : ChunkyButton(
                    compact: true,
                    label: '${tier.price}',
                    icon: Icons.toll_rounded,
                    // Para yetmiyorsa düğme kapalı (2026-10-29).
                    onPressed: store.coins >= tier.price ? () => store.buyTool(tier) : null,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Kademe göstergesi: dolu nokta sayısı = kademe.
class _LevelPips extends StatelessWidget {
  const _LevelPips({
    required this.level,
    required this.levels,
    required this.color,
  });

  final int level;
  final int levels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Kademe $level',
      child: Row(
        children: [
          for (var i = 1; i <= levels; i++)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: AppSpace.xs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i <= level ? color : AppColors.line,
              ),
            ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.item, required this.size});

  final ShopItem item;
  final double size;

  // Oyuncak blok ikonu açık bir kutunun üstünde durur (Pharmamental'daki gibi);
  // ikonun kendi gölgesi ve yan yüzü var, kırpılmaz.
  @override
  Widget build(BuildContext context) {
    final box = Color.alphaBlend(item.color.withValues(alpha: 0.16), AppColors.surface);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: box, shape: BoxShape.circle),
      child: item.imagePath != null
          ? Image.asset(item.imagePath!, width: size * 0.86, height: size * 0.86)
          : Icon(item.icon, color: item.color, size: size * 0.5),
    );
  }
}

/// Liste satırı: kimyasal ya da reklam. Düğme sağda, başparmak tarafında.
class ShopItemTile extends StatelessWidget {
  const ShopItemTile({super.key, required this.item, this.highlight = false, this.detail, this.onBuy});

  final ShopItem item;

  /// Açıklamanın altındaki ek satır (kimyasalda paket ve raftaki miktar).
  final String? detail;

  /// Satın alma; null ise düğme kapalı.
  final VoidCallback? onBuy;

  /// Reklam satırı gibi öne çıkan satır: yeşil kenar ve yeşil düğme.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: highlight ? AppColors.successSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(
          color: highlight ? AppColors.success : AppColors.line,
          width: highlight ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          _Thumb(item: item, size: 48),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppText.title(size: 17)),
                const SizedBox(height: AppSpace.xs),
                Text(
                  item.description,
                  style: AppText.body(size: 13, color: AppColors.inkMuted),
                ),
                if (detail != null) ...[
                  const SizedBox(height: AppSpace.xs),
                  Text(detail!, style: AppText.label(size: 12, color: AppColors.ink)),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpace.md),
          SizedBox(
            width: 104,
            child: highlight
                ? ChunkyButton.success(
                    compact: true,
                    label: item.buttonLabel,
                    onPressed: () {},
                  )
                : item.price == 0
                    ? Text('Bedava', textAlign: TextAlign.center, style: AppText.label(size: 14, color: AppColors.ink))
                    : ChunkyButton(
                        compact: true,
                        label: '${item.price}',
                        icon: Icons.toll_rounded,
                        onPressed: onBuy,
                      ),
          ),
        ],
      ),
    );
  }
}

/// Sekme seçici: tam yuvarlak hap biçiminde, seçili olan kobalt dolgu. Kobalt
/// hap seçime hızlı ve doğrusal kayar (Tuğrul, 2026-10-27); bundan sonraki
/// seçici düğmeler de bunu kullanır.
class PillTabs<T> extends StatelessWidget {
  const PillTabs({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  static const _slide = Duration(milliseconds: 180);

  @override
  Widget build(BuildContext context) {
    // Hareketi azalt açıksa hap atlar.
    final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : _slide;
    final index = values.indexOf(selected);
    return Container(
      padding: const EdgeInsets.all(AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.line),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              duration: duration,
              curve: Curves.linear,
              alignment: Alignment(values.length == 1 ? 0 : -1 + 2 * index / (values.length - 1), 0),
              child: FractionallySizedBox(
                widthFactor: 1 / values.length,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.kobaltDark,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final value in values)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: value == selected,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(value),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: duration,
                          curve: Curves.linear,
                          style: AppText.label(
                            size: 14,
                            color: value == selected
                                ? Colors.white
                                : AppColors.inkMuted,
                          ),
                          child: Text(labelOf(value)),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
