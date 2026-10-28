import 'package:flutter/material.dart';

import '../data/dried_plants.dart';
import '../logic/job_store.dart';
import '../models/garden.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/chunky_button.dart';
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
          child: TabHeader(title: 'Bahçe', subtitle: 'Tıbbi bitki yetiştir, kurut, vitrine koy'),
        ),
        Expanded(
          child: GardenGround(
            child: ListView(
              padding: EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, bottom),
              children: [
                _SeedShelf(garden: garden, store: store),
                const SizedBox(height: AppSpace.lg),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpace.lg,
                  crossAxisSpacing: AppSpace.lg,
                  childAspectRatio: 1.1,
                  children: [
                    for (var i = 0; i < Garden.allBeds; i++)
                      if (i >= Garden.openBeds)
                        GardenBed(number: i + 1, open: false)
                      else
                        _bed(context, store, i, garden.beds[i], now),
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
        progress: bed.progressAt(now),
        color: Color(plant.color),
        ready: ready,
        label: ready ? '${plant.name} · hazır' : '${plant.name} · ${formatRemaining(bed.readyAt.difference(now))}',
        onTap: () => ready ? _harvest(c, store, i) : _openGrowing(c, store, i),
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
        if (store.showcaseBonus(g) > 0)
          g == PlantGroup.cay || g == PlantGroup.bogaz
              ? '${g.effect} +${store.showcaseBonus(g)}'
              : '${g.effect} +%${store.showcaseBonus(g)}',
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
        ],
      ),
    );
  }
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
