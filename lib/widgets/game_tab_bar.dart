
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Alt çubuktaki bir bölüm: adı ve oyuncak blok ikonu.
typedef GameTab = ({String label, String image});

/// Alt çubuk: oyunun kalbi laboratuvar çubuktan taşan büyük porselen daire
/// ([big]). Sıra soldan sağa Reçeteler, Laboratuvar, Market, Profil, Diğer
/// (Tuğrul, 2026-10-28). Seçili sekme adının kobalt yazısı ve altındaki kısa kobalt
/// çizgiyle belli olur; çizgi sekmeden sekmeye kayar ([_SlidingMark]), daire
/// seçimle değişmez; seçilmeyen ikonlar soluk durur. Taşan daire çubuğun kendi
/// alanında kalır, böylece dokunulabilir.
class GameTabBar extends StatelessWidget {
  const GameTabBar({
    super.key,
    required this.tabs,
    required this.index,
    required this.onSelect,
    required this.big,
    this.badges = const {},
  });

  final List<GameTab> tabs;

  /// Büyük daireyle çizilen bölümün sırası.
  final int big;
  final int index;
  final ValueChanged<int> onSelect;

  /// Sekme sırası → rozet sayısı (0 ise gösterilmez).
  final Map<int, int> badges;

  static const double _barHeight = 76;
  static const double _lift = 30;

  /// Büyük bölüm biraz geniş.
  int _flex(int i) => i == big ? 11 : 10;

  /// Her bölümün ortası, çubuk genişliğinin oranı olarak (0–1).
  List<double> _centers() {
    final flexes = [for (var i = 0; i < tabs.length; i++) _flex(i)];
    final total = flexes.reduce((a, b) => a + b);
    final centers = <double>[];
    var start = 0;
    for (final f in flexes) {
      centers.add((start + f / 2) / total);
      start += f;
    }
    return centers;
  }

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
                    flex: _flex(i),
                    child: _TabButton(
                      tab: tab,
                      big: i == big,
                      selected: i == index,
                      badge: badges[i] ?? 0,
                      onTap: () => onSelect(i),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottom + AppSpace.xs,
            child: _SlidingMark(centers: _centers(), index: index),
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
      decoration: big
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.fromBorderSide(BorderSide(color: AppColors.line, width: 3)),
              boxShadow: [BoxShadow(color: AppColors.line, offset: Offset(0, 4))],
            )
          : null,
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
          padding: const EdgeInsets.only(bottom: AppSpace.xs),
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
              // Altı sekmede (Bahçe, 2026-10-29) dar telefonda "Laboratuvar" sığmıyor:
              // ad kesilmez, yalnız sığmadığında küçülür.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    style: AppText.label(size: 12, color: selected ? AppColors.accentText : AppColors.inkMuted),
                  ),
                ),
              ),
              // Kayan seçim çizgisinin yeri ([_SlidingMark] çubuğun üstünde çizer).
              const SizedBox(height: 3 + 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Seçili sekmenin altındaki kobalt çizgi. Sekme değişince eski yerinden yenisine
/// kayar ve yolun ortasında biraz uzayıp yerine oturunca kısalır (Tuğrul,
/// 2026-10-27). "Hareketi azalt" açıksa atlamadan yerine geçer.
class _SlidingMark extends StatefulWidget {
  const _SlidingMark({required this.centers, required this.index});

  /// Bölüm ortaları, çubuk genişliğinin oranı olarak.
  final List<double> centers;
  final int index;

  @override
  State<_SlidingMark> createState() => _SlidingMarkState();
}

class _SlidingMarkState extends State<_SlidingMark> with SingleTickerProviderStateMixin {
  static const double _width = 20;
  static const double _stretch = 22;

  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 340), value: 1);
  late double _from = widget.centers[widget.index];

  @override
  void didUpdateWidget(_SlidingMark old) {
    super.didUpdateWidget(old);
    if (old.index == widget.index) return;
    // Çizginin şu anki yeri; kayarken yeni dokunuş gelirse oradan devam eder.
    final t = Curves.easeOutCubic.transform(_controller.value);
    _from += (old.centers[old.index] - _from) * t;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final v = _controller.value;
          final t = Curves.easeOutCubic.transform(v);
          final center = _from + (widget.centers[widget.index] - _from) * t;
          final width = _width + _stretch * math.sin(math.pi * v);
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: constraints.maxWidth * center - width / 2),
              child: Container(
                width: width,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.kobalt,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
