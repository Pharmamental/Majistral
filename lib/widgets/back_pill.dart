import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Alt ekranların (sekme dışı) başlık satırı: geri düğmesi + ekran adı.
/// Geri düğmesi 48×48 dokunma alanlı.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.sm, AppSpace.sm, AppSpace.lg, AppSpace.sm),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Geri',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
            style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
          ),
          const SizedBox(width: AppSpace.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.title(size: 22)),
                if (subtitle != null) Text(subtitle!, style: AppText.label()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sekmenin tabelası (Tuğrul, 2026-10-29, "yaldızlı cam güzel ama her sekmenin kendine
/// özel tasarımı olsun"): eski eczane vitrin camı gibi koyu cam, varak harf. Camın ve
/// varağın rengi sekmenin kendi malzemesinden.
enum TabSign {
  /// Reçete koçanının kobaltı, altın varak.
  receteler(Color(0xFF16336E), [Color(0xFFF7E6A6), Color(0xFFC9962C)]),

  /// Laboratuvarın arduvazı, gümüş varak.
  laboratuvar(Color(0xFF2F353B), [Color(0xFFF4F7FA), Color(0xFF98A4B0)]),

  /// Tentenin bordosu, altın varak.
  market(Color(0xFF5E1E27), [Color(0xFFF7E6A6), Color(0xFFC9962C)]),

  /// Bahçenin yeşili, altın varak.
  bahce(Color(0xFF24402F), [Color(0xFFF7E6A6), Color(0xFFC9962C)]),

  /// Diploma çerçevesinin cevizi, altın varak.
  profil(Color(0xFF3B2618), [Color(0xFFF7E6A6), Color(0xFFC9962C)]),

  /// Mürekkep laciverti, bakır varak (kaynaklar, çekmece dolabı).
  diger(Color(0xFF172033), [Color(0xFFF5CDA8), Color(0xFFB0683A)]);

  const TabSign(this.glass, this.leaf);

  /// Camın rengi.
  final Color glass;

  /// Varağın üstten alta iki tonu.
  final List<Color> leaf;
}

/// Sekme sayfalarının üst başlığı: sekmenin kendi renginde yaldızlı cam tabela,
/// içinde varak harfle ad ve tek satır durum özeti.
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, required this.subtitle, required this.sign, this.trailing});

  final String title;
  final String subtitle;
  final TabSign sign;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final style = AppText.display(size: 32);
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.lg, AppSpace.xl, AppSpace.md),
      decoration: BoxDecoration(
        // Camın üstünde hafif bir parıltı, alt kenarda varak şerit.
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(sign.glass, Colors.white, .07)!, sign.glass, Color.lerp(sign.glass, Colors.black, .12)!],
          stops: const [0, .55, 1],
        ),
        border: Border(bottom: BorderSide(color: sign.leaf.last, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  label: title,
                  excludeSemantics: true,
                  // Varak: altta koyu gölge, üstte iki tonlu varak.
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 1.5),
                        child: Text(title, style: style.copyWith(color: Colors.black.withValues(alpha: .45))),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: sign.leaf,
                        ).createShader(bounds),
                        child: Text(title, style: style),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpace.xs),
                Text(subtitle, style: AppText.body(color: sign.leaf.first.withValues(alpha: .78))),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
