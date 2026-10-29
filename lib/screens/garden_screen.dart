import 'package:flutter/material.dart';

import '../data/dried_plants.dart';
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
/// altındaki çimende. Teslimlerin yarısı tohum getirir ([Garden]); boş parsele
/// dokununca tohum seçilir, olgun parsele dokununca hasat (bir çiçek); 5 çiçek
/// bir fanus açar.
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

/// Bahçenin üstündeki kâğıt: eldeki tohumlar, fanusa biriken çiçekler ve
/// vitrindeki etkiler.
class _SeedShelf extends StatelessWidget {
  const _SeedShelf({required this.garden, required this.store});

  final Garden garden;
  final JobStore store;

  @override
  Widget build(BuildContext context) {
    final seeds = [for (final p in driedPlants) if ((garden.seeds[p.name] ?? 0) > 0) p];
    final flowers = [for (final p in driedPlants) if ((garden.flowers[p.name] ?? 0) > 0) p];
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
            Text(
              'Teslim ettiğin reçetelerin yarısı bir tohum getirir.',
              style: AppText.body(size: 14, color: AppColors.inkMuted),
            )
          else
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [for (final p in seeds) _SeedChip(plant: p, text: '${p.name} ×${garden.seeds[p.name]}')],
            ),
          const SizedBox(height: AppSpace.lg),
          Text('Çiçeklerin', style: AppText.title(size: 18)),
          const SizedBox(height: AppSpace.sm),
          if (flowers.isEmpty)
            Text(
              'Hasat ettiğin her bitki bir çiçek verir. ${Garden.fanusCost} çiçek bir fanus açar. '
              'Çiçek markette tek tek de satılır.',
              style: AppText.body(size: 14, color: AppColors.inkMuted),
            )
          else
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [
                for (final p in flowers)
                  _SeedChip(plant: p, text: '${p.name} ${garden.flowers[p.name]}/${Garden.fanusCost}'),
              ],
            ),
          const SizedBox(height: AppSpace.md),
          Text(
            effects.isEmpty
                ? '${Garden.fanusCost} çiçeği biriken bitkiyi Profil\'deki vitrine koy; oyun etkisi kazanırsın.'
                : 'Vitrindeki oyun etkileri: ${effects.join(' · ')}',
            style: AppText.label(size: 12, color: AppColors.inkMuted),
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

class _SeedChip extends StatelessWidget {
  const _SeedChip({required this.plant, required this.text});

  final DriedPlant plant;
  final String text;

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
          Text(text, style: AppText.label(size: 13, color: AppColors.ink)),
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
                ? 'Tohumun yok. Teslim ettiğin reçetelerin yarısı bir tohum getirir.'
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
                            trailing: '${store.garden.seeds[p.name]} tohum · '
                                'Büyüme: ${formatRemaining(p.growTime * (1 - speed / 100))}',
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

/// Büyüyen parsel: kalan süre ve fanusa kaç çiçek kaldığı.
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
        return Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PlantInfo(plant: plant, trailing: 'Olgunlaşmaya ${formatRemaining(left)}'),
              const SizedBox(height: AppSpace.md),
              Text(
                _flowerProgress(store.garden, plant.name),
                style: AppText.body(size: 13, color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpace.lg),
              ChunkyButton.secondary(label: 'Kapat', onPressed: () => Navigator.of(sheet).pop()),
            ],
          ),
        );
      },
    ),
  );
}

/// Bitkinin fanusuna kaç çiçek kaldığı: "Elinde 3 Papatya çiçeği. Fanus için 2 tane daha."
String _flowerProgress(Garden garden, String plant) {
  if (garden.grown.contains(plant)) return '$plant fanusu açık; vitrine koyabilirsin.';
  final have = garden.flowers[plant] ?? 0;
  final need = Garden.fanusCost - have;
  return need <= 0
      ? 'Elinde $have $plant çiçeği: fanusu vitrine koyabilirsin.'
      : 'Elinde $have $plant çiçeği. Fanus için $need tane daha.';
}

/// Olgun parsel: hasat et; bir çiçek kurutulur, 5 çiçek bir fanus açar.
Future<void> _harvest(BuildContext context, JobStore store, int bed) async {
  final from = rectOf(context);
  final navigator = Navigator.of(context);
  final name = await store.harvest(bed);
  if (name == null || !navigator.mounted) return;
  final plant = driedPlantNamed(name)!;
  // Fanusu açık ya da 5 çiçeği biriken bitki vitrine konabilir.
  final ready = store.garden.grown.contains(name) || (store.garden.flowers[name] ?? 0) >= Garden.fanusCost;
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
          Text('Bir ${plant.name} çiçeği kurutuldu', textAlign: TextAlign.center, style: AppText.title(size: 20)),
          const SizedBox(height: AppSpace.xs),
          Text(
            '${_flowerProgress(store.garden, plant.name)} Oyun etkisi: ${plant.effectText}.',
            textAlign: TextAlign.center,
            style: AppText.body(size: 14, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.xl),
          if (ready) ...[
            ChunkyButton(
              label: 'Vitrine git',
              onPressed: () {
                Navigator.of(sheet).pop();
                HomeScreen.showTab(navigator.context, HomeScreen.profile);
              },
            ),
            const SizedBox(height: AppSpace.sm),
          ],
          ChunkyButton.secondary(label: 'Tamam', onPressed: () => Navigator.of(sheet).pop()),
        ],
      ),
    ),
  );
}
