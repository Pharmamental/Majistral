import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/thermometer_panel.dart';

/// Laboratuvar sekmesi: şimdilik yalnız su banyosu istasyonu. Krem hazırlanırken
/// yağ ve su fazı ayrı ayrı yaklaşık 70–75 °C'ye ısıtılır; oyuncu bu aralığı
/// tutmayı öğrenir. Diğer istasyonlar tasarım belgesine göre eklenecek.
class LabScreen extends StatelessWidget {
  const LabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpace.x3),
      children: const [
        TabHeader(title: 'Laboratuvar', subtitle: 'Su banyosu · Hidrofil merhem'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: ThermometerPanel(title: 'Fazları ısıt', idealMin: 70, idealMax: 75),
        ),
      ],
    );
  }
}
