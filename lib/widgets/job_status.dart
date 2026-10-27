import 'dart:async';

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'result_view.dart';
import 'station_action.dart';

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
Future<void> deliverJob(BuildContext context, String magistralName) async {
  // Teslimden sonra düğmenin bulunduğu kart yeniden çizilip kaybolabilir;
  // pencere bu yüzden kalıcı olan gezgin bağlamında açılır.
  final navigatorContext = Navigator.of(context).context;
  final job = await JobScope.of(context).deliver(magistralName);
  if (job == null || !navigatorContext.mounted) return;
  await showDialog<void>(
    context: navigatorContext,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(AppSpace.xxl),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.xxl, AppSpace.x3, AppSpace.xxl, AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(job.magistralName, textAlign: TextAlign.center, style: AppText.label(size: 14)),
            const SizedBox(height: AppSpace.md),
            ResultView(stars: job.stars, notes: job.notes),
            const SizedBox(height: AppSpace.xxl),
            SizedBox(
              width: double.infinity,
              child: ChunkyButton(label: 'Tamam', onPressed: () => Navigator.of(context).pop()),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Süren bir işin kalan süresi ve ilerleme çubuğu; iş bitince yeşil "Teslim Et".
/// Saniyede bir kendini yeniler.
class JobStatus extends StatefulWidget {
  const JobStatus({super.key, required this.job, this.large = false});

  final PrepJob job;

  /// Hazırlama ekranındaki büyük sayaç.
  final bool large;

  @override
  State<JobStatus> createState() => _JobStatusState();
}

class _JobStatusState extends State<JobStatus> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    if (store.isReady(widget.job)) {
      return SizedBox(
        width: double.infinity,
        child: ChunkyButton.success(
          label: 'Hazır · Teslim Et',
          icon: Icons.check_circle_rounded,
          onPressed: () => deliverJob(context, widget.job.magistralName),
        ),
      );
    }
    if (store.needsAction(widget.job)) {
      final station = widget.job.slots.last.station;
      final action = stationAction(station);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.large) ...[
            _StepStrip(job: widget.job, at: store.now()),
            const SizedBox(height: AppSpace.md),
          ],
          Text(
            action.prompt,
            textAlign: widget.large ? TextAlign.center : TextAlign.start,
            style: AppText.body(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpace.sm),
          ChunkyButton(
            label: action.button,
            icon: action.icon,
            onPressed: () => openStationAction(context, station, widget.job.magistralName),
          ),
          if (widget.large) ...[
            const SizedBox(height: AppSpace.lg),
            _StepList(job: widget.job, at: store.now()),
          ],
        ],
      );
    }
    final remaining = formatRemaining(store.remaining(widget.job));
    // Şu an hangi istasyonda, hangi adımda; istasyon doluysa sırada bekliyor.
    final at = store.now();
    final active = widget.job.activeAt(at);
    final waiting = widget.job.waitingAt(at);
    final where = active != null
        ? '${active.station.label}: ${active.label}'
        : waiting != null
            ? '${waiting.station.label} dolu, sırada'
            : '';
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        minHeight: widget.large ? 14 : 10,
        value: store.progress(widget.job),
        backgroundColor: AppColors.suruyorSoft,
        valueColor: const AlwaysStoppedAnimation(AppColors.suruyor),
      ),
    );

    if (widget.large) {
      return Column(
        children: [
          const Icon(Icons.hourglass_top_rounded, size: 40, color: AppColors.suruyor),
          const SizedBox(height: AppSpace.sm),
          Text('Hazırlanıyor', style: AppText.label(size: 14)),
          const SizedBox(height: AppSpace.xs),
          Text(remaining, style: AppText.timer(size: 44, color: AppColors.suruyorText)),
          const SizedBox(height: AppSpace.xs),
          Text(where, style: AppText.body(size: 14, weight: FontWeight.w600)),
          const SizedBox(height: AppSpace.lg),
          bar,
          const SizedBox(height: AppSpace.lg),
          SizedBox(width: double.infinity, child: _RushButton(job: widget.job)),
          const SizedBox(height: AppSpace.lg),
          _StepList(job: widget.job, at: at),
        ],
      );
    }
    // Kartta kalan süre bütün iş için: oyuncu adımının arkasındaki, henüz
    // planlanmamış adımlar da eklenir.
    final total = store.remaining(widget.job) +
        Duration(minutes: widget.job.pending.fold(0, (sum, p) => sum + p.minutes));
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.paper),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepStrip(job: widget.job, at: at),
          const SizedBox(height: AppSpace.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Icon(Icons.hourglass_top_rounded, size: 20, color: AppColors.suruyor),
              const SizedBox(width: AppSpace.xs),
              Text(formatRemaining(total), style: AppText.timer(size: 28, color: AppColors.suruyorText)),
              const SizedBox(width: AppSpace.sm),
              Text('sonra hazır', style: AppText.label(size: 13)),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          SizedBox(width: double.infinity, child: _RushButton(job: widget.job)),
        ],
      ),
    );
  }
}

/// "Acele et": ödüllü reklamla kalan süre yarıya iner, kalite de yarıya iner.
/// Reklam henüz bağlı değil; onay penceresi reklamın yerini tutuyor.
class _RushButton extends StatelessWidget {
  const _RushButton({required this.job});

  final PrepJob job;

  Future<void> _confirm(BuildContext context) async {
    final store = JobScope.of(context);
    final before = formatRemaining(store.remaining(job));
    final after = formatRemaining(store.remainingAfterRush(job));
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(AppSpace.xxl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.bolt_rounded, size: 40, color: AppColors.kobalt),
              const SizedBox(height: AppSpace.sm),
              Text('Acele et', textAlign: TextAlign.center, style: AppText.title(size: 22)),
              const SizedBox(height: AppSpace.md),
              Text('Kalan süre: $before › $after', style: AppText.body(weight: FontWeight.w600)),
              const SizedBox(height: AppSpace.xs),
              Text(
                'Kalite de yarıya iner: aceleyle karıştırılan merhem homojen olmaz.',
                style: AppText.body(size: 14),
              ),
              const SizedBox(height: AppSpace.xs),
              Text('Bugün ${store.rushesLeft} hakkın var.', style: AppText.label()),
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
      ),
    );
    if (yes == true) await store.rush(job.magistralName);
  }

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final left = store.rushesLeft;
    return ChunkyButton.secondary(
      label: left > 0 ? 'Acele et · $left hak' : 'Bugünkü acele hakkın bitti',
      icon: Icons.bolt_rounded,
      onPressed: store.canRush(job) ? () => _confirm(context) : null,
    );
  }
}

/// Adımların listesi: bitti, şimdi, sırada; her adımın yanında istasyonu.
class _StepList extends StatelessWidget {
  const _StepList({required this.job, required this.at});

  final PrepJob job;
  final DateTime at;

  Widget _row(IconData icon, Color color, String imagePath, String label, String station) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpace.sm),
          Image.asset(imagePath, width: 28, height: 28),
          const SizedBox(width: AppSpace.sm),
          Expanded(child: Text(label, style: AppText.body(size: 14, weight: FontWeight.w600))),
          Text(station, style: AppText.label(size: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final waitingForPlayer = job.needsActionAt(at);
    return Column(
      children: [
        for (final s in job.slots)
          if (waitingForPlayer && identical(s, job.slots.last))
            _row(Icons.touch_app_rounded, AppColors.kobalt, stepIconPath(s.label), s.label, 'Sıra sende')
          else if (!at.isBefore(s.end))
            _row(Icons.check_circle_rounded, AppColors.success, stepIconPath(s.label), s.label, s.station.label)
          else if (!at.isBefore(s.start))
            _row(Icons.play_circle_fill_rounded, AppColors.suruyor, stepIconPath(s.label), s.label, s.station.label)
          else
            _row(Icons.radio_button_unchecked_rounded, AppColors.line, stepIconPath(s.label), s.label, s.station.label),
        // Oyuncunun adımından sonra planlanacak adımlar.
        for (final p in job.pending)
          _row(Icons.radio_button_unchecked_rounded, AppColors.line, stepIconPath(p.label), p.label, p.station.label),
      ],
    );
  }
}

/// Kartta adımlar yan yana: biten soluk ve onaylı, süren mavi çerçeveli ve
/// kalan süreli, oyuncuyu bekleyen amber "Sıra sende", sıradakiler silik.
class _StepStrip extends StatelessWidget {
  const _StepStrip({required this.job, required this.at});

  final PrepJob job;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    final waitingForPlayer = job.needsActionAt(at);
    final tiles = <Widget>[
      for (final s in job.slots)
        if (waitingForPlayer && identical(s, job.slots.last))
          _StepTile(label: s.label, state: _TileState.player, note: 'Sıra sende')
        else if (!at.isBefore(s.end))
          _StepTile(label: s.label, state: _TileState.done, note: 'Bitti')
        else if (!at.isBefore(s.start))
          _StepTile(
            label: s.label,
            state: _TileState.now,
            note: '${formatRemaining(s.end.difference(at))} kaldı',
            progress: at.difference(s.start).inMilliseconds / s.end.difference(s.start).inMilliseconds,
          )
        else
          _StepTile(label: s.label, state: _TileState.next, note: '${s.end.difference(s.start).inMinutes} dk'),
      for (final p in job.pending) _StepTile(label: p.label, state: _TileState.next, note: '${p.minutes} dk'),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, t) in tiles.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpace.sm),
            Expanded(child: t),
          ],
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
              Opacity(
                opacity: faded ? 0.55 : 1,
                child: Image.asset(stepIconPath(label), width: 40, height: 40),
              ),
              const SizedBox(height: AppSpace.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, maxLines: 1, style: AppText.label(size: 12, color: AppColors.ink)),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  note,
                  maxLines: 1,
                  style: AppText.label(size: 11, color: noteColor).copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
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
