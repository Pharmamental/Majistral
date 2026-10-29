import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../models/shop_item.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'grow_panel.dart';
import 'paper_tape.dart';

// Satın alma (2026-10-29): aletler ve kimyasal paketleri kasadaki parayla
// alınır (data/economy.dart). Reklam düğmesi henüz bağlı değil.

/// Bir istasyon = bir laboratuvar adımı. Yükseltme yolu (Tuğrul, 2026-10-29, "E"):
/// kartın başında adımın ikonu ve adı; altında aletler bir yolun durakları gibi.
/// Elde olanlar yeşil halkalı ve yeşil çizgiyle bağlı, sıradaki kesik kobalt halkalı
/// ve altında kaç kat hızlandırdığı. En altta sıradaki aletin düğmesi ya da "Elinde".
/// Süre, kısalma çipi ve "para gerek" yazısı yok (Tuğrul).
class StationSection extends StatelessWidget {
  const StationSection({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final tiers = station.tiers;
    final next = tiers.where((t) => !store.ownsTool(t)).firstOrNull;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpace.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.paper),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
                  child: Image.asset(stepIconPath(station.name), width: 48, height: 48),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(child: Text(station.name, style: AppText.title(size: 22))),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final n = tiers.length;
                final width = math.min(112.0, constraints.maxWidth / n);
                final gap = n == 1 ? 0.0 : (constraints.maxWidth - width * n) / (n - 1);
                double center(int i) => i * (width + gap) + width / 2;
                return Stack(
                  children: [
                    // Duraklar arası çizgi: iki ucu da eldeyse yeşil.
                    for (var i = 1; i < n; i++)
                      Positioned(
                        left: center(i - 1),
                        width: center(i) - center(i - 1),
                        top: _TierNode.ring / 2 - 2,
                        height: 4,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: store.ownsTool(tiers[i]) ? AppColors.success : AppColors.line,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final tier in tiers)
                          SizedBox(width: width, child: _TierNode(tier: tier, owned: store.ownsTool(tier))),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpace.lg),
            if (next == null)
              Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded, size: 18, color: AppColors.successDark),
                    const SizedBox(width: AppSpace.xs),
                    Text('Elinde', style: AppText.label(size: 15, color: AppColors.successDark)),
                  ],
                ),
              )
            else
              ChunkyButton(
                compact: true,
                label: '${next.price} ile al',
                icon: Icons.toll_rounded,
                // Para yetmiyorsa düğme kapalı (2026-10-29).
                onPressed: store.coins >= next.price ? () => store.buyTool(next) : null,
              ),
          ],
        ),
      ),
    );
  }
}

/// Yolun bir durağı: halkalı alet ikonu, adı ve altında durumu.
class _TierNode extends StatelessWidget {
  const _TierNode({required this.tier, required this.owned});

  final ShopItem tier;
  final bool owned;

  static const double ring = 64;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: ring,
          child: CustomPaint(
            painter: _RingPainter(color: owned ? AppColors.success : AppColors.kobalt, dashed: !owned),
            child: Center(
              child: Container(
                width: ring - 10,
                height: ring - 10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: owned ? AppColors.iconWell : AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: tier.imagePath != null
                    ? Image.asset(tier.imagePath!, width: 44, height: 44)
                    : Icon(tier.icon, color: AppColors.inkMuted, size: 28),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        Text(tier.name, textAlign: TextAlign.center, style: AppText.label(size: 13, color: AppColors.ink)),
        Text(
          !owned
              ? '%${tier.faster} daha hızlı'
              : tier.price == 0
                  ? 'Bedava'
                  : 'Elinde',
          textAlign: TextAlign.center,
          style: AppText.label(size: 12, color: AppColors.inkMuted),
        ),
      ],
    );
  }
}

/// Durak halkası: elde olan düz yeşil, sıradaki kesik kobalt.
class _RingPainter extends CustomPainter {
  const _RingPainter({required this.color, required this.dashed});

  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 3.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    if (!dashed) {
      canvas.drawOval(rect, paint);
      return;
    }
    const dashes = 16;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, i * sweep, sweep * .6, false, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.color != color || old.dashed != dashed;
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.item, required this.size});

  final ShopItem item;
  final double size;

  // İkon açık bir kutunun üstünde durur; kenar çizgisi kutuya taşabilir, kırpılmaz.
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

/// Kimyasalın "Al" penceresi: satırın yerinden büyür, kaç paket alınacağı
/// seçilir (Tuğrul, 2026-10-29: 1, 5, 10, 20, 100).
Future<void> openPackBuy(BuildContext context, ShopItem item) =>
    openGrowing<void>(context, from: rectOf(context), builder: (_) => _PackBuyPanel(item: item));

class _PackBuyPanel extends StatefulWidget {
  const _PackBuyPanel({required this.item});

  final ShopItem item;

  static const counts = [1, 5, 10, 20, 100];

  @override
  State<_PackBuyPanel> createState() => _PackBuyPanelState();
}

class _PackBuyPanelState extends State<_PackBuyPanel> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final item = widget.item;
    final total = item.price * _count;
    final enough = store.coins >= total;
    return Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Thumb(item: item, size: 56),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppText.title(size: 20)),
                    const SizedBox(height: AppSpace.xs),
                    Text(
                      'Sahip olunan: ${store.packsOf(item.name)} adet',
                      style: AppText.label(size: 13, color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Text('Kaç paket?', style: AppText.label(size: 14, color: AppColors.ink)),
          const SizedBox(height: AppSpace.sm),
          PillTabs<int>(
            values: _PackBuyPanel.counts,
            selected: _count,
            labelOf: (n) => '$n',
            onChanged: (n) => setState(() => _count = n),
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            children: [
              Text('Toplam', style: AppText.body(size: 15)),
              const Spacer(),
              const Icon(Icons.toll_rounded, size: 20, color: AppColors.star),
              const SizedBox(width: AppSpace.xs),
              Text('$total', style: AppText.title(size: 20)),
            ],
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            enough ? 'Kasada ${store.coins} para var.' : 'Paran yetmiyor: kasada ${store.coins} para var.',
            style: AppText.label(size: 13, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.lg),
          ChunkyButton(
            label: '$_count paket al',
            onPressed: enough
                ? () async {
                    final navigator = Navigator.of(context);
                    if (await store.buyPacks(item.name, _count)) navigator.pop();
                  }
                : null,
          ),
          const SizedBox(height: AppSpace.sm),
          ChunkyButton.secondary(label: 'Vazgeç', onPressed: () => Navigator.of(context).pop()),
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
  });

  final ShopItem item;

  /// Açıklamanın altındaki ek satır (kimyasalda paket fiyatı ve raftaki sayı).
  final String? detail;

  /// Henüz onu isteyen reçete gelmemiş kimyasal: soluk, kilitli, alınmaz.
  final bool locked;

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
                Text(locked ? 'Kilitli madde' : item.name, style: AppText.title(size: 17, color: locked ? AppColors.inkMuted : AppColors.ink)),
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
                    // Dokununca hemen almaz; miktar penceresi açılır (Tuğrul, 2026-10-29).
                    : ChunkyButton(
                        compact: true,
                        label: 'Al',
                        onPressed: () => openPackBuy(context, item),
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
