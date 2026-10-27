import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Seçili öğenin altındaki kısa kobalt çizgi (Tuğrul, 2026-10-27: alt çubukta
/// ve duvardaki fişlerde seçim aynı yolla gösterilir). Seçilmeyende görünmez ama
/// yerini tutar, böylece seçim değişince yerleşim kaymaz.
class SelectionMark extends StatelessWidget {
  const SelectionMark({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: selected ? 20 : 0,
      height: 4,
      decoration: BoxDecoration(color: AppColors.kobalt, borderRadius: BorderRadius.circular(AppRadius.pill)),
    );
  }
}
