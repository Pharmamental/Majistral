import 'package:flutter/material.dart';

import '../data/formulary.dart';
import '../data/market_items.dart';
import '../logic/job_store.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'grow_panel.dart';
import 'prescription_card.dart';

/// Reçetenin ayrıntısı: her maddenin miktarı ve görevi, ürünün ne işe yaradığı
/// ve neyde kullanıldığı. Reçete kartındaki "Reçete" düğmesi açar. Duvardaki
/// gelen reçete fişi [onTake] ile açar: altta "Al" düğmesi çıkar.
///
/// Reçete kâğıdı dokunulan yerden ([from]) büyüyerek ortaya gelir, koçan
/// delikli. "Al"a basınca kâğıt [takeTo]'ya (tezgâh) iner.
Future<void> openRecipe(
  BuildContext context,
  PrescriptionOrder order, {
  required Rect from,
  VoidCallback? onTake,
  Rect Function()? takeTo,
}) {
  // Rafta yetmeyen maddelerin paket bedeli; Al'da kasadan ödenir, para yetmezse
  // depo veresiye verir (2026-10-29).
  final store = JobScope.of(context);
  final missing = onTake == null ? 0 : store.missingCost(order);
  return openGrowing<void>(
    context,
    from: from,
    shape: const PrescriptionStubBorder(),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xl, AppSpace.lg, AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Rp.', style: AppText.display(size: 22, color: AppColors.accentText)),
                      const SizedBox(width: AppSpace.sm),
                      Expanded(child: Text(order.magistralName, style: AppText.title(size: 20))),
                    ],
                  ),
                  Text(
                    '${order.doctorName} (${order.doctorBranch}), hasta ${order.patientName}',
                    style: AppText.label(size: 12),
                  ),
                  const SizedBox(height: AppSpace.lg),
                  _Section(
                    title: 'İçindekiler',
                    child: Column(
                      children: [
                        for (final (n, i) in order.ingredients.indexed) ...[
                          if (n > 0) const Divider(height: 1, color: AppColors.line),
                          _IngredientRow(ingredient: i),
                        ],
                        if (order.note != null) ...[
                          const Divider(height: 1, color: AppColors.line),
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpace.sm, bottom: AppSpace.xs),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentText),
                                const SizedBox(width: AppSpace.xs),
                                Expanded(
                                  child: Text(
                                    order.note!,
                                    style: AppText.label(size: 12, color: AppColors.accentText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpace.md),
                  _Section(
                    title: 'Hazırlık',
                    child: Wrap(
                      // İki satırlı ad olsa da ikonlar ve oklar aynı hizada kalır.
                      runSpacing: AppSpace.sm,
                      children: [
                        for (final (n, s) in order.steps.indexed) ...[
                          if (n > 0)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(AppSpace.xs, AppSpace.xs, AppSpace.xs, 0),
                              child: Text('›', style: AppText.display(size: 22, color: AppColors.inkMuted)),
                            ),
                          _StepChip(step: s),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpace.md),
                  _Section(
                    title: 'Ne işe yarar',
                    child: Text(order.purpose, style: AppText.body(size: 14)),
                  ),
                  const SizedBox(height: AppSpace.md),
                  _Section(
                    title: 'Neyde kullanılır',
                    child: Text(order.usedFor, style: AppText.body(size: 14)),
                  ),
                  if (_shelfLife(order) case final shelf?) ...[
                    const SizedBox(height: AppSpace.md),
                    _Section(
                      title: 'Raf ömrü',
                      child: Text(shelf, style: AppText.body(size: 14)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          if (onTake != null) ...[
            if (missing > 0) ...[
              Text(
                store.coins >= missing
                    ? "Rafta eksik madde var. Al'a basınca eksik paketleri $missing paraya alırsın."
                    : 'Rafta eksik madde var. Kasan yetmediği için ecza deposu veresiye verir, borcu ilk teslimden keser.',
                textAlign: TextAlign.center,
                style: AppText.label(size: 12, color: AppColors.ink),
              ),
              const SizedBox(height: AppSpace.sm),
            ],
            ChunkyButton(
              label: 'Al',
              icon: Icons.add_rounded,
              onPressed: () {
                final route = ModalRoute.of(sheetContext);
                if (route is GrowRoute && takeTo != null) route.origin = takeTo();
                Navigator.of(sheetContext).pop();
                onTake();
              },
            ),
            const SizedBox(height: AppSpace.sm),
          ],
          ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheetContext).pop()),
        ],
      ),
    ),
  );
}

/// Reçetenin formül kitabındaki karşılığının raf ömrü ve saklama koşulu.
String? _shelfLife(PrescriptionOrder order) =>
    formulary.where((f) => f.name == order.formula).firstOrNull?.shelfLife;

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpace.md, AppSpace.sm, AppSpace.md, AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.title(size: 16)),
          const SizedBox(height: AppSpace.xs),
          child,
        ],
      ),
    );
  }
}

/// Hazırlık şeridinde bir adım: ikonu ve altında adı.
class _StepChip extends StatelessWidget {
  const _StepChip({required this.step});

  final PrescriptionStep step;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Image.asset(step.imagePath, width: 40, height: 40),
          const SizedBox(height: AppSpace.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              step.label.replaceAll(' ', '\n'),
              textAlign: TextAlign.center,
              style: AppText.label(size: 11, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// Madde adı ve altında marketteki görevi; sağda reçetede yazan miktar.
class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final role = chemicalRole(ingredient.name);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ingredient.name, style: AppText.body(size: 14, weight: FontWeight.w600)),
                if (role != null) Text(role, style: AppText.label(size: 12)),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Text(
            ingredient.written,
            style: AppText.body(
              size: 14,
              weight: FontWeight.w600,
            ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }
}
