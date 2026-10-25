import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';

// Ekonomi henüz yok: satın alma ve reklam düğmeleri kapalı testten önce
// bağlanacak, şimdilik bilerek bir şey yapmıyor.

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
          child: Text(station.name, style: AppText.title(size: 20)),
        ),
        const SizedBox(height: AppSpace.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < station.tiers.length; i++) ...[
                StationTierCard(tier: station.tiers[i], level: i + 1),
                if (i != station.tiers.length - 1) const SizedBox(width: AppSpace.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class StationTierCard extends StatelessWidget {
  const StationTierCard({super.key, required this.tier, required this.level});

  final ShopItem tier;
  final int level;

  @override
  Widget build(BuildContext context) {
    final owned = tier.price == 0;
    return Container(
      width: 184,
      height: 244,
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: owned ? tier.color : AppColors.line, width: owned ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Thumb(item: tier, size: 56),
              const Spacer(),
              _LevelPips(level: level, color: tier.color),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(tier.name, style: AppText.title(size: 18)),
          const SizedBox(height: AppSpace.xs),
          Expanded(
            child: Text(
              tier.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(size: 13, color: AppColors.inkMuted),
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          SizedBox(
            width: double.infinity,
            child: owned
                ? Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded, size: 18, color: AppColors.inkMuted),
                        const SizedBox(width: AppSpace.xs),
                        Text('Elinde', style: AppText.label()),
                      ],
                    ),
                  )
                : ChunkyButton(compact: true, label: '${tier.price}', icon: Icons.toll_rounded, onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

/// Kademe göstergesi: dolu nokta sayısı = kademe.
class _LevelPips extends StatelessWidget {
  const _LevelPips({required this.level, required this.color});

  final int level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Kademe $level',
      child: Row(
        children: [
          for (var i = 1; i <= 3; i++)
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

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: item.imagePath != null
            ? Image.asset(item.imagePath!, fit: BoxFit.cover)
            : ColoredBox(
                color: item.color.withValues(alpha: 0.14),
                child: Icon(item.icon, color: item.color, size: size * 0.5),
              ),
      ),
    );
  }
}

/// Liste satırı: kimyasal ya da reklam. Düğme sağda, başparmak tarafında.
class ShopItemTile extends StatelessWidget {
  const ShopItemTile({super.key, required this.item, this.highlight = false});

  final ShopItem item;

  /// Reklam satırı gibi öne çıkan satır: yeşil kenar ve yeşil düğme.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: highlight ? AppColors.successSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: highlight ? AppColors.success : AppColors.line, width: highlight ? 2 : 1),
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
                Text(item.description, style: AppText.body(size: 13, color: AppColors.inkMuted)),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.md),
          SizedBox(
            width: 104,
            child: highlight
                ? ChunkyButton.success(compact: true, label: item.buttonLabel, onPressed: () {})
                : ChunkyButton(
                    compact: true,
                    label: '${item.price}',
                    icon: Icons.toll_rounded,
                    onPressed: () {},
                  ),
          ),
        ],
      ),
    );
  }
}

/// Sekme seçici: tam yuvarlak hap biçiminde, seçili olan kiremit dolgu.
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          for (final value in values)
            Expanded(
              child: Semantics(
                button: true,
                selected: value == selected,
                child: GestureDetector(
                  onTap: () => onChanged(value),
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: value == selected ? AppColors.kiremit : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      labelOf(value),
                      style: AppText.label(
                        size: 14,
                        color: value == selected ? Colors.white : AppColors.inkMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
