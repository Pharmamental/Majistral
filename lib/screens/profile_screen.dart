import 'package:flutter/material.dart';

import '../data/formulary.dart';
import '../data/lab_tools.dart';
import '../data/orders.dart';
import '../logic/job_store.dart';
import '../logic/profile_stats.dart';
import '../models/formula.dart';
import '../models/prep_job.dart';
import '../theme/tokens.dart';
import 'home_screen.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/grow_panel.dart';
import '../widgets/market_widgets.dart';
import '../widgets/mastery_medal.dart';

enum _ProfileTab {
  ustalik('Ustalık'),
  koleksiyon('Koleksiyon'),
  defter('Defter');

  const _ProfileTab(this.label);

  final String label;
}

/// Profil sekmesi (Tuğrul, 2026-10-28, "Diploma + ustalık + koleksiyon"):
/// duvarda çerçeveli eczacılık diploması (ad, eczane, teslim sayısıyla yükselen
/// unvan); altta Ustalık (denenen teknikler, kaç kez ve kademesi: bronz,
/// gümüş, altın), Koleksiyon (oyunda hazırlanabilen formüllerden
/// hazırladıkların, kategori kategori) ve Defter (eczanedeki majistral defteri
/// gibi: son 3 teslim, tamamı bir dokunuşla). Hepsi teslim kaydından hesaplanır.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileTab _tab = _ProfileTab.ustalik;

  @override
  Widget build(BuildContext context) {
    // Diploma ve vitrin rafı sayfayla birlikte kayar, sekmeler üstte sabit kalır
    // (2026-10-28): raf eklenince duvar ekranın yarısını alıyordu.
    return ColoredBox(
      color: AppColors.background,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          const SliverToBoxAdapter(
            child: ColoredBox(
              color: AppColors.wall,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Unvan yalnız diplomada yazar; başlıkta tekrar etmez (2026-10-28).
                  TabHeader(title: 'Profil', subtitle: 'Diploman ve ilerlemen'),
                  Padding(
                    padding: EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                    child: _Diploma(),
                  ),
                  _ShowcaseShelf(),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabsHeader(
              PillTabs<_ProfileTab>(
                values: _ProfileTab.values,
                selected: _tab,
                labelOf: (t) => t.label,
                onChanged: (t) => setState(() => _tab = t),
              ),
            ),
          ),
        ],
        body: switch (_tab) {
          _ProfileTab.ustalik => const _MasteryList(),
          _ProfileTab.koleksiyon => const _CollectionList(),
          _ProfileTab.defter => const _Ledger(),
        },
      ),
    );
  }
}

/// Sekmeler: sayfa kayarken üstte sabit durur.
class _TabsHeader extends SliverPersistentHeaderDelegate {
  _TabsHeader(this.tabs);

  final Widget tabs;

  // PillTabs: 44 dokunma alanı + 2 × 4 iç boşluk + 2 × 1 çerçeve = 54.
  static const double _height = AppSpace.md + 54 + AppSpace.md + 1;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: AppColors.wall,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.md), child: tabs),
          const Divider(height: 1, color: AppColors.line),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabsHeader old) => true;
}

/// Ürün türüne göre kap: yarı katılar porselen eczane kavanozunda, toz,
/// kapsül ve sıvılar amber cam şişede.
String _containerOf(String magistralName) {
  final order = prescriptionOrders.where((o) => o.magistralName == magistralName).firstOrNull;
  final category = formulary.where((f) => f.name == order?.formula).firstOrNull?.category;
  return switch (category) {
    FormulaCategory.merhem || FormulaCategory.krem || FormulaCategory.jel || null =>
      'assets/images/ikon/ikon_vitrin_albarello.png',
    _ => 'assets/images/ikon/ikon_vitrin_sise.png',
  };
}

/// Vitrin rafı (Tuğrul, 2026-10-28): diplomanın altında ceviz rafta üç yer.
/// Oyuncu teslim ettiği ürünlerden seçip koyar (Chess.com, Steam, Clash
/// Royale'deki "kendi seçtiğin vitrin"). Boş yere basınca seçme penceresi.
class _ShowcaseShelf extends StatelessWidget {
  const _ShowcaseShelf();

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: Text('Vitrin', style: AppText.title(size: 16)),
        ),
        const SizedBox(height: AppSpace.sm),
        // Ceviz dolap içi: beyaz porselen kavanoz açık duvarda kayboluyordu.
        Container(
          color: AppColors.counterPlanks[1],
          padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.sm, AppSpace.xl, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < JobStore.showcaseSize; i++)
                Expanded(child: _ShowcaseSlot(slot: i, product: store.showcase[i])),
            ],
          ),
        ),
        // Raf tahtası: tezgâhla aynı ceviz, açık üst yüz ve koyu ön yüz.
        Container(height: 6, color: AppColors.counterLip),
        Container(height: 10, color: AppColors.counterEdge),
      ],
    );
  }
}

class _ShowcaseSlot extends StatelessWidget {
  const _ShowcaseSlot({required this.slot, required this.product});

  final int slot;
  final String? product;

  @override
  Widget build(BuildContext context) {
    final name = product;
    return Semantics(
      button: true,
      label: name == null ? 'Vitrinde boş yer, ürün koy' : 'Vitrinde $name',
      excludeSemantics: true,
      child: Builder(
        builder: (slotContext) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openShowcasePicker(slotContext, slot, from: rectOf(slotContext)),
          child: SizedBox(
            height: 112,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (name != null) ...[
                  Image.asset(_containerOf(name), width: 64, height: 64),
                  const SizedBox(height: AppSpace.xs),
                  Text(
                    name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label(size: 11, color: AppColors.surface),
                  ),
                ] else
                  // Boş yer: kesik çizgili değil, silik daire ve artı; duvar sınırındaki boş yer gibi.
                  Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: AppSpace.lg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.counterGrainLight, width: 2),
                    ),
                    child: const Icon(Icons.add_rounded, color: AppColors.counterGrainLight),
                  ),
                const SizedBox(height: AppSpace.xs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Vitrine ürün seçme penceresi: teslim edilen ürünler, en yeniden. Dolu yerde
/// "Raftan kaldır" da çıkar.
Future<void> _openShowcasePicker(BuildContext context, int slot, {required Rect from}) {
  final store = JobScope.of(context);
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) {
      final current = store.showcase[slot];
      final counts = <String, int>{};
      for (final d in store.deliveries.reversed) {
        counts[d.magistralName] = (counts[d.magistralName] ?? 0) + 1;
      }
      return Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Vitrine ne koyalım?', style: AppText.title(size: 20)),
            const SizedBox(height: AppSpace.xs),
            Text(
              counts.isEmpty
                  ? 'Rafa yalnız teslim ettiğin ürünler konur. Önce bir reçete hazırlayıp teslim et.'
                  : 'Teslim ettiğin ürünlerden birini seç.',
              style: AppText.body(size: 14, color: AppColors.inkMuted),
            ),
            const SizedBox(height: AppSpace.md),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final MapEntry(key: name, value: n) in counts.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.sm),
                      child: Material(
                        color: name == current ? AppColors.kobaltSoft : AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.paper),
                          side: BorderSide(
                            color: name == current ? AppColors.kobalt : AppColors.line,
                            width: name == current ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            store.setShowcase(slot, name);
                            Navigator.of(sheetContext).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpace.sm),
                            child: Row(
                              children: [
                                Image.asset(_containerOf(name), width: 40, height: 40),
                                const SizedBox(width: AppSpace.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: AppText.body(size: 14, weight: FontWeight.w700)),
                                      Text('$n kez teslim edildi', style: AppText.label(size: 12)),
                                    ],
                                  ),
                                ),
                                // Seçili olan yalnız renkle değil, onay işaretiyle de belli.
                                if (name == current)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.kobalt),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.md),
            if (current != null) ...[
              ChunkyButton.secondary(
                label: 'Raftan kaldır',
                onPressed: () {
                  store.setShowcase(slot, null);
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: AppSpace.sm),
            ],
            ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheetContext).pop()),
          ],
        ),
      );
    },
  );
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
    final named = store.playerName.isNotEmpty;
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
                  child: named
                      ? Text(
                          store.playerName.characters.first.toUpperCase(),
                          style: AppText.title(size: 28, color: AppColors.accentText),
                        )
                      : const Icon(Icons.person_rounded, size: 32, color: AppColors.accentText),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ECZACILIK DİPLOMASI', style: AppText.label(size: 11)),
                      // Ad yazılmadıysa yer tutucu; unvanla karışmasın diye varsayılan ad yok.
                      Text(
                        named ? store.playerName : 'Adını yaz',
                        style: AppText.title(size: 22, color: named ? AppColors.ink : AppColors.inkMuted),
                      ),
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
            // Ortalama yıldız yok: tek teslimden ortalama yanıltır, yıldızı da yalnız acele düşürür.
            Text(
              delivered == 0 ? 'İlk reçeteni bekliyor' : '$delivered reçete teslim edildi',
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

/// Ustalık: oyuncunun denediği teknikler, kaç kez yapıldığı ve kademesi.
/// Denenmemiş teknikler satır satır "yapılmadı" diye dizilmez; tek cümleyle
/// söylenir. Hiç teslim yoksa ilk adım gösterilir (NN/g boş durum ilkesi).
class _MasteryList extends StatelessWidget {
  const _MasteryList();

  @override
  Widget build(BuildContext context) {
    final deliveries = JobScope.of(context).deliveries;
    if (deliveries.isEmpty) return const _EmptyState();
    final all = labTools();
    final started = [for (final t in all) if (stepCount(t.name, deliveries) > 0) t];
    final rest = all.length - started.length;
    return ListView(
      padding: _listPadding(context),
      children: [
        Text(
          'Denediğin teknikler. Tekrar ettikçe bronz, gümüş ve altın olur.',
          style: AppText.body(size: 13, color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpace.md),
        for (final t in started) ...[
          _MasteryRow(name: t.name, image: t.imagePath, count: stepCount(t.name, deliveries)),
          const SizedBox(height: AppSpace.sm),
        ],
        if (rest > 0) ...[
          const SizedBox(height: AppSpace.xs),
          Text(
            'Laboratuvarda henüz denemediğin $rest teknik daha var.',
            style: AppText.body(size: 13, color: AppColors.inkMuted),
          ),
        ],
      ],
    );
  }
}

/// Hiç teslim yokken: ne olduğunu söyler, ilk adıma götürür.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _listPadding(context),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpace.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.paper),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('İlk reçeteni bekliyoruz', style: AppText.title(size: 18)),
              const SizedBox(height: AppSpace.xs),
              Text(
                'Duvardan bir reçete al, laboratuvarda hazırla ve teslim et. '
                'Kullandığın teknikler burada görünür.',
                style: AppText.body(size: 14),
              ),
              const SizedBox(height: AppSpace.lg),
              ChunkyButton(label: 'Reçetelere git', onPressed: () => HomeScreen.showTab(context, 0)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MasteryRow extends StatelessWidget {
  const _MasteryRow({required this.name, required this.image, required this.count});

  final String name;
  final String image;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tier = tierIndex(count);
    final next = tier + 1 < tiers.length ? tiers[tier + 1] : null;
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          MasteryMedal(tier: tier, image: image),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.body(size: 15, weight: FontWeight.w700)),
                Text(
                  next == null ? '${tiers[tier].title} · en üst kademe' : '${next.title} için ${next.from - count} kez daha',
                  style: AppText.label(size: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('×$count', style: AppText.title(size: 16)),
              Text(tiers[tier].title, style: AppText.label(size: 12, color: AppColors.ink)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Koleksiyon: oyunda hazırlanabilen formüllerden teslim edilenler, kategori
/// kategori. Oyunda henüz reçetesi olmayan kategori "0/50" değil "Yakında"
/// yazar; ulaşılamayacak hedef gösterilmez (2026-10-28).
class _CollectionList extends StatelessWidget {
  const _CollectionList();

  @override
  Widget build(BuildContext context) {
    final prepared = preparedFormulas(JobScope.of(context).deliveries, prescriptionOrders);
    final playable = playableFormulas(prescriptionOrders);
    return ListView(
      padding: _listPadding(context),
      children: [
        Text(
          'Oyunda hazırlayabildiğin ${playable.length} formülden teslim ettiklerin. Formül kitabındaki '
          'öteki ${formulary.length - playable.length} formül oyuna geldikçe buraya eklenir.',
          style: AppText.body(size: 13, color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpace.md),
        for (final c in FormulaCategory.values) ...[
          _CategoryRow(category: c, prepared: prepared, playable: playable),
          const SizedBox(height: AppSpace.sm),
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.prepared, required this.playable});

  final FormulaCategory category;
  final Set<String> prepared;
  final Set<String> playable;

  @override
  Widget build(BuildContext context) {
    final items = [for (final f in formulasOf(category)) if (playable.contains(f.name)) f.name];
    final done = items.where(prepared.contains).length;
    final soon = items.isEmpty;
    final content = Padding(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category.title,
                  style: AppText.title(size: 16, color: soon ? AppColors.inkMuted : AppColors.ink),
                ),
              ),
              if (soon)
                Text('Yakında', style: AppText.label(size: 13))
              else ...[
                Text('$done/${items.length}', style: AppText.label(size: 14, color: AppColors.ink)),
                const SizedBox(width: AppSpace.xs),
                Text('›', style: AppText.display(size: 22, color: AppColors.accentText)),
              ],
            ],
          ),
          if (!soon) ...[
            const SizedBox(height: AppSpace.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: done / items.length,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: const AlwaysStoppedAnimation(AppColors.success),
              ),
            ),
          ],
        ],
      ),
    );
    return Semantics(
      button: !soon,
      child: Material(
        color: soon ? AppColors.surfaceMuted : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.paper),
          side: const BorderSide(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: soon
            ? content
            : Builder(
                builder: (rowContext) => InkWell(
                  onTap: () => _openCategory(rowContext, category, items, prepared, from: rectOf(rowContext)),
                  child: content,
                ),
              ),
      ),
    );
  }
}

/// Kategorinin oyundaki formülleri: hazırlananlar onaylı, kalanlar boş daire.
Future<void> _openCategory(
  BuildContext context,
  FormulaCategory category,
  List<String> items,
  Set<String> prepared, {
  required Rect from,
}) {
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
                for (final name in items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
                    child: Row(
                      children: [
                        Icon(
                          prepared.contains(name) ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                          size: 20,
                          color: prepared.contains(name) ? AppColors.success : AppColors.line,
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(child: Text(name, style: AppText.body(size: 14))),
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

/// Reçete defteri (Tuğrul, 2026-10-28): eczanedeki majistral defteri gibi.
/// Profilde son 3 teslim; altında "Defterin tamamı" bütün geçmişi güne göre
/// gruplanmış açar. Kayıt hiçbir teslimi silmez.
class _Ledger extends StatelessWidget {
  const _Ledger();

  static const _recent = 3;

  @override
  Widget build(BuildContext context) {
    final deliveries = JobScope.of(context).deliveries;
    if (deliveries.isEmpty) return const _EmptyState();
    final newest = deliveries.reversed.toList();
    return ListView(
      padding: _listPadding(context),
      children: [
        Text('Son teslimlerin', style: AppText.title(size: 16)),
        const SizedBox(height: AppSpace.sm),
        _LedgerPage(entries: newest.take(_recent).toList(), withDay: true),
        if (newest.length > _recent) ...[
          const SizedBox(height: AppSpace.md),
          Builder(
            builder: (buttonContext) => ChunkyButton.secondary(
              label: 'Defterin tamamı (${newest.length} reçete) ›',
              onPressed: () => _openLedger(buttonContext, newest, from: rectOf(buttonContext)),
            ),
          ),
        ],
      ],
    );
  }
}

/// Defter sayfası: kâğıtta satır satır teslimler.
class _LedgerPage extends StatelessWidget {
  const _LedgerPage({required this.entries, this.withDay = false});

  final List<Delivery> entries;

  /// Satırda günü de yaz (profildeki kısa liste); tam defterde gün başlıkta.
  final bool withDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          for (final (i, d) in entries.indexed) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.line),
            _LedgerRow(delivery: d, withDay: withDay),
          ],
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.delivery, required this.withDay});

  final Delivery delivery;
  final bool withDay;

  @override
  Widget build(BuildContext context) {
    final at = delivery.at;
    final time = '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
    // Kayıttaki reçete oyundan çıkarıldıysa hekim yazılmaz.
    final doctor = prescriptionOrders.where((o) => o.magistralName == delivery.magistralName).firstOrNull?.doctorName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
      child: Row(
        children: [
          SizedBox(
            width: withDay ? 64 : 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (withDay) Text(dayLabel(at, JobScope.of(context).now()), style: AppText.label(size: 12)),
                Text(time, style: AppText.label(size: 12)),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(delivery.magistralName, style: AppText.body(size: 14, weight: FontWeight.w700)),
                if (doctor != null) Text(doctor, style: AppText.label(size: 12)),
              ],
            ),
          ),
          Semantics(
            label: '${delivery.stars} yıldız',
            excludeSemantics: true,
            child: Row(
              children: [
                for (var s = 0; s < 3; s++)
                  Icon(
                    s < delivery.stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 16,
                    color: s < delivery.stars ? AppColors.star : AppColors.line,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];

/// Gün adı: "Bugün", "Dün" ya da "26 Ekim" (başka yılsa yıl da yazar).
String dayLabel(DateTime at, DateTime now) {
  final day = DateTime(at.year, at.month, at.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Bugün';
  if (diff == 1) return 'Dün';
  return '${at.day} ${_months[at.month - 1]}${at.year == now.year ? '' : ' ${at.year}'}';
}

/// Defterin tamamı: en yeniden eskiye, güne göre gruplanmış.
Future<void> _openLedger(BuildContext context, List<Delivery> newest, {required Rect from}) {
  final now = JobScope.of(context).now();
  final days = <String, List<Delivery>>{};
  for (final d in newest) {
    days.putIfAbsent(dayLabel(d.at, now), () => []).add(d);
  }
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Reçete defteri', style: AppText.title(size: 20)),
          Text('${newest.length} reçete', style: AppText.label(size: 12)),
          const SizedBox(height: AppSpace.md),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final MapEntry(key: day, value: entries) in days.entries) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpace.sm, bottom: AppSpace.xs),
                    child: Text(day, style: AppText.title(size: 15)),
                  ),
                  _LedgerPage(entries: entries),
                ],
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
