import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../theme/tokens.dart';

/// Kasadaki para (2026-10-29). Depoya veresiye borcu varsa altında yazar; borç
/// teslimlerden kendiliğinden kesilir, oyuncu bir şey yapmaz.
class CoinPill extends StatelessWidget {
  const CoinPill({super.key, this.onGlass});

  /// Sekme tabelasının üstündeyse varak rengi: hap yarı saydam, kenarı ve yazısı varak.
  final List<Color>? onGlass;

  @override
  Widget build(BuildContext context) {
    final store = JobScope.of(context);
    final leaf = onGlass;
    return Semantics(
      label: 'Kasada ${store.coins} para${store.debt > 0 ? ', depoya ${store.debt} borç' : ''}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpace.sm, AppSpace.xs, AppSpace.md, AppSpace.xs),
            decoration: BoxDecoration(
              color: leaf == null ? AppColors.surface : Colors.white.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: leaf?.last ?? AppColors.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.toll_rounded, size: 18, color: AppColors.star),
                const SizedBox(width: AppSpace.xs),
                Text('${store.coins}', style: AppText.label(size: 15, color: leaf?.first ?? AppColors.ink)),
              ],
            ),
          ),
          if (store.debt > 0) ...[
            const SizedBox(height: 2),
            Text(
              'Depoya borç ${store.debt}',
              style: AppText.label(size: 11, color: leaf == null ? AppColors.bekliyorText : const Color(0xFFF5C76B)),
            ),
          ],
        ],
      ),
    );
  }
}
