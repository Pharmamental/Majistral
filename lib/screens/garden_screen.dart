import 'package:flutter/material.dart';

import '../data/dried_plants.dart';
import '../data/economy.dart';
import '../logic/job_store.dart';
import '../models/garden.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
import '../widgets/coin_pill.dart';
import '../widgets/garden_widgets.dart';
import '../widgets/grow_panel.dart';
import '../widgets/job_status.dart' show formatRemaining;
import '../widgets/second_tick.dart';
import 'home_screen.dart';

/// Bahçe sekmesi (Tuğrul, 2026-10-29): eczanenin arka bahçesinde tıbbi bitki
/// yetiştirilir, hasat edilir, vitrine konur. Başlık duvarda, parseller çitin
/// altındaki çimende. Tohum her teslimde gelir ([Garden]); boş parsele dokununca
/// tohum seçilir, büyüyen parsele gübre verilir, olgun parsele dokununca hasat.
class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> with SecondTick {
  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final garden = store.garden;
    final now = store.now();
    final bottom = AppSpace.x3 + MediaQuery.paddingOf(context).bottom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ColoredBox(
          color: AppColors.wall,
          child: TabHeader(title: 'Bahçe', subtitle: 'Tıbbi bitki yetiştir, vitrine koy', trailing: CoinPill()),
        ),
        Expanded(
          child: GardenGround(
            // Çit içerikle birlikte kayar, ekranın üstüne yapışmaz (Tuğrul, 2026-10-29).
            child: ListView(
              padding: EdgeInsets.only(bottom: bottom),
              children: [
                const GardenFence(),
                const SizedBox(height: AppSpace.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                  child: _SeedShelf(garden: garden, store: store),
                ),
                const SizedBox(height: AppSpace.lg),
                _BedRows(
                  beds: [
                    for (var i = 0; i < Garden.allBeds; i++)
                      if (i < garden.beds.length)
                        _bed(context, store, i, garden.beds[i], now)
                      // Sıradaki kilitli parsel parayla açılır (2026-10-29).
                      else if (i == garden.beds.length && store.nextParcelPrice != null)
                        Builder(
                          builder: (c) => GardenBed(
                            number: i + 1,
                            open: false,
                            label: 'Parsel ${i + 1} · ${store.nextParcelPrice} ile aç',
                            onTap: () => _openParcel(c, store, i),
                          ),
                        )
                      else
                        GardenBed(number: i + 1, open: false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bed(BuildContext context, JobStore store, int i, Bed? bed, DateTime now) {
    if (bed == null) {
      return Builder(
        builder: (c) => GardenBed(number: i + 1, open: true, onTap: () => _openSeedPicker(c, store, i)),
      );
    }
    final plant = driedPlantNamed(bed.plant)!;
    final ready = bed.readyBy(now);
    return Builder(
      builder: (c) => GardenBed(
        number: i + 1,
        open: true,
        plant: plant.name,
        progress: bed.progressAt(now),
        color: Color(plant.color),
        ready: ready,
        label: ready ? '${plant.name} · hazır' : '${plant.name} · ${formatRemaining(bed.readyAt.difference(now))}',
        onTap: () => ready ? _harvest(c, store, i) : _openGrowing(c, store, i),
      ),
    );
  }
}

/// Parseller ikişer ikişer; her parselin altında etiketi olduğu için sabit
/// oranlı ızgara yerine satır.
class _BedRows extends StatelessWidget {
  const _BedRows({required this.beds});

  final List<Widget> beds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: Column(
        children: [
          for (var i = 0; i < beds.length; i += 2) ...[
            if (i > 0) const SizedBox(height: AppSpace.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: beds[i]),
                const SizedBox(width: AppSpace.lg),
                Expanded(child: i + 1 < beds.length ? beds[i + 1] : const SizedBox.shrink()),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Bahçenin üstündeki kâğıt: eldeki tohumlar, gübre, nadir tohumun en geç
/// ne zaman geleceği (tavan açıkça söylenir) ve vitrindeki etkiler.
class _SeedShelf extends StatelessWidget {
  const _SeedShelf({required this.garden, required this.store});

  final Garden garden;
  final JobStore store;

  @override
  Widget build(BuildContext context) {
    final seeds = [for (final p in driedPlants) if ((garden.seeds[p.name] ?? 0) > 0) p];
    final effects = [
      for (final g in PlantGroup.values)
        if (store.showcaseBonus(g) > 0) g.effectText(store.showcaseBonus(g)),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tohumların', style: AppText.title(size: 18)),
          const SizedBox(height: AppSpace.sm),
          if (seeds.isEmpty)
            Text('Her reçete teslim ettiğinde bir tohum gelir.', style: AppText.body(size: 14, color: AppColors.inkMuted))
          else
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [for (final p in seeds) _SeedChip(plant: p)],
            ),
          const SizedBox(height: AppSpace.md),
          Text(
            'Gübre: ${garden.fertilizer} · Nadir tohum en geç ${garden.rareWithin} teslim sonra',
            style: AppText.label(size: 12, color: AppColors.ink),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            effects.isEmpty
                ? 'Yetiştirdiğin bitkiyi Profil\'deki vitrine koy; oyun etkisi kazanırsın.'
                : 'Vitrindeki oyun etkileri: ${effects.join(' · ')}',
            style: AppText.label(size: 12, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.md),
          Builder(
            builder: (c) => ChunkyButton.secondary(
              compact: true,
              label: 'Tohum satın al',
              onPressed: () => _openSeedShop(c, store),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sıradaki kilitli parseli parayla açar.
Future<void> _openParcel(BuildContext context, JobStore store, int bed) {
  final price = store.nextParcelPrice!;
  return openGrowing<void>(
    context,
    from: rectOf(context),
    builder: (sheet) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Parsel ${bed + 1}', style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Bir parsel daha: aynı anda bir bitki daha yetiştirirsin. Kasada ${store.coins} para var.',
            style: AppText.body(size: 14, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.lg),
          ChunkyButton(
            label: '$price ile aç',
            icon: Icons.toll_rounded,
            onPressed: store.coins >= price
                ? () {
                    store.buyParcel();
                    Navigator.of(sheet).pop();
                  }
                : null,
          ),
          const SizedBox(height: AppSpace.sm),
          ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheet).pop()),
        ],
      ),
    ),
  );
}

/// Belirli bir tohumu satın alma (geç oyun gideri, 2026-10-29): elde olmayan
/// bitkiler, kademesine göre fiyatıyla.
Future<void> _openSeedShop(BuildContext context, JobStore store) {
  return openGrowing<void>(
    context,
    from: rectOf(context),
    builder: (sheet) => ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final plants = [for (final p in driedPlants) if (!store.garden.has(p.name)) p];
        return Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tohum satın al', style: AppText.title(size: 20)),
              const SizedBox(height: AppSpace.xs),
              Text(
                plants.isEmpty
                    ? 'Bütün bitkiler elinde.'
                    : 'Şansla gelmesini beklemek istemediğin tohumu al. Kasada ${store.coins} para var.',
                style: AppText.body(size: 14, color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpace.md),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final p in plants)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpace.sm),
                        child: Row(
                          children: [
                            Expanded(child: _PlantInfo(plant: p)),
                            const SizedBox(width: AppSpace.sm),
                            SizedBox(
                              width: 96,
                              child: ChunkyButton(
                                compact: true,
                                label: '${seedPrices[p.tier]}',
                                icon: Icons.toll_rounded,
                                onPressed:
                                    store.coins >= seedPrices[p.tier]! ? () => store.buySeed(p.name) : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheet).pop()),
            ],
          ),
        );
      },
    ),
  );
}

class _SeedChip extends StatelessWidget {
  const _SeedChip({required this.plant});

  final DriedPlant plant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpace.xs, AppSpace.xs, AppSpace.md, AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(plant.imagePath, width: 28, height: 28),
          const SizedBox(width: AppSpace.xs),
          Text(plant.name, style: AppText.label(size: 13, color: AppColors.ink)),
        ],
      ),
    );
  }
}

/// Bitkinin kısa bilgisi: fanus, ad, Latince ad, grubu ve vitrindeki etkisi.
class _PlantInfo extends StatelessWidget {
  const _PlantInfo({required this.plant, this.trailing});

  final DriedPlant plant;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(plant.imagePath, width: 48, height: 48),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plant.name, style: AppText.body(size: 15, weight: FontWeight.w700)),
              Text(plant.latin, style: AppText.label(size: 12)),
              Text('Oyun etkisi: ${plant.effectText}', style: AppText.label(size: 12, color: AppColors.ink)),
              if (trailing != null) Text(trailing!, style: AppText.label(size: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Boş parsel: eldeki tohumlardan birini seç, ek.
Future<void> _openSeedPicker(BuildContext context, JobStore store, int bed) {
  final speed = store.showcaseBonus(PlantGroup.ferah);
  final seeds = [for (final p in driedPlants) if ((store.garden.seeds[p.name] ?? 0) > 0) p];
  return openGrowing<void>(
    context,
    from: rectOf(context),
    builder: (sheet) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Parsel ${bed + 1}: ne ekelim?', style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.xs),
          Text(
            seeds.isEmpty
                ? 'Tohumun yok. Her reçete teslim ettiğinde bir tohum gelir.'
                : 'Büyüme süreleri oyun süresidir, gerçek büyüme değil.',
            style: AppText.body(size: 14, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.md),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final p in seeds)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.sm),
                    child: Material(
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.paper),
                        side: const BorderSide(color: AppColors.line),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          store.plant(bed, p.name);
                          Navigator.of(sheet).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpace.sm),
                          child: _PlantInfo(
                            plant: p,
                            trailing: 'Büyüme: ${formatRemaining(p.growTime * (1 - speed / 100))}',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheet).pop()),
        ],
      ),
    ),
  );
}

/// Büyüyen parsel: kalan süre ve gübre.
Future<void> _openGrowing(BuildContext context, JobStore store, int bed) {
  return openGrowing<void>(
    context,
    from: rectOf(context),
    builder: (sheet) => ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final b = store.garden.beds[bed];
        if (b == null) return const SizedBox.shrink();
        final plant = driedPlantNamed(b.plant)!;
        final left = b.readyAt.difference(store.now());
        final fertilizer = store.garden.fertilizer;
        return Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PlantInfo(plant: plant, trailing: 'Olgunlaşmaya ${formatRemaining(left)}'),
              const SizedBox(height: AppSpace.md),
              Text(
                'Gübre kalan süreyi yarıya indirir. Elinde olan bitkinin tohumu gelince gübreye döner.',
                style: AppText.body(size: 13, color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpace.lg),
              ChunkyButton(
                label: 'Gübre ver ($fertilizer)',
                onPressed: fertilizer > 0 && left > Duration.zero ? () => store.feed(bed) : null,
              ),
              const SizedBox(height: AppSpace.sm),
              ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheet).pop()),
            ],
          ),
        );
      },
    ),
  );
}

/// Olgun parsel: hasat et; bitki kurutulup vitrine konabilir olur.
Future<void> _harvest(BuildContext context, JobStore store, int bed) async {
  final from = rectOf(context);
  final navigator = Navigator.of(context);
  final name = await store.harvest(bed);
  if (name == null || !navigator.mounted) return;
  final plant = driedPlantNamed(name)!;
  await openGrowing<void>(
    navigator.context,
    from: from,
    builder: (sheet) => Padding(
      padding: const EdgeInsets.all(AppSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(plant.imagePath, width: 96, height: 96),
          const SizedBox(height: AppSpace.md),
          Text('${plant.name} kurutuldu', textAlign: TextAlign.center, style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Artık vitrine koyabilirsin. Oyun etkisi: ${plant.effectText}.',
            textAlign: TextAlign.center,
            style: AppText.body(size: 14, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.xl),
          ChunkyButton(
            label: 'Vitrine git',
            onPressed: () {
              Navigator.of(sheet).pop();
              HomeScreen.showTab(navigator.context, HomeScreen.profile);
            },
          ),
          const SizedBox(height: AppSpace.sm),
          ChunkyButton.secondary(label: 'Tamam', onPressed: () => Navigator.of(sheet).pop()),
        ],
      ),
    ),
  );
}
