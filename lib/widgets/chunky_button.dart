import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Tıknaz 3B düğme (Tasarım Rehberi, Oyun UI: "chunky button"): altında koyu
/// bir kenar durur, basılınca düğme aşağı çöker ve kenar kaybolur. "Bu
/// tıklanabilir" ipucunu gölgeyle verir. Pasifken düz gri olur.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.kobalt,
    this.edgeColor = AppColors.kobaltDark,
    this.foreground = Colors.white,
    this.compact = false,
  });

  /// Kobalt değil, yeşil "hazır / teslim" düğmesi.
  const ChunkyButton.success({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
  })  : color = AppColors.success,
        edgeColor = AppColors.successDark,
        foreground = Colors.white;

  /// Beyaz zeminli ikincil düğme.
  const ChunkyButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
  })  : color = AppColors.surface,
        edgeColor = AppColors.line,
        foreground = AppColors.kobalt;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final Color edgeColor;
  final Color foreground;
  final bool compact;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  static const double _edge = 4;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_enabled && _pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 44.0 : 56.0;
    final face = _enabled ? widget.color : const Color(0xFFE1E6EC);
    final edge = _enabled ? widget.edgeColor : const Color(0xFFE1E6EC);
    final fg = _enabled ? widget.foreground : const Color(0xFF6B7586);
    final drop = _pressed ? _edge : 0.0;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: SizedBox(
          height: height + _edge,
          child: Stack(
            children: [
              Positioned.fill(
                top: _edge,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: edge,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 70),
                left: 0,
                right: 0,
                top: drop,
                height: height,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                  decoration: BoxDecoration(
                    color: face,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: widget.color == AppColors.surface && _enabled
                        ? Border.all(color: AppColors.line, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: fg, size: widget.compact ? 20 : 22),
                        const SizedBox(width: AppSpace.sm),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.button(size: 19, color: fg),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
