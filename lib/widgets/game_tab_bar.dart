import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Alt çubuktaki bir bölüm: adı ve oyuncak blok ikonu.
typedef GameTab = ({String label, String image});

/// Alt çubuk (Tuğrul, 2026-10-27, "ortada laboratuvar"): oyunun kalbi
/// laboratuvar ortada, çubuktan taşan büyük bir daire; yanlarda Reçeteler ve
/// Market daha küçük dairelerde. İkon kutuları daire (köşe dili: eşya ikonu).
/// Seçili sekme kobalt çerçeve ve açık kobalt dolguyla, adı da kobalt yazıyla
/// belli olur; seçilmeyen ikonlar soluk durur. Taşan daire çubuğun kendi
/// alanında kalır, böylece dokunulabilir.
class GameTabBar extends StatelessWidget {
  const GameTabBar({
    super.key,
    required this.tabs,
    required this.index,
    required this.onSelect,
    this.badges = const {},
  });

  /// Üç bölüm; ortadaki büyük çizilir.
  final List<GameTab> tabs;
  final int index;
  final ValueChanged<int> onSelect;

  /// Sekme sırası → rozet sayısı (0 ise gösterilmez).
  final Map<int, int> badges;

  static const double _barHeight = 76;
  static const double _lift = 30;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: _lift + _barHeight + bottom,
      child: Stack(
        children: [
          Positioned.fill(
            top: _lift,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.line)),
                boxShadow: [BoxShadow(color: Color(0x0F172033), blurRadius: 16, offset: Offset(0, -6))],
              ),
            ),
          ),
          Positioned.fill(
            bottom: bottom,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, tab) in tabs.indexed)
                  Expanded(
                    flex: i == 1 ? 11 : 10,
                    child: _TabButton(
                      tab: tab,
                      big: i == 1,
                      selected: i == index,
                      badge: badges[i] ?? 0,
                      onTap: () => onSelect(i),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.big,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  final GameTab tab;
  final bool big;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = big ? 68.0 : 48.0;
    final circle = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.kobaltSoft : (big ? AppColors.surface : Colors.transparent),
        border: big || selected
            ? Border.all(color: selected ? AppColors.kobalt : AppColors.line, width: big ? 3 : 2)
            : null,
        boxShadow: big
            ? [BoxShadow(color: selected ? AppColors.kobaltDark : AppColors.line, offset: const Offset(0, 4))]
            : null,
      ),
      child: Opacity(
        opacity: selected ? 1 : 0.6,
        child: Image.asset(tab.image, width: size * 0.78, height: size * 0.78),
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  circle,
                  if (badge > 0)
                    Positioned(
                      top: -2,
                      right: -6,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 20),
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bekliyor,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                        child: Text('$badge', style: AppText.label(size: 11, color: AppColors.ink)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpace.xs),
              Text(
                tab.label,
                maxLines: 1,
                style: AppText.label(size: 12, color: selected ? AppColors.accentText : AppColors.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
