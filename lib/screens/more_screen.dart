import 'package:flutter/material.dart';

import '../data/formulary.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import 'references_screen.dart';

/// Diğer sekmesi (Tuğrul, 2026-10-28): alt çubukta yeri olmayan bölümler.
/// Şimdilik yalnız Kaynaklar.
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _references = false;

  @override
  Widget build(BuildContext context) {
    if (_references) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: AppColors.wall,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.md, AppSpace.sm, AppSpace.md, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _references = false),
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.accentText),
                  label: Text('Diğer', style: AppText.label(size: 14, color: AppColors.accentText)),
                  style: TextButton.styleFrom(minimumSize: const Size(48, 44), shape: const StadiumBorder()),
                ),
              ),
            ),
          ),
          const Expanded(child: ReferencesScreen()),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ColoredBox(
          color: AppColors.wall,
          child: TabHeader(title: 'Diğer', subtitle: 'Kaynaklar ve daha fazlası', sign: TabSign.diger),
        ),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: ColoredBox(
            color: AppColors.background,
            child: ListView(
              padding: const EdgeInsets.all(AppSpace.lg),
              children: [
                _MoreTile(
                  title: 'Kaynaklar',
                  subtitle: '${allReferences.length} güvenilir kaynak',
                  image: 'assets/images/ikon/ikon_sekme_kaynaklar.png',
                  onTap: () => setState(() => _references = true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({required this.title, required this.subtitle, required this.image, required this.onTap});

  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;

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
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Row(
            children: [
              Image.asset(image, width: 44, height: 44),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.title(size: 18)),
                    Text(subtitle, style: AppText.label()),
                  ],
                ),
              ),
              Text('›', style: AppText.title(size: 22, color: AppColors.inkMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
