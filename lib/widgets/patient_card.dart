import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../models/patient_question.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'paper_tape.dart';

/// Testler teslim akışını sorusuz sınar; soru kartı test/patient_test.dart'ta.
bool patientQuestionsEnabled = true;

/// Hasta soruyor (Tuğrul, 2026-10-30): teslimden sonra hasta ilacı sorar, soru
/// sayfa değişmeden tezgâhta bantlı küçük bir kâğıtta çıkar ("yeni bir sayfa
/// açmayalım"). Reçete kapalıdır, oyuncu 3 şıktan birini seçer. Doğruysa bahşiş
/// bırakır, yanlışsa ceza yoktur, doğrusu gösterilir, hasta günler sonra döner.
class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.store, required this.question});

  final JobStore store;
  final PatientQuestion question;

  @override
  Widget build(BuildContext context) {
    final q = question;
    final chosen = store.pendingChoice;
    final right = chosen == q.answer;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.lg + MediaQuery.paddingOf(context).bottom,
      ),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xl, AppSpace.lg, AppSpace.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.paper),
              boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  q.returning ? '${q.order.patientName} yeniden geldi' : '${q.order.patientName} soruyor',
                  style: AppText.label(size: 13, color: AppColors.ink),
                ),
                Text(q.order.magistralName, style: AppText.label(size: 12, color: AppColors.inkMuted)),
                const SizedBox(height: AppSpace.sm),
                Text(q.ask, style: AppText.title(size: 18)),
                const SizedBox(height: AppSpace.md),
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
                    onTap: chosen == null ? () => store.answerPatient(q, i) : null,
                  ),
                  const SizedBox(height: AppSpace.sm),
                ],
                if (chosen != null) ...[
                  Text(
                    right ? 'Doğru bildin. Hasta ${store.patientTip} para bahşiş bıraktı.' : 'Bu sefer olmadı.',
                    style: AppText.body(
                      size: 14,
                      weight: FontWeight.w700,
                      color: right ? AppColors.hazirText : AppColors.bekliyorText,
                    ),
                  ),
                  // Madde sorusunda açıklama doğru şıkla aynı; ikinci kez yazılmaz.
                  if (q.explain != q.options[q.answer])
                    Text(q.explain, style: AppText.body(size: 13, color: AppColors.ink)),
                  if (!right) Text('Hasta bunu yarın yeniden soracak.', style: AppText.body(size: 13, color: AppColors.ink)),
                  const SizedBox(height: AppSpace.md),
                  ChunkyButton(label: 'Tamam', compact: true, onPressed: store.closePatient),
                ],
              ],
            ),
          ),
          const Positioned(top: -8, child: PaperTape(width: 36, height: 14)),
        ],
      ),
    );
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
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
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
