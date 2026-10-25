import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/thermometer_panel.dart';

/// Laboratuvar: şimdilik yalnız su banyosu istasyonu. Krem hazırlanırken yağ
/// ve su fazı ayrı ayrı yaklaşık 70–75 °C'ye ısıtılır; oyuncu bu aralığı
/// tutmayı öğrenir. Diğer istasyonlar tasarım belgesine göre eklenecek.
class LabScreen extends StatelessWidget {
  const LabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Laboratuvar'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Column(
                  children: [
                    Text(
                      'Su Banyosu · Hidrofil Merhem',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFont.body,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: AppSpace.md),
                    const ThermometerPanel(
                      title: 'Fazları Isıt',
                      idealMin: 70,
                      idealMax: 75,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
