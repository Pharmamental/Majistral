import 'dart:math';

import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../logic/quality.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
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

  Future<void> _start() async {
    final result = evaluatePreparation(
      order: widget.order,
      selectedChemicals: _selected,
      stepOrder: _sequence,
    );
    await JobScope.of(context).start(widget.order, result);
  }

  bool get _canStart => _selected.isNotEmpty && _sequence.length == _stepPool.length;

  @override
  Widget build(BuildContext context) {
    final job = JobScope.of(context).jobFor(widget.order.magistralName);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Hazırlama'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpace.lg),
                children: [
                  _RecipeSummary(order: widget.order),
                  const SizedBox(height: AppSpace.lg),
                  if (job == null) ...[
                    _sectionTitle('1. Kimyasalları seç'),
                    Wrap(
                      spacing: AppSpace.sm,
                      runSpacing: AppSpace.sm,
                      children: [
                        for (final name in _shelf)
                          FilterChip(
                            label: Text(name),
                            selected: _selected.contains(name),
                            onSelected: (_) => _toggleChemical(name),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.xl),
                    _sectionTitle('2. Adımlara sırayla dokun'),
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
                    const SizedBox(height: AppSpace.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kiremit,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _canStart ? _start : null,
                        child: const Text('Başlat'),
                      ),
                    ),
                  ] else
                    _RunningPanel(job: job, onBack: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppFont.title,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${order.doctorName} · ${order.doctorBranch}',
            style: TextStyle(fontSize: AppFont.caption, color: Colors.black.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Rp. ${order.magistralName}',
            style: const TextStyle(
              fontSize: AppFont.title,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            order.chemicals.join(' · '),
            style: TextStyle(fontSize: AppFont.body, color: Colors.black.withValues(alpha: 0.7)),
          ),
        ],
      ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
        decoration: BoxDecoration(
          color: placed ? AppColors.kiremit : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.kiremit.withValues(alpha: placed ? 1 : 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (placed) ...[
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Text(
                  '$position',
                  style: const TextStyle(
                    fontSize: AppFont.caption,
                    fontWeight: FontWeight.w800,
                    color: AppColors.kiremit,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: AppFont.body,
                fontWeight: FontWeight.w700,
                color: placed ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RunningPanel extends StatelessWidget {
  const _RunningPanel({required this.job, required this.onBack});

  final PrepJob job;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          JobStatus(job: job),
          const SizedBox(height: AppSpace.md),
          Text(
            'Uygulamayı kapatsan da hazırlık sürer. Hazır olunca Reçeteler ekranından teslim et.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppFont.body, color: Colors.black.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: AppSpace.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kiremit,
                foregroundColor: Colors.white,
              ),
              onPressed: onBack,
              child: const Text('Reçetelere Dön'),
            ),
          ),
        ],
      ),
    );
  }
}
