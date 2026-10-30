
import 'package:flutter/material.dart';

import '../data/dried_plants.dart';
import '../data/economy.dart';
import '../logic/job_store.dart';
import '../logic/profile_stats.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../screens/home_screen.dart';
import '../theme/tokens.dart';
import 'achievement_toast.dart';
import 'chunky_button.dart';
import 'grow_panel.dart';
import 'patient_sheet.dart';
import 'result_view.dart';
import 'second_tick.dart';

/// "02:15" ya da "1 sa 05 dk" biçiminde kalan süre.
String formatRemaining(Duration d) {
  if (d.inHours >= 1) {
    final minutes = d.inMinutes % 60;
    return '${d.inHours} sa ${minutes.toString().padLeft(2, '0')} dk';
  }
  final seconds = d.inSeconds % 60;
  return '${d.inMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

/// Hazır işi teslim eder ve sonucu kutlama penceresinde gösterir.
Future<void> deliverJob(BuildContext context, int id) async {
  // Teslimden sonra düğmenin bulunduğu kart yeniden çizilip kaybolabilir;
  // pencere bu yüzden kalıcı olan gezgin bağlamında açılır.
  // Pencere "Teslim Et" düğmesinin yerinden büyür.
  final navigatorContext = Navigator.of(context).context;
  final from = rectOf(context);
  final store = JobScope.of(context);
  final job = await store.deliver(id);
  if (job == null || !navigatorContext.mounted) return;
  final drop = store.lastDrop;
  final pay = store.lastPayout;
  // Ustalıkta seviye atlandıysa üstte başarım kutucuğu; teslim penceresiyle birlikte.
  showAchievements(navigatorContext, tierUps(store.deliveries));
  await openGrowing<void>(
    navigatorContext,
    from: from,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.xxl, AppSpace.x3, AppSpace.xxl, AppSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(job.magistralName, textAlign: TextAlign.center, style: AppText.label(size: 14)),
          const SizedBox(height: AppSpace.md),
          ResultView(stars: job.stars, notes: job.notes),
          // Teslim parası (2026-10-29): malzeme bedeli hep tam, emek yıldıza göre.
          if (pay != null) ...[
            const SizedBox(height: AppSpace.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.toll_rounded, size: 22, color: AppColors.star),
                const SizedBox(width: AppSpace.xs),
                Text('${pay.coins}', style: AppText.title(size: 22)),
              ],
            ),
            Text(
              'Malzeme parası ${pay.material}, emek parası ${pay.labor}',
              textAlign: TextAlign.center,
              style: AppText.label(size: 12, color: AppColors.ink),
            ),
            if (pay.dailyBonus)
              Text(
                'Günün ilk $dailyBonusDeliveries teslimi emeği iki kat öder',
                textAlign: TextAlign.center,
                style: AppText.label(size: 12, color: AppColors.hazirText),
              ),
            if (store.debt > 0)
              Text(
                'Ecza deposuna ${store.debt} para borcun kaldı',
                textAlign: TextAlign.center,
                style: AppText.label(size: 12, color: AppColors.bekliyorText),
              ),
          ],
          // Teslimlerin yarısı bahçeye bir tohum getirir (2026-10-29).
          if (drop != null) ...[
            const SizedBox(height: AppSpace.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (driedPlantNamed(drop) case final p?) Image.asset(p.imagePath, width: 36, height: 36),
                const SizedBox(width: AppSpace.sm),
                Flexible(
                  child: Text(
                    '$drop tohumu kazandın, bahçeye ekebilirsin',
                    style: AppText.label(size: 13, color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpace.xxl),
          SizedBox(
            width: double.infinity,
            child: ChunkyButton(label: 'Tamam', onPressed: () => Navigator.of(context).pop()),
          ),
        ],
      ),
    ),
  );
  // Teslimden sonra hasta tezgâha gelir, ilacı sorar.
  if (!patientQuestionsEnabled || !navigatorContext.mounted) return;
  if (store.nextPatientQuestion(job) case final question?) {
    await askPatient(navigatorContext, store, question, from: from);
  }
}

/// Kabul edilmiş reçetenin kartta durumu: adım şeridi; adım çalışıyorsa
/// kalan süresi ve acele et, oyuncuyu bekliyorsa sıradaki adım ve
/// laboratuvara götüren düğme, bitince yeşil "Teslim Et". Saniyede bir
/// kendini yeniler.
class JobStatus extends StatefulWidget {
  const JobStatus({super.key, required this.job});

  final PrepJob job;

  @override
  State<JobStatus> createState() => _JobStatusState();
}

class _JobStatusState extends State<JobStatus> with SecondTick {

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final job = widget.job;
    if (store.isReady(job)) {
      return SizedBox(
        width: double.infinity,
        child: ChunkyButton.success(
          label: 'Teslim et',
          icon: Icons.check_circle_rounded,
          onPressed: () => deliverJob(context, job.id),
        ),
      );
    }
    final run = store.running(job);
    final next = store.nextStep(job);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpace.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.paper),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StepStrip(job: job, steps: store.orderOf(job).steps, at: store.now()),
              const SizedBox(height: AppSpace.md),
              if (run != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Icon(Icons.hourglass_top_rounded, size: 20, color: AppColors.suruyor),
                    const SizedBox(width: AppSpace.xs),
                    Text(
                      formatRemaining(run.end.difference(store.now())),
                      style: AppText.timer(size: 28, color: AppColors.suruyorText),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Text(next == null ? 'sonra hazır' : 'sonra sıra sende', style: AppText.label(size: 13)),
                  ],
                ),
                const SizedBox(height: AppSpace.sm),
                _RushButton(job: job),
              ] else
                // Bekleyen adım amber kutuda; altında cümle yok (Tuğrul, 2026-10-28).
                ChunkyButton(
                  label: 'Laboratuvara git',
                  icon: Icons.science_rounded,
                  onPressed: () => HomeScreen.showTab(context, HomeScreen.lab),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Acele et": ödüllü reklamla çalışan adımın kalan süresi yarıya iner,
/// kalite de yarıya iner. Reklam henüz bağlı değil; onay penceresi reklamın
/// yerini tutuyor.
class _RushButton extends StatelessWidget {
  const _RushButton({required this.job});

  final PrepJob job;

  Future<void> _confirm(BuildContext context) async {
    final store = JobScope.of(context);
    final run = store.running(job)!;
    final before = formatRemaining(run.end.difference(store.now()));
    final after = formatRemaining(store.stepLeftAfterRush(job));
    // Pencere düğmenin yerinden büyür.
    final yes = await openGrowing<bool>(
      context,
      from: rectOf(context),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.bolt_rounded, size: 40, color: AppColors.kobalt),
            const SizedBox(height: AppSpace.sm),
            Text('Acele et', textAlign: TextAlign.center, style: AppText.title(size: 22)),
            const SizedBox(height: AppSpace.md),
            Text('Kalan süre $before › $after', style: AppText.body(weight: FontWeight.w600)),
            const SizedBox(height: AppSpace.xs),
            Text(
              store.protectedRushesLeft > 0
                  ? 'Vitrindeki fanus bu acelede kaliteyi korur. Bugün ${store.protectedRushesLeft} kez daha korur.'
                  : 'Kalite de yarıya iner, aceleyle karıştırılan merhem homojen olmaz.',
              style: AppText.body(size: 14),
            ),
            const SizedBox(height: AppSpace.xs),
            Text('Bugün ${store.rushesLeft} acele hakkın kaldı.', style: AppText.label()),
            const SizedBox(height: AppSpace.xl),
            ChunkyButton(
              label: 'Reklam izle',
              icon: Icons.play_circle_fill_rounded,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: AppSpace.sm),
            ChunkyButton.secondary(label: 'Vazgeç', onPressed: () => Navigator.of(context).pop(false)),
          ],
        ),
      ),
    );
    if (yes == true) await store.rush(job.id);
  }

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final left = store.rushesLeft;
    return ChunkyButton.secondary(
      label: left > 0 ? 'Acele et' : 'Bugünkü acele hakkın bitti',
      icon: Icons.bolt_rounded,
      onPressed: store.canRush(job) ? () => _confirm(context) : null,
    );
  }
}

/// Kartta adımlar yan yana: biten soluk ve onaylı, süren mor çerçeveli ve
/// kalan süreli, oyuncuyu bekleyen amber "Sıra sende", sıradakiler silik.
class _StepStrip extends StatelessWidget {
  const _StepStrip({required this.job, required this.steps, required this.at});

  final PrepJob job;
  final List<PrescriptionStep> steps;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    final runs = job.runs;
    final tiles = <Widget>[
      for (final (i, s) in steps.indexed)
        if (i < runs.length && !at.isBefore(runs[i].end))
          _StepTile(label: s.label, state: _TileState.done, note: 'Bitti')
        else if (i < runs.length)
          _StepTile(
            label: s.label,
            state: _TileState.now,
            note: '${formatRemaining(runs[i].end.difference(at))} kaldı',
            progress:
                at.difference(runs[i].start).inMilliseconds / runs[i].end.difference(runs[i].start).inMilliseconds,
          )
        else if (i == runs.length && job.runningAt(at) == null)
          _StepTile(label: s.label, state: _TileState.player, note: 'Sıra sende')
        else
          _StepTile(label: s.label, state: _TileState.next, note: '${s.minutes} dk'),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, t) in tiles.indexed) ...[if (i > 0) const SizedBox(width: AppSpace.sm), Expanded(child: t)],
        ],
      ),
    );
  }
}

enum _TileState { done, now, player, next }

class _StepTile extends StatelessWidget {
  const _StepTile({required this.label, required this.state, required this.note, this.progress});

  final String label;
  final _TileState state;
  final String note;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final (Color fill, Color border, Color noteColor) = switch (state) {
      _TileState.done => (Colors.transparent, Colors.transparent, AppColors.success),
      _TileState.now => (AppColors.suruyorSoft, AppColors.suruyor, AppColors.suruyorText),
      _TileState.player => (AppColors.bekliyorSoft, AppColors.bekliyor, AppColors.bekliyorText),
      _TileState.next => (AppColors.surface, AppColors.line, AppColors.inkMuted),
    };
    final faded = state == _TileState.done || state == _TileState.next;
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpace.xs, AppSpace.sm, AppSpace.xs, AppSpace.sm),
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: border, width: 2),
        borderRadius: BorderRadius.circular(AppRadius.paperInner),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
                child: Opacity(
                  opacity: faded ? 0.55 : 1,
                  child: Image.asset(stepIconPath(label), width: 40, height: 40),
                ),
              ),
              const SizedBox(height: AppSpace.xs),
              // İki kelimelik ad iki satıra iner; yalnız en uzun kelime sığmazsa küçülür.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label.replaceAll(' ', '\n'),
                  textAlign: TextAlign.center,
                  style: AppText.label(size: 12, color: AppColors.ink),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  note,
                  maxLines: 1,
                  style: AppText.label(
                    size: 11,
                    color: noteColor,
                  ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: AppSpace.xs),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      value: progress!.clamp(0.0, 1.0),
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation(AppColors.suruyor),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (state == _TileState.done)
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
            ),
        ],
      ),
    );
  }
}
