import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/shop_item.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'paper_tape.dart';

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
                'Daha iyi alet bu adımı kısaltır',
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
                    level: i + 1,
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
    required this.level,
    required this.levels,
  });

  final ShopItem tier;

  /// Yükseltme yolundaki yeri.
  final int level;
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
              _LevelPips(level: level, levels: levels, color: tier.color),
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

const _grayscale = ColorFilter.matrix([
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0,
]);

/// Kimyasal grubunun başlığı (Tuğrul, 2026-10-29, "ortala ve daha fark
/// edilir"): eski eczane rafındaki etiket gibi ortada, çift çizgi çerçeveli
/// beyaz kâğıt; üstünde bant. Altında grubun kaçı açık.
class ChemicalGroupHeader extends StatelessWidget {
  const ChemicalGroupHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.unlocked,
    required this.total,
  });

  final String title;
  final String subtitle;
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppSpace.md),
            constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
            padding: const EdgeInsets.all(AppSpace.xs),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.paper),
              boxShadow: const [BoxShadow(color: Color(0x33301C10), blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.lg, AppSpace.xl, AppSpace.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.paperInner),
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, textAlign: TextAlign.center, style: AppText.title(size: 22)),
                  const SizedBox(height: AppSpace.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 24, height: 1.5, color: AppColors.inkMuted),
                      const SizedBox(width: AppSpace.sm),
                      Flexible(
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: AppText.label(size: 13, color: AppColors.inkMuted),
                        ),
                      ),
                      const SizedBox(width: AppSpace.sm),
                      Container(width: 24, height: 1.5, color: AppColors.inkMuted),
                    ],
                  ),
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    unlocked == total ? '$total maddenin hepsi açık' : '$total maddeden $unlocked açık',
                    style: AppText.label(size: 12, color: AppColors.ink),
                  ),
                ],
              ),
            ),
          ),
          const PaperTape(width: 64, height: 20),
        ],
      ),
    );
  }
}

/// Liste satırı: kimyasal ya da reklam. Düğme sağda, başparmak tarafında.
class ShopItemTile extends StatelessWidget {
  const ShopItemTile({
    super.key,
    required this.item,
    this.highlight = false,
    this.locked = false,
    this.detail,
    this.onBuy,
  });

  final ShopItem item;

  /// Açıklamanın altındaki ek satır (kimyasalda raftaki paket sayısı).
  final String? detail;

  /// Henüz onu isteyen reçete gelmemiş kimyasal: soluk, kilitli, alınmaz.
  final bool locked;

  /// Satın alma; null ise düğme kapalı.
  final VoidCallback? onBuy;

  /// Reklam satırı gibi öne çıkan satır: yeşil kenar ve yeşil düğme.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.successSoft
            : locked
                ? AppColors.surfaceMuted
                : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(
          color: highlight ? AppColors.success : AppColors.line,
          width: highlight ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Kilitli maddenin ikonu renksiz ve soluk.
          locked
              ? Opacity(
                  opacity: 0.45,
                  child: ColorFiltered(colorFilter: _grayscale, child: _Thumb(item: item, size: 48)),
                )
              : _Thumb(item: item, size: 48),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppText.title(size: 17, color: locked ? AppColors.inkMuted : AppColors.ink)),
                const SizedBox(height: AppSpace.xs),
                Text(
                  locked ? 'Bu maddeyi isteyen ilk reçete gelince açılır.' : item.description,
                  style: AppText.body(size: 13, color: AppColors.inkMuted),
                ),
                if (detail != null && !locked) ...[
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
                : locked
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_rounded, color: AppColors.inkMuted, size: 22),
                          Text('Kilitli', style: AppText.label(size: 13, color: AppColors.inkMuted)),
                        ],
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
