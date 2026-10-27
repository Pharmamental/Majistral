import 'dart:async';

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../logic/schedule.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/job_status.dart';
import '../widgets/heating_sheet.dart';
import '../widgets/station_action.dart';

/// Laboratuvar: istasyonların durduğu oda. Her hazırlık adımı bir istasyonda
/// çalışır; bir istasyon aynı anda tek iş yapar. Kart istasyonun durumunu
/// gösterir: boş, çalışıyor (hangi iş, hangi adım, kalan süre) ve sıradakiler.
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
    final states = {for (final s in LabStation.values) s: store.station(s)};
    final busy = states.values.where((s) => s.busy).length;
    final waiting = store.jobs.where(store.needsAction).length;
    final status = [
      if (busy > 0) '$busy istasyon çalışıyor',
      if (waiting > 0) '$waiting iş seni bekliyor',
    ].join(' · ');

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpace.x3),
      children: [
        TabHeader(
          title: 'Laboratuvar',
          subtitle: status.isEmpty ? 'Bütün istasyonlar boş' : status,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: LayoutBuilder(
            builder: (context, c) {
              final columns = c.maxWidth >= 520 ? 3 : 2;
              final width = (c.maxWidth - AppSpace.md * (columns - 1)) / columns;
              return Wrap(
                spacing: AppSpace.md,
                runSpacing: AppSpace.md,
                children: [
                  for (final s in LabStation.values)
                    SizedBox(width: width, child: _StationCard(station: s, state: states[s]!)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard({required this.station, required this.state});

  final LabStation station;
  final StationState state;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final slot = state.slot;
    // Bu istasyonda ısıtması bitmiş, oyuncunun sıcaklığı ayarlamasını bekleyen iş.
    final awaiting = [
      for (final j in store.jobs)
        if (store.needsAction(j) && j.slots.last.station == station) j,
    ];
    final highlight = state.busy || awaiting.isNotEmpty;
    final total = slot == null ? 1 : slot.end.difference(slot.start).inMilliseconds;
    final done = slot == null ? 0 : store.now().difference(slot.start).inMilliseconds;
    final card = Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: highlight ? AppColors.kiremit : AppColors.line, width: highlight ? 2 : 1),
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
                  color: highlight ? AppColors.kiremitSoft : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(station.imagePath, width: 44, height: 44),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(child: Text(station.label, style: AppText.title(size: 17))),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          if (slot != null) ...[
            Text(
              state.job!.magistralName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(size: 13, weight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpace.xs),
            Row(
              children: [
                Expanded(child: Text(slot.label, style: AppText.label(size: 12))),
                Text(
                  formatRemaining(slot.end.difference(store.now())),
                  style: AppText.timer(size: 14),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: (done / total).clamp(0.0, 1.0),
                backgroundColor: AppColors.kiremitSoft,
                valueColor: const AlwaysStoppedAnimation(AppColors.kiremit),
              ),
            ),
          ] else if (awaiting.isNotEmpty) ...[
            Text(
              awaiting.first.magistralName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(size: 13, weight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpace.xs),
            Row(
              children: [
                const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.accentText),
                const SizedBox(width: AppSpace.xs),
                Expanded(child: Text(stationAction(station).button, style: AppText.label(size: 12, color: AppColors.accentText))),
              ],
            ),
          ] else
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.inkMuted),
                const SizedBox(width: AppSpace.xs),
                Text('Boş', style: AppText.label()),
              ],
            ),
          if (state.queued > 0) ...[
            const SizedBox(height: AppSpace.sm),
            Text('Sırada ${state.queued} adım', style: AppText.label(size: 12, color: AppColors.accentText)),
          ],
          if (station == LabStation.isitma && awaiting.isEmpty) ...[
            const SizedBox(height: AppSpace.sm),
            Text('Dokun: ısıtma denemesi', style: AppText.label(size: 12)),
          ],
        ],
      ),
    );
    if (awaiting.isNotEmpty) {
      return Semantics(
        button: true,
        label: stationAction(station).button,
        child: GestureDetector(
          onTap: () => openStationAction(context, station, awaiting.first.magistralName),
          child: card,
        ),
      );
    }
    if (station != LabStation.isitma) return card;
    return Semantics(
      button: true,
      label: 'Isıtma denemesini aç',
      child: GestureDetector(onTap: () => openHeating(context), child: card),
    );
  }
}
