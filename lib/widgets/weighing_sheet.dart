import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../logic/quality.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import 'chunky_button.dart';

/// Terazide tartım: oyuncu reçeteden her maddenin kaç gram olacağını hesaplar
/// ve yazar. "Tart"a basınca doğru/yanlış hemen görünür; yanlış tartım bir
/// yıldız götürür ama iş yine devam eder (ürün her zaman satılır).
Future<void> openWeighing(BuildContext context, PrescriptionOrder order) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
    ),
    builder: (sheetContext) => _WeighingSheet(order: order, store: JobScope.of(context)),
  );
}

class _WeighingSheet extends StatefulWidget {
  const _WeighingSheet({required this.order, required this.store});

  final PrescriptionOrder order;
  final JobStore store;

  @override
  State<_WeighingSheet> createState() => _WeighingSheetState();
}

class _WeighingSheetState extends State<_WeighingSheet> {
  late final Map<String, TextEditingController> _fields = {
    for (final i in widget.order.ingredients) i.name: TextEditingController(),
  };

  /// "Tart"a basıldıktan sonra her maddenin tartılan miktarı.
  Map<String, double?>? _weighed;

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _allFilled => _fields.values.every((c) => parseGrams(c.text) != null);

  void _weigh() {
    FocusScope.of(context).unfocus();
    setState(() => _weighed = {for (final e in _fields.entries) e.key: parseGrams(e.value.text)});
  }

  Future<void> _continue() async {
    final navigator = Navigator.of(context);
    await widget.store.completeAction(
      widget.order.magistralName,
      mistakes: evaluateWeighing(widget.order, _weighed!),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final weighed = _weighed;
    final allRight = weighed != null && evaluateWeighing(order, weighed).isEmpty;
    return Padding(
      // Klavye açılınca alanlar altında kalmasın.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(AppSpace.xs),
                    decoration: BoxDecoration(
                      color: AppColors.kiremitSoft,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Image.asset(LabStation.terazi.imagePath),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tartım', style: AppText.title(size: 22)),
                        Text(order.magistralName, style: AppText.label(size: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                order.batchNote ?? 'Reçeteye göre her maddenin kaç gram olacağını hesapla.',
                style: AppText.body(size: 14, weight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpace.md),
              for (final i in order.ingredients)
                _Row(
                  ingredient: i,
                  controller: _fields[i.name]!,
                  weighed: weighed?[i.name],
                  checked: weighed != null,
                  onChanged: () => setState(() {}),
                ),
              const SizedBox(height: AppSpace.md),
              if (weighed == null)
                ChunkyButton(
                  label: 'Tart',
                  icon: Icons.scale_rounded,
                  onPressed: _allFilled ? _weigh : null,
                )
              else ...[
                Text(
                  allRight ? 'Tartım doğru!' : order.calcHint,
                  style: AppText.body(
                    size: 14,
                    weight: allRight ? FontWeight.w700 : FontWeight.w400,
                    color: allRight ? AppColors.success : AppColors.ink,
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                allRight
                    ? ChunkyButton.success(label: 'Devam', icon: Icons.check_circle_rounded, onPressed: _continue)
                    : ChunkyButton(label: 'Devam', onPressed: _continue),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.ingredient,
    required this.controller,
    required this.weighed,
    required this.checked,
    required this.onChanged,
  });

  final Ingredient ingredient;
  final TextEditingController controller;
  final double? weighed;
  final bool checked;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final right = weighedRight(ingredient, weighed);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ingredient.name, style: AppText.body(size: 15, weight: FontWeight.w600)),
                Text('Reçetede ${ingredient.written}', style: AppText.label(size: 12)),
                if (checked && !right)
                  Text(
                    'Doğrusu ${formatGrams(ingredient.grams)} g',
                    style: AppText.label(size: 12, color: AppColors.accentText),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          SizedBox(
            width: 112,
            child: TextField(
              key: Key('tartim-${ingredient.name}'),
              controller: controller,
              enabled: !checked,
              onChanged: (_) => onChanged(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              style: AppText.body(size: 16, weight: FontWeight.w600),
              decoration: InputDecoration(
                isDense: true,
                suffixText: 'g',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  borderSide: const BorderSide(color: AppColors.line),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          SizedBox(
            width: 24,
            child: checked
                ? Icon(
                    right ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: right ? AppColors.success : AppColors.kiremit,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
