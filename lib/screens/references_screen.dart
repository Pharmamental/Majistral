import 'package:flutter/material.dart';

import '../data/formulary.dart';
import '../data/references.dart';
import '../theme/tokens.dart';
import '../widgets/back_pill.dart';

/// Kaynaklar sekmesi (2026-10-28): formül kitabının dayandığı kaynaklar, türüne
/// göre. Yalnız farmakope, devlet kurumu, ders kitabı, akademik makale ve
/// üniversite kaynağı; blog ve ticari site yok. Künye ve adres verilir, kaynak
/// metninden alıntı yapılmaz. Adres seçilip kopyalanabilir.
class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: AppColors.wall,
          child: TabHeader(title: 'Kaynaklar', subtitle: '${allReferences.length} güvenilir kaynak'),
        ),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: ColoredBox(
            color: AppColors.background,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpace.lg,
                AppSpace.lg,
                AppSpace.lg,
                AppSpace.x3 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                Text(
                  'Formüller bu kaynaklardan derlendi ve kendi sözlerimizle yazıldı. Her formül en az iki '
                  'kaynağa dayanır. İçerik taslak; yayından önce öğretim üyesi onayından geçecek.',
                  style: AppText.body(size: 13, color: AppColors.inkMuted),
                ),
                for (final kind in ReferenceKind.values)
                  if (allReferences.any((r) => r.kind == kind)) ...[
                    const SizedBox(height: AppSpace.xl),
                    Text(kind.title, style: AppText.title(size: 18)),
                    const SizedBox(height: AppSpace.sm),
                    for (final r in allReferences.where((r) => r.kind == kind)) ...[
                      _ReferenceTile(reference: r),
                      const SizedBox(height: AppSpace.sm),
                    ],
                  ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({required this.reference});

  final Reference reference;

  @override
  Widget build(BuildContext context) {
    final count = citationCount(reference.id);
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.paper),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reference.citation, style: AppText.body(size: 14)),
          if (reference.url != null)
            SelectableText(reference.url!, style: AppText.label(size: 12, color: AppColors.accentText)),
          const SizedBox(height: AppSpace.xs),
          Text(count == 0 ? 'Genel kaynak' : '$count formülde', style: AppText.label(size: 12)),
        ],
      ),
    );
  }
}
