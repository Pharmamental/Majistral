import 'dart:math';

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../logic/quality.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/job_status.dart';

/// Hazırlama ekranı (tasarım belgesi, bölüm 5): oyuncu reçeteye bakıp raftan
/// kimyasalları seçer, adımlara sırayla dokunarak hazırlama sırasını kurar ve
/// "Başlat"a basar. İş gerçek zamanda sürer (bölüm 7); hazır olunca teslimde
/// 1–3 yıldız ve hatayı anlatan kısa açıklamalar gösterilir.
class PreparationScreen extends StatefulWidget {
  const PreparationScreen({super.key, required this.order});

  final PrescriptionOrder order;

  @override
  State<PreparationScreen> createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  late final List<String> _shelf;
  late final List<String> _stepPool;
  final Set<String> _selected = {};
  final List<String> _sequence = [];
  final Map<ToolKind, String> _tools = {};

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    _shelf = [...order.chemicals, ...order.distractors]..sort();
    _stepPool = _scrambledSteps(order);
  }

  // Adımlar karışık sunulur; aynı reçete her açılışta aynı karışık sırayla
  // gelir ki oyuncu ezberden değil, bilgiden ilerlesin ve testler sabit kalsın.
  static List<String> _scrambledSteps(PrescriptionOrder order) {
    final correct = [for (final s in order.steps) s.label];
    final scrambled = [...correct]..shuffle(Random(order.magistralName.length));
    var same = true;
    for (var i = 0; i < correct.length; i++) {
      if (scrambled[i] != correct[i]) same = false;
    }
    return same ? correct.reversed.toList() : scrambled;
  }

  void _toggleChemical(String name) {
    setState(() => _selected.contains(name) ? _selected.remove(name) : _selected.add(name));
  }

  void _tapStep(String label) {
    setState(() {
      final index = _sequence.indexOf(label);
      if (index == -1) {
        _sequence.add(label);
      } else {
        // Sıradaki bir adıma tekrar dokunmak onu ve sonrakileri geri alır.
        _sequence.removeRange(index, _sequence.length);
      }
    });
  }

  void _pickTool(ToolKind kind, String option) {
    setState(() => _tools[kind] = option);
  }

  bool get _toolsDone => widget.order.tools.every((req) => _tools.containsKey(req.kind));

  Future<void> _start() async {
    final result = evaluatePreparation(
      order: widget.order,
      selectedChemicals: _selected,
      stepOrder: _sequence,
      selectedTools: _tools,
    );
    await JobScope.of(context).start(widget.order, result);
  }

  bool get _canStart => _selected.isNotEmpty && _toolsDone && _sequence.length == _stepPool.length;

  String get _startHint {
    if (_selected.isEmpty) return 'Önce raftan kimyasal seç';
    if (!_toolsDone) return 'Aletlerini seç';
    final left = _stepPool.length - _sequence.length;
    if (left > 0) return 'Sıraya $left adım daha koy';
    return 'Hazırsın';
  }

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
                        const SizedBox(height: AppSpace.lg),
                        _Section(
                          number: 1,
                          title: 'Kimyasalları seç',
                          hint: 'Reçetedekileri raftan al. Rafta başka maddeler de var.',
                          child: Wrap(
                            spacing: AppSpace.sm,
                            runSpacing: AppSpace.sm,
                            children: [
                              for (final name in _shelf)
                                _ShelfChip(
                                  label: name,
                                  selected: _selected.contains(name),
                                  onTap: () => _toggleChemical(name),
                                ),
                            ],
                          ),
                        ),
                        if (widget.order.tools.isNotEmpty) ...[
                          const SizedBox(height: AppSpace.lg),
                          _Section(
                            number: 2,
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
                          number: widget.order.tools.isEmpty ? 2 : 3,
                          title: 'Hazırlama sırası',
                          hint: 'Adımlara doğru sırayla dokun. Yanlışsa tekrar dokunup geri al.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SequenceSlots(total: _stepPool.length, sequence: _sequence),
                              const SizedBox(height: AppSpace.lg),
                              Wrap(
                                spacing: AppSpace.sm,
                                runSpacing: AppSpace.sm,
                                children: [
                                  for (final label in _stepPool)
                                    _StepChip(
                                      label: label,
                                      position: _sequence.indexOf(label) + 1,
                                      onTap: () => _tapStep(label),
                                    ),
                                ],
                              ),
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
                Text(order.chemicals.join(' · '), style: AppText.body(weight: FontWeight.w600)),
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

/// Sıranın boş ve dolu yuvaları: oyuncu kaç adım kaldığını tek bakışta görür.
class _SequenceSlots extends StatelessWidget {
  const _SequenceSlots({required this.total, required this.sequence});

  final int total;
  final List<String> sequence;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          Expanded(
            child: Container(
              height: 52,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
              decoration: BoxDecoration(
                color: i < sequence.length ? AppColors.kiremitSoft : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpace.md),
                border: Border.all(color: i < sequence.length ? AppColors.kiremit : AppColors.line),
              ),
              child: i < sequence.length
                  ? Text(
                      sequence[i],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppText.label(size: 11, color: AppColors.ink),
                    )
                  : Text('${i + 1}', style: AppText.title(size: 16, color: AppColors.line)),
            ),
          ),
          if (i != total - 1) const SizedBox(width: AppSpace.xs),
        ],
      ],
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.label, required this.position, required this.onTap});

  final String label;

  /// Sıradaki yeri (1'den başlar); 0 ise henüz sıraya konmadı.
  final int position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final placed = position > 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
        decoration: BoxDecoration(
          color: placed ? AppColors.kiremitDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.kiremit, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (placed) ...[
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Text('$position', style: AppText.label(size: 11, color: AppColors.accentText)),
              ),
              const SizedBox(width: AppSpace.sm),
            ],
            Text(
              label,
              style: AppText.body(
                size: 14,
                weight: FontWeight.w600,
                color: placed ? Colors.white : AppColors.accentText,
              ),
            ),
          ],
        ),
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
