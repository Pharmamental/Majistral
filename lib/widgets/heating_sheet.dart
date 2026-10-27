import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'grow_panel.dart';
import 'thermometer_panel.dart';

/// Su banyosunda ısıtma: krem hazırlanırken yağ ve su fazı ayrı ayrı yaklaşık
/// 70–75 °C'ye ısıtılır. Önce oyun, sonra süre (Tuğrul, 2026-10-27): oyuncu
/// sıcaklığı aralıkta tutunca [onDone] çağrılır ve ısıtmanın süresi başlar.
/// Pencere su banyosu kartının yerinden ([from]) büyür.
Future<void> openHeating(
  BuildContext context, {
  required Rect from,
  required String magistralName,
  required VoidCallback onDone,
}) {
  return openGrowing<void>(
    context,
    from: from,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(magistralName, style: AppText.label(size: 14)),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Termometreyi 70–75°\'de tut; tutunca ısıtma başlar.',
            textAlign: TextAlign.center,
            style: AppText.body(size: 14, color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.md),
          ThermometerPanel(
            title: 'Fazları ısıt',
            idealMin: 70,
            idealMax: 75,
            onSuccess: () {
              onDone();
              // Başarıyı kısa bir an göster, sonra kapat.
              Future.delayed(const Duration(milliseconds: 900), () {
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              });
            },
          ),
        ],
      ),
    ),
  );
}
