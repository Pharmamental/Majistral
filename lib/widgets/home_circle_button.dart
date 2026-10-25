import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Circular icon button used for the feature entry points on the home screen.
class HomeCircleButton extends StatelessWidget {
  const HomeCircleButton({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: AppFont.caption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
