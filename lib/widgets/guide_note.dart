import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'paper_tape.dart';

/// Öğreticinin yazıları (Tuğrul, 2026-10-31, "okey yap"): ayrı bölüm ya da
/// pencere yok, oyuncu ilk reçeteyi yaparken yerinde kısa notlar görür. Not
/// akışı durdurmaz, oyuncu işi yapınca kendiliğinden değişir. Eczacılık
/// cümleleri hoca onayından geçecek (AGENTS.md).

/// Takılan oyuncuya ikinci reçetede kaç saniye sonra not çıkar. Yer tutucu.
const guideIdle = Duration(seconds: 8);

/// Yapılan adımın ne öğrettiği; ilk reçetenin adımları.
const _lessons = {
  'Ezme': 'Taneleri incelttin, merhem kumlu olmaz.',
  'Levigasyon': 'Tozu azıcık sıvıyla macun yaptın. Buna levigasyon denir.',
  'Geometrik seyreltme': 'Vazelini her seferinde karışım kadar ekledin. Buna geometrik seyreltme denir.',
};

/// Tezgâhtaki not: elde reçete yokken gösterilir.
String? counterGuide(JobStore store) {
  if (!store.guideNotes) return null;
  return switch (store.guideStage) {
    0 => 'Bu eczane artık senin. İlk reçeten duvarda.',
    1 => 'Duvara üç reçete geldi. Sıradakini sen seç. Bundan sonra adımlar daha uzun sürer, sen yokken de işler.',
    _ => null,
  };
}

/// Laboratuvardaki not; [toOrders] ise altında "Reçetelere git" düğmesi olur.
({String text, bool toOrders})? labGuide(JobStore store) {
  if (!store.guideNotes) return null;
  final job = store.jobs.firstOrNull;
  ({String text, bool toOrders}) note(String text, {bool toOrders = false}) => (text: text, toOrders: toOrders);
  switch (store.guideStage) {
    case 0:
      if (job == null) return note('Önce reçeteni al. Reçete duvarda seni bekliyor.', toOrders: true);
      final lesson = job.runs.isEmpty ? '' : '${_lessons[job.runs.last.label] ?? ''} ';
      final next = store.nextStep(job);
      if (store.isReady(job)) return note('$lessonİlacın hazır, şimdi hastaya teslim edebilirsin.', toOrders: true);
      if (store.running(job) case final run?) {
        return note(
          next == null ? '${run.label} sürüyor. Bitince ilacın hazır.' : '${run.label} sürüyor. Bitince sıra ${next.label} adımında.',
        );
      }
      return note(
        job.runs.isEmpty
            ? 'Sıradaki adım ${next!.label}. ${next.label} kartına dokun.'
            : '$lessonŞimdi ${next!.label} kartına dokun.',
      );
    case 1:
      if (job == null) return null;
      if (store.running(job) != null) {
        return store.jobs.length == 1 && store.wall.isNotEmpty
            ? note('Adım sürerken duvardan bir reçete daha alabilirsin.')
            : null;
      }
      if (store.idleFor(job) < guideIdle) return null;
      if (store.isReady(job)) return note('İlacın hazır, şimdi hastaya teslim edebilirsin.', toOrders: true);
      final step = store.nextStep(job)!;
      return note('Reçeten seni bekliyor. ${step.label} kartına dokun.');
    case 2:
      return job != null && store.running(job) != null ? note('Uygulamayı kapatabilirsin, iş sürer.') : null;
    default:
      return null;
  }
}

/// Bantlı kâğıt not: tezgâhta ya da laboratuvar listesinin başında durur.
class GuideNote extends StatelessWidget {
  const GuideNote({super.key, required this.text, this.action, this.onAction, this.onClose});

  final String text;

  /// Kâğıdın altındaki tek düğme.
  final String? action;
  final VoidCallback? onAction;

  /// Verilirse altta "Notları kapat".
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          // Yazı değişirken alttaki kartlar oynamasın.
          constraints: const BoxConstraints(minHeight: 96),
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xl, AppSpace.lg, AppSpace.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.paper),
            boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(text, textAlign: TextAlign.center, style: AppText.body(size: 14, weight: FontWeight.w600)),
              if (action != null) ...[
                const SizedBox(height: AppSpace.md),
                ChunkyButton(label: action!, compact: true, onPressed: onAction),
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
        ),
        const Positioned(top: -8, child: PaperTape(width: 36, height: 14)),
      ],
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
