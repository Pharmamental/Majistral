import 'package:flutter/material.dart';

import '../logic/job_store.dart';
import '../theme/tokens.dart';
import 'thermometer_panel.dart';

/// Su banyosunda ısıtma: krem hazırlanırken yağ ve su fazı ayrı ayrı yaklaşık
/// 70–75 °C'ye ısıtılır. [magistralName] verilirse bu, o işin ısıtma adımıdır:
/// oyuncu sıcaklığı aralıkta tutunca iş kaldığı yerden devam eder. Verilmezse
/// yalnız deneme.
Future<void> openHeating(BuildContext context, {String? magistralName}) {
  final store = JobScope.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.paper)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (magistralName != null) ...[
              Text(magistralName, style: AppText.label(size: 14)),
              const SizedBox(height: AppSpace.xs),
              Text(
                'Fazlar ısındı. Termometreyi 70–75°\'de tut, sonra karıştırmaya geçilir.',
                textAlign: TextAlign.center,
                style: AppText.body(size: 14, color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpace.md),
            ],
            ThermometerPanel(
              title: magistralName != null ? 'Fazları ısıt' : 'Isıtma denemesi',
              idealMin: 70,
              idealMax: 75,
              onSuccess: magistralName == null
                  ? null
                  : () {
                      store.completeAction(magistralName);
                      // Başarıyı kısa bir an göster, sonra kapat.
                      Future.delayed(const Duration(milliseconds: 900), () {
                        if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                      });
                    },
            ),
          ],
        ),
      ),
    ),
  );
}
