import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/patient_question.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'grow_panel.dart';

/// Testler teslim akışını sorusuz sınar; soru penceresi test/patient_test.dart'ta.
bool patientQuestionsEnabled = true;

/// Hasta soruyor (Tuğrul, 2026-10-30): teslimden sonra hasta ilacı sorar, oyuncu
/// 3 şıktan birini seçer. Reçete kapalıdır. Doğruysa bahşiş bırakır, yanlışsa
/// ceza yoktur, doğrusu gösterilir ve hasta günler sonra yeniden sorar.
Future<void> askPatient(BuildContext context, JobStore store, PatientQuestion question, {required Rect from}) =>
    openGrowing<void>(
      context,
      from: from,
      builder: (sheet) => _PatientSheet(store: store, question: question),
    );

class _PatientSheet extends StatefulWidget {
  const _PatientSheet({required this.store, required this.question});

  final JobStore store;
  final PatientQuestion question;

  @override
  State<_PatientSheet> createState() => _PatientSheetState();
}

class _PatientSheetState extends State<_PatientSheet> {
  int? _chosen;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final chosen = _chosen;
    final right = chosen == q.answer;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
                child: const Icon(Icons.person_rounded, color: AppColors.ink),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.returning ? '${q.order.patientName} yeniden geldi' : '${q.order.patientName} soruyor',
                      style: AppText.title(size: 18),
                    ),
                    Text(q.order.magistralName, style: AppText.label(size: 13, color: AppColors.ink)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Text(q.ask, style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.lg),
          for (final (i, option) in q.options.indexed) ...[
            _AnswerTile(
              text: option,
              state: chosen == null
                  ? _Answer.open
                  : i == q.answer
                      ? _Answer.right
                      : i == chosen
                          ? _Answer.wrong
                          : _Answer.off,
              onTap: chosen == null ? () => _answer(i) : null,
            ),
            const SizedBox(height: AppSpace.sm),
          ],
          if (chosen != null) ...[
            const SizedBox(height: AppSpace.sm),
            Text(
              right ? 'Doğru bildin. Hasta ${widget.store.patientTip} para bahşiş bıraktı.' : 'Bu sefer olmadı.',
              style: AppText.body(size: 15, weight: FontWeight.w700, color: right ? AppColors.hazirText : AppColors.bekliyorText),
            ),
            // Madde sorusunda açıklama doğru şıkla aynı; ikinci kez yazılmaz.
            if (q.explain != q.options[q.answer]) ...[
              const SizedBox(height: AppSpace.xs),
              Text(q.explain, style: AppText.body(size: 14, color: AppColors.ink)),
            ],
            if (!right) ...[
              const SizedBox(height: AppSpace.xs),
              Text('Hasta bunu yarın yeniden soracak.', style: AppText.body(size: 14, color: AppColors.ink)),
            ],
            const SizedBox(height: AppSpace.lg),
            ChunkyButton(label: 'Tamam', onPressed: () => Navigator.of(context).pop()),
          ],
        ],
      ),
    );
  }

  void _answer(int i) {
    setState(() => _chosen = i);
    widget.store.answerPatient(widget.question, i);
  }
}

enum _Answer { open, right, wrong, off }

/// Cevap şıkkı; basılan şey olduğu için tam hap. Durum renkle birlikte ikonla da belli.
class _AnswerTile extends StatelessWidget {
  const _AnswerTile({required this.text, required this.state, required this.onTap});

  final String text;
  final _Answer state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (fill, edge, icon) = switch (state) {
      _Answer.open => (AppColors.surface, AppColors.kobalt, null),
      _Answer.right => (AppColors.hazirSoft, AppColors.hazirText, Icons.check_circle_rounded),
      _Answer.wrong => (AppColors.bekliyorSoft, AppColors.bekliyorText, Icons.cancel_rounded),
      _Answer.off => (AppColors.surface, AppColors.line, null),
    };
    return Material(
      color: fill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: edge, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
            child: Row(
              children: [
                Expanded(child: Text(text, style: AppText.body(size: 14, color: AppColors.ink))),
                if (icon != null) ...[
                  const SizedBox(width: AppSpace.sm),
                  Icon(icon, size: 22, color: edge),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
