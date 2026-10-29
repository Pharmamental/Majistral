import 'package:flutter/material.dart';

import '../logic/profile_stats.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import 'mastery_medal.dart';

/// Başarım kutucuğu (Tuğrul, 2026-10-28, "açılan kapsül"): ekranın üstüne koyu
/// kırmızı-beyaz bir kapsül iner, iki yarısı ayrılır, aradan madalya ve yazı
/// çıkar; birkaç saniye sonra kapanıp çekilir. Birden çok başarım sırayla gelir.
/// Ekranın en üst katmanında durur, dokunmayı engellemez.
Future<void> showAchievements(BuildContext context, List<({String step, int tier, int count})> ups) async {
  if (ups.isEmpty) return;
  // Teslim gezginin kendi bağlamından çağrılır; onun üstünde Overlay yok, kendi katmanını kullan.
  final overlay = Overlay.maybeOf(context, rootOverlay: true) ?? Navigator.of(context, rootNavigator: true).overlay;
  if (overlay == null) return;
  for (final up in ups) {
    if (!overlay.mounted) return;
    final entry = OverlayEntry(builder: (_) => AchievementToast(step: up.step, tier: up.tier, count: up.count));
    overlay.insert(entry);
    await Future<void>.delayed(AchievementToast.duration + const Duration(milliseconds: 150));
    entry.remove();
  }
}

class AchievementToast extends StatefulWidget {
  const AchievementToast({super.key, required this.step, required this.tier, required this.count});

  static const duration = Duration(milliseconds: 3600);

  final String step;
  final int tier;
  final int count;

  @override
  State<AchievementToast> createState() => _AchievementToastState();
}

class _AchievementToastState extends State<AchievementToast> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: AchievementToast.duration)..forward();

  // Zaman çizelgesi (0–1): iner 0–.08, açılır .14–.30, açık kalır, kapanır .80–.90, çekilir .86–1.
  late final _drop = CurvedAnimation(parent: _c, curve: const Interval(0, .08, curve: Curves.easeOut));
  late final _open = CurvedAnimation(parent: _c, curve: const Interval(.14, .30, curve: Curves.easeOutBack));
  late final _close = CurvedAnimation(parent: _c, curve: const Interval(.80, .90, curve: Curves.easeIn));
  late final _leave = CurvedAnimation(parent: _c, curve: const Interval(.88, 1, curve: Curves.easeIn));

  static const _half = Size(48, 54);
  static const _middle = 188.0;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    final tierName = tiers[widget.tier].title;
    final toast = AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final open = reduce ? (_c.value < .9 ? 1.0 : 0.0) : (_open.value - _close.value).clamp(0.0, 1.2);
        final shown = reduce ? (_c.value < .9 ? 1.0 : 0.0) : (_drop.value - _leave.value);
        return Opacity(
          opacity: shown.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -24 * (1 - shown)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CapsuleHalf(left: true),
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: open.clamp(0.0, 1.0) * 1.0,
                    child: child,
                  ),
                ),
                _CapsuleHalf(left: false),
              ],
            ),
          ),
        );
      },
      child: Container(
        width: _middle,
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border.symmetric(horizontal: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            MasteryMedal(tier: widget.tier, image: stepIconPath(widget.step), size: 40, notches: false),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.step} için $tierName madalya', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.title(size: 15)),
                  Text('${widget.count} kez hazırladın', maxLines: 1, style: AppText.label(size: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpace.sm),
            child: Semantics(
              liveRegion: true,
              label: 'Başarım: ${widget.step}, $tierName. ${widget.count} kez hazırladın.',
              child: ExcludeSemantics(child: Material(type: MaterialType.transparency, child: toast)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kapsülün bir yarısı: solda koyu kırmızı, sağda beyaz; altında koyu kenar.
class _CapsuleHalf extends StatelessWidget {
  const _CapsuleHalf({required this.left});

  final bool left;

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(27);
    return Container(
      width: _AchievementToastState._half.width,
      height: _AchievementToastState._half.height,
      decoration: BoxDecoration(
        color: left ? AppColors.capsuleRed : AppColors.surface,
        borderRadius: BorderRadius.horizontal(left: left ? r : Radius.zero, right: left ? Radius.zero : r),
        border: left ? null : Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: left ? AppColors.capsuleRedDark : AppColors.line, offset: const Offset(0, 3)),
        ],
      ),
    );
  }
}
