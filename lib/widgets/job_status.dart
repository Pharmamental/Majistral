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
          const SizedBox(height: AppSpace.lg),
          bar,
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
          const SizedBox(height: AppSpace.sm),
          bar,
        ],
      ),
    );
  }
}
