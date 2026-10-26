import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../logic/quality.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/job_status.dart';

/// Hazırlama ekranı (tasarım belgesi, bölüm 5): oyuncu reçeteye bakıp aletleri
/// seçer ve "Başlat"a basar. Adımların sırası oyuncuya sorulmaz, sabit
/// gösterilir (Tuğrul, 2026-10-27). İş gerçek zamanda sürer (bölüm 7); hazır olunca teslimde
/// 1–3 yıldız ve hatayı anlatan kısa açıklamalar gösterilir.
class PreparationScreen extends StatefulWidget {
  const PreparationScreen({super.key, required this.order});

  final PrescriptionOrder order;

  @override
  State<PreparationScreen> createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  final Map<ToolKind, String> _tools = {};

  void _pickTool(ToolKind kind, String option) {
    setState(() => _tools[kind] = option);
  }

  bool get _toolsDone => widget.order.tools.every((req) => _tools.containsKey(req.kind));

  Future<void> _start() async {
    final result = evaluatePreparation(order: widget.order, selectedTools: _tools);
    await JobScope.of(context).start(widget.order, result);
  }

  bool get _canStart => _toolsDone;

  String get _startHint => _toolsDone ? 'Hazırsın' : 'Aletlerini seç';

  // Öğrenme ekranı: sade, süs yok (Tasarım Rehberi, öğrenme modu). Birincil
  // aksiyon "Başlat" altta sabit, başparmak bölgesinde.
  @override
  Widget build(BuildContext context) {
    final job = JobScope.of(context).jobFor(widget.order.magistralName);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: 'Hazırlama', subtitle: widget.order.magistralName),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.sm, AppSpace.lg, AppSpace.xxl),
                children: job == null
                    ? [
                        _RecipeSummary(order: widget.order),
                        if (widget.order.tools.isNotEmpty) ...[
                          const SizedBox(height: AppSpace.lg),
                          _Section(
                            number: 1,
                            title: 'Aletleri seç',
                            hint: 'Her işin doğru aleti var. Yanlış alet ürünün kalitesini düşürür.',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final req in widget.order.tools) ...[
                                  Text(req.kind.label, style: AppText.label(color: AppColors.ink)),
                                  const SizedBox(height: AppSpace.sm),
                                  Wrap(
                                    spacing: AppSpace.sm,
                                    runSpacing: AppSpace.sm,
                                    children: [
                                      for (final option in req.kind.options)
                                        _ShelfChip(
                                          label: option,
                                          selected: _tools[req.kind] == option,
                                          onTap: () => _pickTool(req.kind, option),
                                        ),
                                    ],
                                  ),
                                  if (req != widget.order.tools.last) const SizedBox(height: AppSpace.lg),
                                ],
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpace.lg),
                        _Section(
                          number: widget.order.tools.isEmpty ? 1 : 2,
                          title: 'Hazırlama adımları',
                          hint: 'Bu reçete bu sırayla hazırlanır. Dokunmalı adımları sen yaparsın.',
                          child: Column(
                            children: [
                              for (final (i, step) in widget.order.steps.indexed) _StepRow(number: i + 1, step: step),
                            ],
                          ),
                        ),
                      ]
                    : [
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.12),
                        _RunningCard(job: job),
                      ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        child: job == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_startHint, style: AppText.label()),
                  const SizedBox(height: AppSpace.sm),
                  SizedBox(
                    width: double.infinity,
                    child: ChunkyButton(
                      label: 'Başlat',
                      icon: Icons.play_arrow_rounded,
                      onPressed: _canStart ? _start : null,
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: double.infinity,
                child: ChunkyButton.secondary(
                  label: 'Reçetelere Dön',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.md),
          child: child,
        ),
      ),
    );
  }
}

class _RecipeSummary extends StatelessWidget {
  const _RecipeSummary({required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rp.', style: AppText.display(size: 22, color: AppColors.kiremit)),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [for (final i in order.ingredients) '${i.name} ${i.written}'].join(' · '),
                  style: AppText.body(weight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpace.xs),
                Text('${order.doctorName} · ${order.doctorBranch}', style: AppText.label(size: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.number, required this.title, required this.hint, required this.child});

  final int number;
  final String title;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.kiremitDark,
                child: Text('$number', style: AppText.title(size: 15, color: Colors.white)),
              ),
              const SizedBox(width: AppSpace.sm),
              Text(title, style: AppText.title(size: 19)),
            ],
          ),
          const SizedBox(height: AppSpace.xs),
          Text(hint, style: AppText.body(size: 13, color: AppColors.inkMuted)),
          const SizedBox(height: AppSpace.lg),
          child,
        ],
      ),
    );
  }
}

/// Raf çipi. Seçim yalnız renkle değil, onay işaretiyle de gösterilir.
class _ShelfChip extends StatelessWidget {
  const _ShelfChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
          decoration: BoxDecoration(
            color: selected ? AppColors.kiremitSoft : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: selected ? AppColors.kiremit : AppColors.line, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 18,
                color: selected ? AppColors.kiremit : AppColors.line,
              ),
              const SizedBox(width: AppSpace.sm),
              Text(label, style: AppText.body(size: 14, weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sabit adım listesinde bir satır: sıra, adımın ikonu, adı, istasyonu, süresi.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.step});

  final int number;
  final PrescriptionStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text('$number', style: AppText.title(size: 16, color: AppColors.accentText)),
          ),
          Image.asset(step.imagePath, width: 44, height: 44),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.label, style: AppText.body(size: 15, weight: FontWeight.w600)),
                Text(step.station.label, style: AppText.label(size: 12)),
              ],
            ),
          ),
          if (step.interactive)
            Row(
              children: [
                const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.accentText),
                const SizedBox(width: AppSpace.xs),
                Text(step.minutes == 0 ? 'Sen yaparsın' : '${step.minutes} dk + sen', style: AppText.label(size: 12, color: AppColors.accentText)),
              ],
            )
          else
            Text('${step.minutes} dk', style: AppText.label(size: 12)),
        ],
      ),
    );
  }
}

class _RunningCard extends StatelessWidget {
  const _RunningCard({required this.job});

  final PrepJob job;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          JobStatus(job: job, large: true),
          const SizedBox(height: AppSpace.xl),
          Text(
            'Uygulamayı kapatsan da hazırlık sürer. Hazır olunca Reçeteler ekranından teslim et.',
            textAlign: TextAlign.center,
            style: AppText.body(size: 14, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
