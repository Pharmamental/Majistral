import 'package:flutter/material.dart';

import '../data/formulary.dart';
import '../data/lab_tools.dart';
import '../data/orders.dart';
import '../logic/job_store.dart';
import '../logic/profile_stats.dart';
import '../models/formula.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/grow_panel.dart';
import '../widgets/market_widgets.dart';

enum _ProfileTab { ustalik, koleksiyon }

/// Profil sekmesi (Tuğrul, 2026-10-28, "Diploma + ustalık + koleksiyon"):
/// duvarda çerçeveli eczacılık diploması (ad, eczane, teslim sayısıyla yükselen
/// unvan); altta Ustalık (laboratuvardaki her adımı kaç kez, kaç yıldızla
/// yaptın: neye çalışman gerektiğini söyler) ve Koleksiyon (formül kitabından
/// hazırladıkların, kategori kategori). Hepsi teslim kaydından hesaplanır.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileTab _tab = _ProfileTab.ustalik;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabHeader(title: 'Profil', subtitle: ranks[rankIndex(store.deliveries.length)].title),
              const Padding(
                padding: EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                child: _Diploma(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                child: PillTabs<_ProfileTab>(
                  values: _ProfileTab.values,
                  selected: _tab,
                  labelOf: (t) => t == _ProfileTab.ustalik ? 'Ustalık' : 'Koleksiyon',
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: ColoredBox(
            color: AppColors.background,
            child: _tab == _ProfileTab.ustalik ? const _MasteryList() : const _CollectionList(),
          ),
        ),
      ],
    );
  }
}

/// Duvarda asılı diploma: ceviz çerçeve, içinde kâğıt.
class _Diploma extends StatelessWidget {
  const _Diploma();

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final delivered = store.deliveries.length;
    final rank = rankIndex(delivered);
    final next = rank + 1 < ranks.length ? ranks[rank + 1] : null;
    // Avatar halkası unvanla değişir; durum yalnız renkle değil, unvan yazısıyla da söylenir.
    const rings = [AppColors.line, AppColors.kobalt, AppColors.success, AppColors.star];
    return Container(
      padding: const EdgeInsets.all(AppSpace.sm),
      decoration: BoxDecoration(
        color: AppColors.counterPlanks.first,
        borderRadius: BorderRadius.circular(AppRadius.paperInner),
        border: Border.all(color: AppColors.counterEdge, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.xs, AppSpace.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.paperInner),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.kobaltSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: rings[rank], width: 4),
                  ),
                  child: Text(
                    store.playerName.characters.first.toUpperCase(),
                    style: AppText.title(size: 28, color: AppColors.accentText),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ECZACILIK DİPLOMASI', style: AppText.label(size: 11)),
                      Text(store.playerName, style: AppText.title(size: 22)),
                      Text(store.pharmacyName, style: AppText.body(size: 14, color: AppColors.inkMuted)),
                      Text(ranks[rank].title, style: AppText.label(size: 13, color: AppColors.accentText)),
                    ],
                  ),
                ),
                Builder(
                  builder: (buttonContext) => IconButton(
                    tooltip: 'Adları değiştir',
                    onPressed: () => _openRename(buttonContext, from: rectOf(buttonContext)),
                    icon: const Icon(Icons.edit_rounded, color: AppColors.inkMuted),
                    style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              delivered == 0
                  ? 'Henüz teslim yok'
                  : '$delivered reçete teslim edildi · ★ ${formatStars(averageStars(store.deliveries))}',
              style: AppText.body(size: 13, weight: FontWeight.w600),
            ),
            if (next != null)
              Text('${next.title} unvanına ${next.from - delivered} reçete', style: AppText.label(size: 12)),
          ],
        ),
      ),
    );
  }
}

/// Diplomadaki adları değiştiren pencere.
Future<void> _openRename(BuildContext context, {required Rect from}) =>
    openGrowing<void>(context, from: from, builder: (_) => const _RenamePanel());

class _RenamePanel extends StatefulWidget {
  const _RenamePanel();

  @override
  State<_RenamePanel> createState() => _RenamePanelState();
}

class _RenamePanelState extends State<_RenamePanel> {
  late final JobStore _store = JobScope.of(context);
  late final _player = TextEditingController(text: _store.playerName);
  late final _pharmacy = TextEditingController(text: _store.pharmacyName);

  @override
  void dispose() {
    _player.dispose();
    _pharmacy.dispose();
    super.dispose();
  }

  InputDecoration _field(String label) => InputDecoration(
        labelText: label,
        labelStyle: AppText.label(size: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.paperInner)),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Diploma', style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.lg),
          TextField(controller: _player, maxLength: 24, style: AppText.body(), decoration: _field('Adın')),
          const SizedBox(height: AppSpace.sm),
          TextField(controller: _pharmacy, maxLength: 32, style: AppText.body(), decoration: _field('Eczanenin adı')),
          const SizedBox(height: AppSpace.lg),
          ChunkyButton(
            label: 'Kaydet',
            onPressed: () {
              _store.rename(player: _player.text, pharmacy: _pharmacy.text);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppSpace.sm),
          ChunkyButton.secondary(label: 'Vazgeç', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

EdgeInsets _listPadding(BuildContext context) => EdgeInsets.fromLTRB(
      AppSpace.lg,
      AppSpace.lg,
      AppSpace.lg,
      AppSpace.x3 + MediaQuery.paddingOf(context).bottom,
    );

/// Ustalık: laboratuvardaki her adım, kaç teslimde yapıldı ve ortalama yıldız.
class _MasteryList extends StatelessWidget {
  const _MasteryList();

  @override
  Widget build(BuildContext context) {
    final deliveries = JobScope.of(context).deliveries;
    return ListView(
      padding: _listPadding(context),
      children: [
        Text(
          'Her adımı kaç kez yaptın, ortalama kaç yıldız aldın. Az yıldızlı adım, çalışman gereken adım.',
          style: AppText.body(size: 13, color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpace.md),
        for (final t in labTools()) ...[
          _MasteryRow(name: t.name, image: t.imagePath, mastery: masteryOf(t.name, deliveries)),
          const SizedBox(height: AppSpace.sm),
        ],
      ],
    );
  }
}

class _MasteryRow extends StatelessWidget {
  const _MasteryRow({required this.name, required this.image, required this.mastery});

  final String name;
  final String image;
  final Mastery mastery;

  @override
  Widget build(BuildContext context) {
    final done = mastery.count > 0;
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(AppSpace.xs),
            decoration: const BoxDecoration(color: AppColors.iconWell, shape: BoxShape.circle),
            child: Image.asset(image),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(child: Text(name, style: AppText.body(size: 15, weight: FontWeight.w700))),
          if (done) ...[
            Text('${mastery.count} kez', style: AppText.label(size: 13, color: AppColors.ink)),
            const SizedBox(width: AppSpace.sm),
            const Icon(Icons.star_rounded, size: 18, color: AppColors.star),
            Text(formatStars(mastery.stars), style: AppText.label(size: 13, color: AppColors.ink)),
          ] else
            Text('Henüz yapılmadı', style: AppText.label(size: 13)),
        ],
      ),
    );
  }
}

/// Koleksiyon: formül kitabından hazırlananlar, kategori kategori.
class _CollectionList extends StatelessWidget {
  const _CollectionList();

  @override
  Widget build(BuildContext context) {
    final prepared = preparedFormulas(JobScope.of(context).deliveries, prescriptionOrders);
    return ListView(
      padding: _listPadding(context),
      children: [
        Text(
          'Formül kitabındaki ${formulary.length} majistralden teslim ettiklerin.',
          style: AppText.body(size: 13, color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpace.md),
        for (final c in FormulaCategory.values) ...[
          _CategoryRow(category: c, prepared: prepared),
          const SizedBox(height: AppSpace.sm),
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.prepared});

  final FormulaCategory category;
  final Set<String> prepared;

  @override
  Widget build(BuildContext context) {
    final items = formulasOf(category);
    final done = items.where((f) => prepared.contains(f.name)).length;
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.paper),
          side: const BorderSide(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Builder(
          builder: (rowContext) => InkWell(
            onTap: () => _openCategory(rowContext, category, prepared, from: rectOf(rowContext)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(category.title, style: AppText.title(size: 16))),
                      Text('$done/${items.length}', style: AppText.label(size: 14, color: AppColors.ink)),
                      const SizedBox(width: AppSpace.xs),
                      Text('›', style: AppText.display(size: 22, color: AppColors.accentText)),
                    ],
                  ),
                  const SizedBox(height: AppSpace.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: items.isEmpty ? 0 : done / items.length,
                      backgroundColor: AppColors.surfaceMuted,
                      valueColor: const AlwaysStoppedAnimation(AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kategorinin formülleri: hazırlananlar onaylı, kalanlar boş daire.
Future<void> _openCategory(BuildContext context, FormulaCategory category, Set<String> prepared, {required Rect from}) {
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(category.title, style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.sm),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final f in formulasOf(category))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
                    child: Row(
                      children: [
                        Icon(
                          prepared.contains(f.name) ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                          size: 20,
                          color: prepared.contains(f.name) ? AppColors.success : AppColors.line,
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(child: Text(f.name, style: AppText.body(size: 14))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheetContext).pop()),
        ],
      ),
    ),
  );
}
