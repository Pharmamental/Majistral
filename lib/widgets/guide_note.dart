import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prep_job.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';

/// Öğreticinin notları (Tuğrul, 2026-10-31, "okey yap"): ayrı bölüm ya da pencere
/// yok, oyuncu ilk reçeteyi yaparken yerinde görür. Notlar hazırlık defteri
/// sayfası (Tuğrul, 2026-11-01, "7"; alternatifler
/// https://claude.ai/artifact/KzvHVRNAvL3mebxXePpPLf): oyuncu neyi bitirdiğini, şimdi
/// ne yapacağını ve sırada ne olduğunu birlikte görür. Sayfa akışı durdurmaz, oyuncu
/// işi yapınca kendiliğinden değişir. Eczacılık cümleleri hoca onayından geçecek
/// (AGENTS.md).

/// Takılan oyuncuya ikinci reçetede kaç saniye sonra not çıkar. Yer tutucu.
const guideIdle = Duration(seconds: 8);

/// Yapılan adımın ne öğrettiği; ilk reçetenin adımları.
const _lessons = {
  'Ezme': 'Taneleri incelttin, merhem kumlu olmaz.',
  'Levigasyon': 'Tozu azıcık sıvıyla macun yaptın. Buna levigasyon denir.',
  'Geometrik seyreltme': 'Vazelini her seferinde karışım kadar ekledin. Buna geometrik seyreltme denir.',
};

/// Defter satırının durumu: bitti, şimdi yapılıyor, sırada.
enum GuideMark { done, now, later }

typedef GuideRow = ({String title, String? note, GuideMark mark});

/// Defterin bir sayfası. [numbered] değilse tek satırlık kısa not.
class GuidePage {
  const GuidePage(this.rows, {this.numbered = true, this.footer, this.toOrders = false});

  final List<GuideRow> rows;
  final bool numbered;

  /// Çizgilerin altında tek cümle.
  final String? footer;

  /// Altta "Reçetelere git" düğmesi olur.
  final bool toOrders;
}

GuidePage _single(String title, {String? note, String? footer, bool toOrders = false}) => GuidePage(
      [(title: title, note: note, mark: GuideMark.now)],
      numbered: false,
      footer: footer,
      toOrders: toOrders,
    );

/// Oyunun bütün döngüsü: reçete alınmadan önce.
GuidePage _loop({bool toOrders = false}) => GuidePage(
      const [
        (title: 'Reçeteni al', note: 'Duvardaki reçeteye dokun.', mark: GuideMark.now),
        (title: 'Laboratuvarda hazırla', note: null, mark: GuideMark.later),
        (title: 'Hastaya teslim et', note: null, mark: GuideMark.later),
      ],
      toOrders: toOrders,
    );

/// Reçetenin adımları: biten tikli, son bitenin altında öğrettiği şey.
GuidePage _steps(JobStore store, PrepJob job) {
  final steps = store.orderOf(job).steps;
  final running = store.running(job) != null;
  final finished = running ? job.runs.length - 1 : job.runs.length;
  return GuidePage(
    [
      for (final (i, s) in steps.indexed)
        if (i < finished)
          (title: s.label, note: i == finished - 1 ? _lessons[s.label] : null, mark: GuideMark.done)
        else if (i == finished)
          (
            title: s.label,
            note: !running
                ? '${s.label} kartına dokun.'
                : i == steps.length - 1
                ? 'Sürüyor. Bitince ilacın hazır.'
                : 'Sürüyor. Bitince sıra ${steps[i + 1].label} adımında.',
            mark: GuideMark.now,
          )
        else
          (title: s.label, note: null, mark: GuideMark.later),
    ],
    footer: store.isReady(job) ? 'İlacın hazır, şimdi hastaya teslim edebilirsin.' : null,
    toOrders: store.isReady(job),
  );
}

/// Tezgâhtaki sayfa: elde reçete yokken gösterilir.
GuidePage? counterGuide(JobStore store) {
  if (!store.guideNotes) return null;
  return switch (store.guideStage) {
    0 => _loop(),
    1 => _single(
        'Duvara üç reçete geldi.',
        note: 'Sıradakini sen seç. Bundan sonra adımlar daha uzun sürer, sen yokken de işler.',
      ),
    _ => null,
  };
}

/// Laboratuvardaki sayfa.
GuidePage? labGuide(JobStore store) {
  if (!store.guideNotes) return null;
  final job = store.jobs.firstOrNull;
  switch (store.guideStage) {
    case 0:
      return job == null ? _loop(toOrders: true) : _steps(store, job);
    case 1:
      if (job == null) return null;
      if (store.running(job) != null) {
        return store.jobs.length == 1 && store.wall.isNotEmpty
            ? _single('Adım sürerken duvardan bir reçete daha alabilirsin.')
            : null;
      }
      if (store.idleFor(job) < guideIdle) return null;
      if (store.isReady(job)) return _single('İlacın hazır, şimdi hastaya teslim edebilirsin.', toOrders: true);
      return _single('Reçeten seni bekliyor.', note: '${store.nextStep(job)!.label} kartına dokun.');
    case 2:
      return job != null && store.running(job) != null ? _single('Uygulamayı kapatabilirsin, iş sürer.') : null;
    default:
      return null;
  }
}

/// Hazırlık defteri sayfası: çizgili kâğıt, solda kırmızı kenar çizgisi. Tezgâhta
/// ya da laboratuvar listesinin başında durur.
class GuideNote extends StatelessWidget {
  const GuideNote({super.key, required this.page, this.steady = false, this.onAction, this.onClose});

  final GuidePage page;

  /// Adım değişirken sayfa boyu sabit kalır, alttaki kartlar oynamaz.
  final bool steady;
  final VoidCallback? onAction;

  /// Verilirse altta "Notları kapat".
  final VoidCallback? onClose;

  /// Satırın başındaki sütun; kenar çizgisi hemen sağından geçer.
  static const double _gutter = 28;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpace.md, AppSpace.sm, AppSpace.md, AppSpace.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: steady ? 160 : 0),
            child: Stack(
              children: [
                Positioned(
                  left: _gutter + AppSpace.xs,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 1.5, color: AppColors.ledgerMargin),
                ),
                Column(
                  children: [
                    for (final (i, row) in page.rows.indexed) _Row(number: page.numbered ? i + 1 : null, row: row),
                  ],
                ),
              ],
            ),
          ),
          if (page.footer != null) ...[
            const SizedBox(height: AppSpace.sm),
            Text(page.footer!, textAlign: TextAlign.center, style: AppText.body(size: 14, weight: FontWeight.w600)),
          ],
          if (page.toOrders) ...[
            const SizedBox(height: AppSpace.sm),
            ChunkyButton(label: 'Reçetelere git', compact: true, onPressed: onAction),
          ],
          if (onClose != null)
            Center(
              child: TextButton(
                onPressed: onClose,
                style: TextButton.styleFrom(minimumSize: const Size(48, 44), shape: const StadiumBorder()),
                child: Text('Notları kapat', style: AppText.label(size: 12)),
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.number, required this.row});

  /// Satır numarası; kısa notta yok.
  final int? number;
  final GuideRow row;

  @override
  Widget build(BuildContext context) {
    final now = row.mark == GuideMark.now;
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ledgerRule))),
      padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: GuideNote._gutter,
            child: row.mark == GuideMark.done
                ? const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success)
                : number == null
                ? const Icon(Icons.edit_rounded, size: 18, color: AppColors.accentText)
                : Text('$number.', style: AppText.title(size: 15, color: now ? AppColors.accentText : AppColors.inkMuted)),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: now
                      ? AppText.title(size: 15, color: AppColors.accentText)
                      : AppText.body(size: 14, color: row.mark == GuideMark.done ? AppColors.ink : AppColors.inkMuted),
                ),
                if (row.note != null)
                  Text(row.note!, style: AppText.label(size: 12, color: now ? AppColors.ink : AppColors.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Oyuncunun dokunacağı şeyin çevresinde yavaş nabız. Yerleşimi oynatmaz.
/// "Hareketi azalt" açıksa sabit halka kalır.
class GuidePulse extends StatefulWidget {
  const GuidePulse({super.key, required this.active, required this.child, this.color = AppColors.kobalt});

  final bool active;
  final Color color;
  final Widget child;

  @override
  State<GuidePulse> createState() => _GuidePulseState();
}

class _GuidePulseState extends State<GuidePulse> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  void _sync() {
    if (widget.active && !MediaQuery.disableAnimationsOf(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(GuidePulse old) {
    super.didUpdateWidget(old);
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.paper),
            boxShadow: [
              if (widget.active)
                BoxShadow(color: widget.color.withValues(alpha: 0.7 - t * 0.4), blurRadius: 4 + t * 10, spreadRadius: 2 + t * 5),
            ],
          ),
          child: child,
        );
      },
    );
  }
}
