import 'dart:async';

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/prep_job.dart';
import '../theme/tokens.dart';
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

/// Süren bir işin ilerleme çubuğu ve kalan süresi; iş bitince "Teslim Et".
/// Saniyede bir kendini yeniler.
class JobStatus extends StatefulWidget {
  const JobStatus({super.key, required this.job});

  final PrepJob job;

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

  Future<void> _deliver() async {
    final store = JobScope.of(context);
    final job = await store.deliver(widget.job.magistralName);
    if (job == null || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job.magistralName, textAlign: TextAlign.center),
        content: ResultView(stars: job.stars, notes: job.notes),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tamam')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final ready = store.isReady(widget.job);
    if (ready) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
          onPressed: _deliver,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Hazır · Teslim Et'),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.hourglass_top_rounded, size: 18, color: AppColors.kiremit),
            const SizedBox(width: AppSpace.xs),
            const Text(
              'Hazırlanıyor',
              style: TextStyle(fontSize: AppFont.body, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const Spacer(),
            Text(
              formatRemaining(store.remaining(widget.job)),
              style: const TextStyle(
                fontSize: AppFont.body,
                fontWeight: FontWeight.w800,
                color: AppColors.kiremit,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: store.progress(widget.job),
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation(AppColors.kiremit),
          ),
        ),
      ],
    );
  }
}
