import 'package:flutter/material.dart';

import '../data/formulary.dart';
import '../models/formula.dart';
import '../models/prescription.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/grow_panel.dart';

/// Formüller sekmesi (2026-10-28): altı kategoride majistral formülleri. Önce
/// kategoriler, kategoriye basınca formüller; formüle basınca pencere açılır:
/// ne işe yarar, hangi maddeler, nasıl yapılır, kaynaklar. Arama bütün
/// kategorilerde ad, kullanım ve maddeye bakar.
class FormularyScreen extends StatefulWidget {
  const FormularyScreen({super.key});

  @override
  State<FormularyScreen> createState() => _FormularyScreenState();
}

class _FormularyScreenState extends State<FormularyScreen> {
  FormulaCategory? _category;
  String _query = '';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Formula> get _results {
    final q = _query.trim().toLowerCase();
    return [
      for (final f in formulary)
        if (f.name.toLowerCase().contains(q) ||
            f.use.toLowerCase().contains(q) ||
            f.ingredients.any((i) => i.name.toLowerCase().contains(q)))
          f,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabHeader(
                title: 'Formüller',
                subtitle: '${formulary.length} majistral, ${FormulaCategory.values.length} kategori',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                child: _SearchField(controller: _search, onChanged: (v) => setState(() => _query = v)),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        Expanded(child: ColoredBox(color: AppColors.background, child: _content())),
      ],
    );
  }

  Widget _content() {
    final padding = EdgeInsets.fromLTRB(
      AppSpace.lg,
      AppSpace.lg,
      AppSpace.lg,
      AppSpace.x3 + MediaQuery.paddingOf(context).bottom,
    );
    if (_query.trim().isNotEmpty) {
      final results = _results;
      return ListView(
        padding: padding,
        children: [
          Text('${results.length} sonuç', style: AppText.label()),
          const SizedBox(height: AppSpace.sm),
          for (final f in results) ...[_FormulaTile(formula: f, showCategory: true), const SizedBox(height: AppSpace.md)],
        ],
      );
    }
    final category = _category;
    if (category == null) {
      return ListView(
        padding: padding,
        children: [
          Text(
            'Kategoriler farmasötik şekle göre (USP ve Avrupa Farmakopesi). Kırmızı ve yeşil reçeteli '
            'ilaçlar, hormonlar ve tehlikeli ilaçlar yok.',
            style: AppText.body(size: 13, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.md),
          for (final c in FormulaCategory.values) ...[
            _CategoryTile(category: c, onTap: () => setState(() => _category = c)),
            const SizedBox(height: AppSpace.md),
          ],
        ],
      );
    }
    final items = formulasOf(category);
    return ListView(
      padding: padding,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _category = null),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.accentText),
            label: Text('Kategoriler', style: AppText.label(size: 14, color: AppColors.accentText)),
            style: TextButton.styleFrom(minimumSize: const Size(48, 44), shape: const StadiumBorder()),
          ),
        ),
        Text(category.title, style: AppText.title(size: 24)),
        Text('${items.length} formül · ${category.definition}', style: AppText.label()),
        const SizedBox(height: AppSpace.md),
        for (final f in items) ...[_FormulaTile(formula: f), const SizedBox(height: AppSpace.md)],
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      borderSide: const BorderSide(color: AppColors.line),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppText.body(size: 15),
      decoration: InputDecoration(
        hintText: 'Formül ya da madde ara',
        hintStyle: AppText.body(size: 15, color: AppColors.inkMuted),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.inkMuted),
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpace.md),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.kobalt, width: 2)),
      ),
    );
  }
}

/// Bilgi kutusu: kâğıt gibi az yuvarlak, basılabilir.
class _Paper extends StatelessWidget {
  const _Paper({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.paper),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(AppSpace.lg), child: child),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final FormulaCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: _Paper(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.title, style: AppText.title(size: 18)),
                  const SizedBox(height: AppSpace.xs),
                  Text(category.definition, style: AppText.body(size: 13, color: AppColors.inkMuted)),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.md),
            Text('${formulasOf(category).length}', style: AppText.title(size: 18, color: AppColors.accentText)),
            const SizedBox(width: AppSpace.xs),
            Text('›', style: AppText.display(size: 24, color: AppColors.accentText)),
          ],
        ),
      ),
    );
  }
}

class _FormulaTile extends StatelessWidget {
  const _FormulaTile({required this.formula, this.showCategory = false});

  final Formula formula;
  final bool showCategory;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (tileContext) => _Paper(
        onTap: () => openFormula(tileContext, formula, from: rectOf(tileContext)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCategory) Text(formula.category.title, style: AppText.label(size: 12, color: AppColors.accentText)),
            Text(formula.name, style: AppText.title(size: 16)),
            const SizedBox(height: AppSpace.xs),
            Text(formula.use, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.body(size: 13)),
            const SizedBox(height: AppSpace.sm),
            Text(
              [for (final s in formula.steps) s.name].join(' › '),
              style: AppText.label(size: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formülün penceresi: ne işe yarar, maddeler, nasıl yapılır, kaynaklar.
Future<void> openFormula(BuildContext context, Formula formula, {required Rect from}) {
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formula.category.title, style: AppText.label(size: 12, color: AppColors.accentText)),
                  Text(formula.name, style: AppText.title(size: 20)),
                  const SizedBox(height: AppSpace.md),
                  _Section(title: 'Ne işe yarar', child: Text(formula.use, style: AppText.body(size: 14))),
                  const SizedBox(height: AppSpace.md),
                  _Section(
                    title: 'Hangi maddeler',
                    child: Column(
                      children: [
                        for (final (n, i) in formula.ingredients.indexed) ...[
                          if (n > 0) const Divider(height: 1, color: AppColors.line),
                          _IngredientLine(ingredient: i),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpace.md),
                  _Section(
                    title: 'Nasıl yapılır',
                    child: Column(
                      children: [
                        for (final (n, s) in formula.steps.indexed) _StepLine(number: n + 1, step: s),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpace.md),
                  _Section(
                    title: 'Kaynaklar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final id in formula.refs)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpace.xs),
                            child: Text(
                              '• ${referenceById[id]?.citation ?? id}',
                              style: AppText.label(size: 12, color: AppColors.ink),
                            ),
                          ),
                        Text(
                          'Taslak içerik: yayından önce öğretim üyesi onayından geçecek.',
                          style: AppText.label(size: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheetContext).pop()),
        ],
      ),
    ),
  );
}

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
        borderRadius: BorderRadius.circular(AppRadius.paperInner),
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

class _IngredientLine extends StatelessWidget {
  const _IngredientLine({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(ingredient.name, style: AppText.body(size: 14, weight: FontWeight.w600))),
          const SizedBox(width: AppSpace.md),
          Text(ingredient.written, style: AppText.body(size: 14, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Bir adım: ikon, sıra ve ad, altında bu formülde nasıl yapıldığı.
class _StepLine extends StatelessWidget {
  const _StepLine({required this.number, required this.step});

  final int number;
  final FormulaStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
            padding: const EdgeInsets.all(AppSpace.xs),
            child: Image.asset(stepIconPath(step.name)),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$number. ${step.name}', style: AppText.body(size: 14, weight: FontWeight.w700)),
                Text(step.how, style: AppText.body(size: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
