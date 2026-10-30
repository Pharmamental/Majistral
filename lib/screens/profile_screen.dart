import 'package:flutter/material.dart';

import '../data/dried_plants.dart';
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
import '../widgets/counter_top.dart';
import '../widgets/grow_panel.dart';
import '../widgets/mastery_medal.dart';

/// Profil sekmesi (Tuğrul, 2026-10-28, "Diploma + ustalık + koleksiyon"):
/// duvarda çerçeveli eczacılık diploması (ad, eczane, teslim sayısıyla yükselen
/// unvan) ve vitrin; altında ceviz çekmece dolabı (Tuğrul, 2026-10-30, "Çekmece
/// dolabı"; dört seçenek bir sıraya sığmıyordu). Çekmeceler Ustalık (denenen
/// teknikler, kaç kez ve kademesi), Koleksiyon (oyunda hazırlanabilen
/// formüllerden hazırladıkların), Defter (eczanedeki majistral defteri gibi,
/// güne göre bütün teslimler) ve İstatistik; basınca yerinden pencere büyür.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Raf kenarı, iki sıra çekmece ve sayfanın altındaki boşluk (taşan havan için).
  static const double _chestHeight =
      CounterTop.lip + AppSpace.md + _drawerHeight * 2 + AppSpace.sm + AppSpace.x3;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return ColoredBox(
      color: AppColors.wall,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Unvan yalnız diplomada yazar; başlıkta tekrar etmez (2026-10-28).
                TabHeader(title: 'Profil', subtitle: 'Diploman ve ilerlemen', sign: TabSign.profil),
                SizedBox(height: AppSpace.lg),
                Padding(
                  padding: EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
                  child: _Diploma(),
                ),
                _ShowcaseShelf(),
              ],
            ),
          ),
          // Ceviz ekranın altına kadar uzanır; kısa ekranda sayfa kayar.
          SliverFillRemaining(
            hasScrollBody: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: _chestHeight + bottom),
              child: const CounterTop(child: _DrawerChest()),
            ),
          ),
        ],
      ),
    );
  }
}

const double _drawerHeight = 124;

/// Vitrinin altındaki dolap: dört çekmece, etiketlerinde tek cümlelik özet.
class _DrawerChest extends StatelessWidget {
  const _DrawerChest();

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final deliveries = store.deliveries;
    final tried = [for (final t in labTools()) if (stepCount(t.name, deliveries) > 0) t].length;
    final prepared = (unlockAll ? playableFormulas(prescriptionOrders) : preparedFormulas(deliveries, prescriptionOrders)).length;
    final empty = deliveries.isEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.md, AppSpace.md, AppSpace.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Drawer(
                title: 'Ustalık',
                note: empty ? 'Henüz teknik denemedin' : '$tried teknik denedin',
                face: AppColors.counterPlanks[2],
                onTap: (from) => _openMastery(context, from),
              ),
              const SizedBox(width: AppSpace.sm),
              _Drawer(
                title: 'Koleksiyon',
                note: '$prepared formül hazırladın',
                face: AppColors.counterPlanks[3],
                onTap: (from) => _openCollection(context, from),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              _Drawer(
                title: 'Defter',
                note: empty ? 'Henüz teslimin yok' : 'Son teslimin ${_dayLower(dayLabel(deliveries.last.at, store.now()))}',
                face: AppColors.counterPlanks[0],
                onTap: (from) => _openLedger(context, from),
              ),
              const SizedBox(width: AppSpace.sm),
              _Drawer(
                title: 'İstatistik',
                note: empty ? 'Henüz sayı yok' : '${daysPlayed(deliveries)} gün oynadın',
                face: AppColors.counterPlanks[1],
                onTap: (from) => _openStats(context, from),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Bugün" ve "Dün" cümle içinde küçük yazılır; tarih olduğu gibi kalır.
String _dayLower(String day) => day == 'Bugün' ? 'bugün' : day == 'Dün' ? 'dün' : day;

/// Çekmece: ceviz yüz, üstünde porselen etiket, altında pirinç topuz.
class _Drawer extends StatelessWidget {
  const _Drawer({required this.title, required this.note, required this.face, required this.onTap});

  final String title;
  final String note;
  final Color face;

  /// Çekmecenin ekrandaki yeriyle çağrılır; pencere oradan büyür.
  final void Function(Rect from) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        label: '$title. $note',
        excludeSemantics: true,
        child: Material(
          color: face,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.paperInner),
            side: const BorderSide(color: AppColors.counterGrain, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Builder(
            builder: (drawerContext) => InkWell(
              onTap: () => onTap(rectOf(drawerContext)),
              child: SizedBox(
                height: _drawerHeight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.md),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpace.sm),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: _brass),
                        ),
                        child: Column(
                          children: [
                            Text(title, style: AppText.title(size: 17), maxLines: 1),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(note, style: AppText.label(size: 12), maxLines: 1),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: _brass,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.counterEdge, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _brass = Color(0xFFB8924A);

/// Çekmeceden büyüyen pencere: başlık, kayan içerik, Kapat.
Future<void> _openDrawer(BuildContext context, Rect from, String title, WidgetBuilder content) {
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.md),
          Flexible(child: content(sheetContext)),
          const SizedBox(height: AppSpace.lg),
          ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheetContext).pop()),
        ],
      ),
    ),
  );
}

Future<void> _openMastery(BuildContext context, Rect from) =>
    _openDrawer(context, from, 'Ustalık', (_) => _MasteryList(page: context));

Future<void> _openCollection(BuildContext context, Rect from) =>
    _openDrawer(context, from, 'Koleksiyon', (_) => const _CollectionList());

Future<void> _openStats(BuildContext context, Rect from) =>
    _openDrawer(context, from, 'İstatistik', (_) => _Stats(page: context));

/// Vitrin rafı (Tuğrul, 2026-10-28): diplomanın altında ceviz rafta üç yer.
/// Oyuncu fanusta bitki kurularından seçip koyar (Chess.com, Steam, Clash
/// Royale'deki "kendi seçtiğin vitrin"); rafta ilaç durmaz ("ilaç koymak çok iyi
/// değil"). Boş yere basınca seçme penceresi.
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
        // Ceviz dolap: fanuslar havada duruyordu (Tuğrul, 2026-10-28); şimdi
        // doğrudan raf tahtasına oturur, altlarında gölge, adları rafın ön
        // yüzündeki kâğıt etikette.
        Stack(
          children: [
            const Positioned.fill(child: _ShelfCabinet()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
              child: Row(
                children: [
                  for (var i = 0; i < JobStore.showcaseSize; i++)
                    Expanded(child: _ShowcaseSlot(slot: i, product: store.showcase[i])),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Vitrin dolabının ölçüleri: içerisi, raf tahtasının üst yüzü, ön yüzü.
const double _cabinetInside = 124, _shelfTop = 8, _shelfFront = 26;

/// Dolabın kendisi: üstü kararan ceviz iç duvar, iki yanda dikme, açık üst
/// yüzlü raf tahtası ve koyu ön yüz.
class _ShelfCabinet extends StatelessWidget {
  const _ShelfCabinet();

  @override
  Widget build(BuildContext context) {
    // İç duvar fanus tabanından (#60402A) koyu: aynı tonda taban kayboluyor,
    // fanus havada duruyor gibi görünüyordu.
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF26170D), AppColors.counterGrain, AppColors.counterEdge],
                stops: [0, .45, 1],
              ),
              border: Border.symmetric(vertical: BorderSide(color: Color(0xFF5A3A26), width: 10)),
            ),
          ),
        ),
        Container(
          height: _shelfTop,
          decoration: const BoxDecoration(
            color: AppColors.counterLip,
            border: Border(top: BorderSide(color: AppColors.counterGrainLight, width: 1.5)),
          ),
        ),
        Container(height: _shelfFront, color: AppColors.counterEdge),
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
      label: name == null ? 'Vitrinde boş yer, fanus koy' : 'Vitrinde $name fanusu',
      excludeSemantics: true,
      child: Builder(
        builder: (slotContext) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openShowcasePicker(slotContext, slot, from: rectOf(slotContext)),
          child: Column(
            children: [
              SizedBox(
                height: _cabinetInside,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    if (name != null) ...[
                      // Tahtaya değen gölge: fanus rafta durur, havada değil.
                      Positioned(
                        bottom: -3,
                        child: Container(
                          width: 66,
                          height: 9,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.elliptical(33, 4.5)),
                            gradient: RadialGradient(
                              colors: [AppColors.counterEdge.withValues(alpha: .85), AppColors.counterEdge.withValues(alpha: 0)],
                            ),
                          ),
                        ),
                      ),
                      // Görselin altında 16/288'lik boşluk var; aşağı kaydırılınca
                      // taban doğrudan tahtaya oturur.
                      Transform.translate(
                        offset: const Offset(0, 92 * 16 / 288),
                        child: Image.asset(driedPlantNamed(name)!.imagePath, width: 92, height: 92),
                      ),
                    ] else
                      // Boş yer: silik daire ve artı, rafın üstünde.
                      Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: AppSpace.md),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.counterGrainLight, width: 2),
                        ),
                        child: const Icon(Icons.add_rounded, color: AppColors.counterGrainLight),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: _shelfTop),
              SizedBox(
                height: _shelfFront,
                child: Center(child: name == null ? null : _ShelfLabel(name)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rafın ön yüzüne iki pirinç çiviyle tutturulmuş kâğıt etiket: fanusun adı.
class _ShelfLabel extends StatelessWidget {
  const _ShelfLabel(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    const pin = SizedBox(
      width: 4,
      height: 4,
      child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFB8924A), shape: BoxShape.circle)),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EAD6),
        borderRadius: BorderRadius.circular(AppRadius.paperInner / 2),
        boxShadow: const [BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 1.5)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          pin,
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.label(size: 11, color: AppColors.ink),
            ),
          ),
          const SizedBox(width: 5),
          pin,
        ],
      ),
    );
  }
}

/// Vitrine fanus seçme penceresi. Dolu yerde "Raftan kaldır" da çıkar. Fanusu
/// açık ya da 5 çiçeği biriken bitkiler önce, seçilebilir; ötekiler kilitli,
/// soluk ve kaç çiçeği olduğunu yazar (2026-10-29). Her fanusun oyun etkisi yazar.
Future<void> _openShowcasePicker(BuildContext context, int slot, {required Rect from}) {
  final store = JobScope.of(context);
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) {
      final current = store.showcase[slot];
      final garden = store.garden;
      // "grown": konabilecek fanuslar (açık ya da çiçeği hazır).
      final grown = {
        for (final p in driedPlants)
          if (garden.canShow(p.name)) p.name,
      };
      // Önce sıradanlar, sonra orta, en sonda nadirler (Tuğrul, 2026-10-30); kademede açıklar üstte.
      final plants = [
        for (final tier in [1, 2, 3]) ...[
          ...driedPlants.where((p) => p.tier == tier && grown.contains(p.name)),
          ...driedPlants.where((p) => p.tier == tier && !grown.contains(p.name)),
        ],
      ];
      return Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Vitrine ne koyalım?', style: AppText.title(size: 20)),
            const SizedBox(height: AppSpace.xs),
            Text(
              grown.isEmpty
                  ? 'Bir fanus için o bitkiden 3 ila 5 çiçek gerekir. Çiçekleri bahçede '
                      'yetiştirirsin.'
                  : 'Rafa koyacağın fanusu seç. Yeni bir fanus o bitkinin çiçeklerini harcar. '
                      'Aynı gruptan iki fanus koyarsan yalnız güçlü olanı işe yarar.',
              style: AppText.body(size: 14, color: AppColors.inkMuted),
            ),
            const SizedBox(height: AppSpace.md),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final DriedPlant(:name, :latin, :imagePath, :effectText, :fanusCost) in plants)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.sm),
                      child: Opacity(
                        opacity: grown.contains(name) ? 1 : 0.55,
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
                          onTap: grown.contains(name)
                              ? () {
                                  store.setShowcase(slot, name);
                                  Navigator.of(sheetContext).pop();
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpace.sm),
                            child: Row(
                              children: [
                                Image.asset(imagePath, width: 48, height: 48),
                                const SizedBox(width: AppSpace.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: AppText.body(size: 14, weight: FontWeight.w700)),
                                      Text(latin, style: AppText.label(size: 12)),
                                      Text(effectText, style: AppText.label(size: 12, color: AppColors.ink)),
                                    ],
                                  ),
                                ),
                                // Seçili olan yalnız renkle değil, onay işaretiyle de belli;
                                // kilitli olan kilitle ve çiçek sayacıyla (Tuğrul, 2026-10-30, "1/4").
                                if (name == current)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.kobalt)
                                else if (!grown.contains(name)) ...[
                                  Text(
                                    '${garden.flowers[name] ?? 0}/$fanusCost',
                                    style: AppText.body(size: 14, weight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: AppSpace.xs),
                                  const Icon(Icons.lock_rounded, color: AppColors.inkMuted),
                                ],
                              ],
                            ),
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
              delivered == 0 ? 'İlk reçeteni bekliyor' : '$delivered reçete teslim ettin',
              style: AppText.body(size: 13, weight: FontWeight.w600),
            ),
            if (next != null)
              Text('${next.title} olmana ${next.from - delivered} reçete kaldı', style: AppText.label(size: 12)),
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

/// Ustalık: oyuncunun denediği teknikler, kaç kez yapıldığı ve kademesi.
/// Denenmemiş teknikler satır satır "yapılmadı" diye dizilmez; tek cümleyle
/// söylenir. Hiç teslim yoksa ilk adım gösterilir (NN/g boş durum ilkesi).
class _MasteryList extends StatelessWidget {
  const _MasteryList({required this.page});

  final BuildContext page;

  @override
  Widget build(BuildContext context) {
    final deliveries = JobScope.of(context).deliveries;
    if (deliveries.isEmpty) return _EmptyState(page: page);
    final all = labTools();
    final started = [for (final t in all) if (stepCount(t.name, deliveries) > 0) t];
    final rest = all.length - started.length;
    return ListView(
      shrinkWrap: true,
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
  const _EmptyState({required this.page});

  /// Profil sayfası: pencerenin içinden alt çubuğa ulaşılamaz.
  final BuildContext page;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text('İlk reçeteni bekliyoruz', style: AppText.title(size: 18)),
        const SizedBox(height: AppSpace.xs),
        Text(
          'Duvardan bir reçete al, laboratuvarda hazırla ve teslim et. '
          'Yaptıkların burada görünür.',
          style: AppText.body(size: 14),
        ),
        const SizedBox(height: AppSpace.lg),
        ChunkyButton(
          label: 'Reçetelere git',
          onPressed: () {
            Navigator.of(context).pop();
            HomeScreen.showTab(page, 0);
          },
        ),
      ],
    );
  }
}

/// İstatistik (Tuğrul, 2026-10-30): oyunun sayıları, sayı ve yanında düz cümle.
/// Yıldız sayısı "üç yıldızla" diye yazar: yıldızı acele düşürür, beceriyi ölçmez.
class _Stats extends StatelessWidget {
  const _Stats({required this.page});

  final BuildContext page;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final deliveries = store.deliveries;
    if (deliveries.isEmpty) return _EmptyState(page: page);
    final recipe = topRecipe(deliveries);
    final step = topStep(deliveries);
    final rows = [
      (deliveries.length, 'reçete teslim ettin'),
      (daysPlayed(deliveries), 'gün oynadın'),
      (longestStreak(deliveries), 'gün üst üste oynadın'),
      (deliveries.where((d) => d.stars == 3).length, 'reçeteyi üç yıldızla teslim ettin'),
      (store.rightAnswers, 'hasta sorusunu doğru bildin'),
      (store.garden.harvested, 'kurutulmuş çiçek topladın'),
      (store.earned, 'para kazandın'),
    ];
    return ListView(
      shrinkWrap: true,
      children: [
        for (final (i, (count, text)) in rows.indexed) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.line),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('$count', style: AppText.title(size: 22)),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(child: Text(text, style: AppText.body(size: 14))),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpace.sm),
        if (recipe != null) Text('En çok ${recipe.name} hazırladın, ${recipe.count} kez.', style: AppText.body(size: 14)),
        if (step != null) ...[
          const SizedBox(height: AppSpace.xs),
          Text('En sık yaptığın teknik ${step.name}, ${step.count} kez.', style: AppText.body(size: 14)),
        ],
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
                  next == null ? 'En yüksek madalya: ${tiers[tier].title}' : '${next.title} için ${next.from - count} kez daha yap',
                  style: AppText.label(size: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$count kez', style: AppText.title(size: 16)),
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
    final prepared = unlockAll
        ? playableFormulas(prescriptionOrders)
        : preparedFormulas(JobScope.of(context).deliveries, prescriptionOrders);
    final playable = playableFormulas(prescriptionOrders);
    return ListView(
      shrinkWrap: true,
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

/// Defter sayfası: kâğıtta satır satır teslimler.
class _LedgerPage extends StatelessWidget {
  const _LedgerPage({required this.entries});

  final List<Delivery> entries;

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
            _LedgerRow(delivery: d),
          ],
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.delivery});

  final Delivery delivery;

  @override
  Widget build(BuildContext context) {
    final at = delivery.at;
    final time = '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
    // Kayıttaki reçete oyundan çıkarıldıysa hekim yazılmaz.
    final doctor = prescriptionOrders.where((o) => o.key == delivery.orderKey).firstOrNull?.doctorName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
      child: Row(
        children: [
          SizedBox(width: 44, child: Text(time, style: AppText.label(size: 12))),
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

/// Reçete defteri (Tuğrul, 2026-10-28): eczanedeki majistral defteri gibi, en
/// yeniden eskiye, güne göre gruplanmış. Kayıt hiçbir teslimi silmez.
Future<void> _openLedger(BuildContext context, Rect from) {
  final store = JobScope.of(context);
  final now = store.now();
  final days = <String, List<Delivery>>{};
  for (final d in store.deliveries.reversed) {
    days.putIfAbsent(dayLabel(d.at, now), () => []).add(d);
  }
  return _openDrawer(
    context,
    from,
    'Reçete defteri',
    (_) => days.isEmpty
        ? _EmptyState(page: context)
        : ListView(
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
  );
}
