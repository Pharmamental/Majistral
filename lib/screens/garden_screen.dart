import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/back_pill.dart';
import '../widgets/garden_widgets.dart';

/// Bahçe sekmesi (Tuğrul, 2026-10-29): eczanenin arka bahçesinde tıbbi bitki
/// yetiştirilir, kurutulur, vitrine konur. Başlık duvarda, parseller çitin
/// altındaki çimende. Şimdilik yalnız sahne: 3 açık, 3 kilitli parsel; tohum,
/// büyüme ve hasat sonra gelecek.
class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  /// Başta açık parsel sayısı ve toplam parsel.
  static const openBeds = 3;
  static const allBeds = 6;

  @override
  Widget build(BuildContext context) {
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
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, bottom),
              mainAxisSpacing: AppSpace.lg,
              crossAxisSpacing: AppSpace.lg,
              childAspectRatio: 1.1,
              children: [
                for (var i = 1; i <= allBeds; i++) GardenBed(number: i, open: i <= openBeds),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
