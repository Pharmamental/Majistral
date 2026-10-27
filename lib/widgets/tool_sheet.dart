import 'package:flutter/material.dart';

import '../data/lab_tools.dart';
import '../logic/job_store.dart';
import '../models/prep_job.dart';
import '../theme/tokens.dart';
import 'heating_sheet.dart';
import 'job_status.dart';

/// Laboratuvarda bir alete basınca açılan pencere (Tuğrul, 2026-10-27): kabul
/// edilmiş reçeteler listelenir. Aleti şimdi kullanabilenler vurgulu ve
/// basılabilir; kullanamayanların altında nedeni yazar. Seçilen reçetenin
/// sıradaki adımı başlar; mini oyunlu adımda önce oyun açılır.
Future<void> openToolSheet(BuildContext context, LabTool tool) {
  final store = JobScope.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.paper)),
    ),
    builder: (sheetContext) => ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final jobs = [for (final j in store.jobs) if (!store.isReady(j)) j];
        final busy = store.busyWith(tool);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
                      child: Image.asset(tool.imagePath, width: 44, height: 44),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Expanded(child: Text(tool.name, style: AppText.title(size: 20))),
                  ],
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  busy != null
                      ? 'Şu an ${busy.job.magistralName}: ${busy.run.label}, '
                          '${formatRemaining(busy.run.end.difference(store.now()))} kaldı.'
                      : jobs.isEmpty
                          ? 'Laboratuvarda reçete yok. Reçeteler\'de bir reçeteye Hazırla de.'
                          : 'Bu aletle hangi reçeteye devam edeceksin?',
                  style: AppText.body(size: 14, color: AppColors.inkMuted),
                ),
                const SizedBox(height: AppSpace.md),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final job in jobs) ...[
                        _JobRow(tool: tool, job: job, sheetContext: sheetContext),
                        const SizedBox(height: AppSpace.sm),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _JobRow extends StatelessWidget {
  const _JobRow({required this.tool, required this.job, required this.sheetContext});

  final LabTool tool;
  final PrepJob job;
  final BuildContext sheetContext;

  void _pick(BuildContext context) {
    final store = JobScope.of(context);
    final step = store.nextStep(job)!;
    // Pencere kapanınca bu satırın bağlamı gider; mini oyun gezginin
    // bağlamında açılır.
    final navigatorContext = Navigator.of(sheetContext).context;
    Navigator.of(sheetContext).pop();
    if (step.interactive) {
      openHeating(
        navigatorContext,
        magistralName: job.magistralName,
        onDone: () => store.startStep(job.magistralName, tool),
      );
    } else {
      store.startStep(job.magistralName, tool);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final reason = store.whyNot(tool, job);
    final step = store.nextStep(job);
    final ok = reason == null;
    final row = Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: ok ? AppColors.kobaltSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: ok ? AppColors.kobalt : AppColors.line, width: ok ? 2 : 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.magistralName,
                  style: AppText.body(size: 15, weight: FontWeight.w700, color: ok ? AppColors.ink : AppColors.inkMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  ok ? 'Sıradaki adım: ${step!.label} · ${step.minutes} dk' : reason,
                  style: AppText.label(size: 12, color: ok ? AppColors.accentText : AppColors.inkMuted),
                ),
              ],
            ),
          ),
          if (ok) ...[
            const SizedBox(width: AppSpace.sm),
            Icon(
              step!.interactive ? Icons.touch_app_rounded : Icons.play_circle_fill_rounded,
              size: 28,
              color: AppColors.kobalt,
            ),
          ],
        ],
      ),
    );
    if (!ok) return row;
    return Semantics(
      button: true,
      label: '${job.magistralName}: ${step!.label} başlat',
      excludeSemantics: true,
      child: GestureDetector(onTap: () => _pick(context), child: row),
    );
  }
}
