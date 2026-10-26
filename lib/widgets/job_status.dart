import 'dart:async';

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prep_job.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'result_view.dart';

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
        backgroundColor: AppColors.kiremitSoft,
        valueColor: const AlwaysStoppedAnimation(AppColors.kiremit),
      ),
    );

    if (widget.large) {
      return Column(
        children: [
          const Icon(Icons.hourglass_top_rounded, size: 40, color: AppColors.kiremit),
          const SizedBox(height: AppSpace.sm),
          Text('Hazırlanıyor', style: AppText.label(size: 14)),
          const SizedBox(height: AppSpace.xs),
          Text(remaining, style: AppText.timer(size: 44)),
          const SizedBox(height: AppSpace.xs),
          Text(where, style: AppText.body(size: 14, weight: FontWeight.w600)),
          const SizedBox(height: AppSpace.lg),
          bar,
          const SizedBox(height: AppSpace.lg),
          _StepList(job: widget.job, at: at),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.hourglass_top_rounded, size: 18, color: AppColors.kiremit),
              const SizedBox(width: AppSpace.xs),
              Text('Hazırlanıyor', style: AppText.body(size: 14, weight: FontWeight.w600)),
              const Spacer(),
              Text(remaining, style: AppText.timer()),
            ],
          ),
          if (where.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpace.xs),
                child: Text(where, style: AppText.label(size: 12)),
              ),
            ),
          const SizedBox(height: AppSpace.sm),
          bar,
        ],
      ),
    );
  }
}

/// Adımların listesi: bitti, şimdi, sırada; her adımın yanında istasyonu.
class _StepList extends StatelessWidget {
  const _StepList({required this.job, required this.at});

  final PrepJob job;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final s in job.slots)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
            child: Row(
              children: [
                Icon(
                  !at.isBefore(s.end)
                      ? Icons.check_circle_rounded
                      : !at.isBefore(s.start)
                          ? Icons.play_circle_fill_rounded
                          : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: !at.isBefore(s.end)
                      ? AppColors.success
                      : !at.isBefore(s.start)
                          ? AppColors.kiremit
                          : AppColors.line,
                ),
                const SizedBox(width: AppSpace.sm),
                Image.asset(s.station.imagePath, width: 28, height: 28),
                const SizedBox(width: AppSpace.sm),
                Expanded(child: Text(s.label, style: AppText.body(size: 14, weight: FontWeight.w600))),
                Text(s.station.label, style: AppText.label(size: 12)),
              ],
            ),
          ),
      ],
    );
  }
}
