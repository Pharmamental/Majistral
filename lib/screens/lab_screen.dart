import 'dart:async';

import 'package:flutter/material.dart';

import '../data/lab_tools.dart';
import '../logic/job_store.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/counter_top.dart';
import '../widgets/job_status.dart';
import '../widgets/tool_sheet.dart';

/// Laboratuvar: sahip olunan aletlerin durduğu oda (Tuğrul, 2026-10-27). Oyuncu
/// bir alete basar, açılan pencerede reçeteyi seçer ve o reçetenin sıradaki
/// adımı başlar. Bir alet aynı anda tek reçetede çalışır. Kart aletin
/// durumunu gösterir: çalışıyor (hangi reçete, hangi adım, kalan süre) ya da
/// boş; şimdi kullanabilecek bir reçete varsa kart vurgulu.
class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
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
    final tools = labTools();
    final busy = tools.where((t) => store.busyWith(t) != null).length;
    final waiting = store.jobs.where(store.needsAction).length;
    final status = [
      if (busy > 0) '$busy alet çalışıyor',
      if (waiting > 0) '$waiting reçete seni bekliyor',
    ].join(' · ');

    // Başlık duvarda, aletler gri laboratuvar tezgâhında (Tuğrul, 2026-10-27); liste tezgâhın
    // içinde kayar, tezgâh çizgisi yerinde kalır.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: TabHeader(title: 'Laboratuvar', subtitle: status.isEmpty ? 'Bütün aletler boş' : status),
        ),
        Expanded(
          child: LabBench(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpace.lg,
                AppSpace.lg,
                AppSpace.lg,
                AppSpace.x3 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                LayoutBuilder(
                  builder: (context, c) {
                    final columns = c.maxWidth >= 520 ? 3 : 2;
                    final width = (c.maxWidth - AppSpace.md * (columns - 1)) / columns;
                    return Wrap(
                      spacing: AppSpace.md,
                      runSpacing: AppSpace.md,
                      children: [
                        for (final t in tools) SizedBox(width: width, child: _ToolCard(tool: t)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool});

  final LabTool tool;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final busy = store.busyWith(tool);
    // Bu aletle şimdi başlatılabilecek reçeteler.
    final ready = [for (final j in store.jobs) if (!store.isReady(j) && store.whyNot(tool, j) == null) j];
    final highlight = busy != null || ready.isNotEmpty;
    final run = busy?.run;
    final total = run == null ? 1 : run.end.difference(run.start).inMilliseconds;
    final done = run == null ? 0 : store.now().difference(run.start).inMilliseconds;
    final card = Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: highlight ? AppColors.kobalt : AppColors.line, width: highlight ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: highlight ? AppColors.kobaltSoft : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(tool.imagePath, width: 44, height: 44),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(child: Text(tool.name, style: AppText.title(size: 17))),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          if (busy != null) ...[
            Text(
              busy.job.magistralName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(size: 13, weight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpace.xs),
            Row(
              children: [
                Expanded(child: Text(run!.label, style: AppText.label(size: 12))),
                Text(formatRemaining(run.end.difference(store.now())), style: AppText.timer(size: 14)),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: (done / total).clamp(0.0, 1.0),
                backgroundColor: AppColors.kobaltSoft,
                valueColor: const AlwaysStoppedAnimation(AppColors.kobalt),
              ),
            ),
          ] else if (ready.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.accentText),
                const SizedBox(width: AppSpace.xs),
                Expanded(
                  child: Text(
                    '${ready.length} reçete bu aleti bekliyor',
                    style: AppText.label(size: 12, color: AppColors.accentText),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.inkMuted),
                const SizedBox(width: AppSpace.xs),
                Text('Boş', style: AppText.label()),
              ],
            ),
        ],
      ),
    );
    return Semantics(
      button: true,
      label: tool.name,
      child: GestureDetector(onTap: () => openToolSheet(context, tool), child: card),
    );
  }
}
