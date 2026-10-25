import 'package:flutter/material.dart';

import '../models/shop_item.dart';
import '../theme/bevel.dart';
import '../theme/tokens.dart';

/// İstasyon adı + yatay kaydırılan kademe kartları.
class StationSection extends StatelessWidget {
  const StationSection({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.xl),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              station.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: AppFont.heading,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final tier in station.tiers)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpace.md),
                    child: StationTierCard(tier: tier),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StationTierCard extends StatelessWidget {
  const StationTierCard({super.key, required this.tier});

  final ShopItem tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 195,
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tier.imagePath != null)
            ClipOval(
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.asset(tier.imagePath!, fit: BoxFit.cover),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tier.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(tier.icon, color: tier.color, size: 30),
            ),
          const SizedBox(height: AppSpace.md),
          Text(
            tier.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: AppFont.title,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            tier.description,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black.withValues(alpha: 0.65), fontSize: AppFont.body),
          ),
          const SizedBox(height: AppSpace.sm),
          _PricePill(text: tier.price == 0 ? 'Başlangıç' : '${tier.price} Para'),
          const SizedBox(height: AppSpace.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kiremit,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
                textStyle: const TextStyle(fontSize: AppFont.body, fontWeight: FontWeight.w800),
              ),
              // Ekonomi henüz yok; satın alma kapalı testten önce bağlanacak.
              onPressed: tier.price == 0 ? null : () {},
              child: Text(tier.price == 0 ? 'Elinde' : tier.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopItemTile extends StatelessWidget {
  const ShopItemTile({super.key, required this.item});

  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.lg),
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: item.cardColor != null
            ? Border.all(color: item.cardColor!, width: 2)
            : Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: AppFont.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpace.xs),
                Text(
                  item.description,
                  style: TextStyle(color: Colors.black.withValues(alpha: 0.65), fontSize: AppFont.body),
                ),
                if (item.price > 0) ...[
                  const SizedBox(height: AppSpace.sm),
                  _PricePill(text: '${item.price} Para'),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
              textStyle: const TextStyle(fontSize: AppFont.body, fontWeight: FontWeight.w800),
              elevation: 6,
              shadowColor: Colors.black.withValues(alpha: 0.16),
            ).copyWith(
              // A soft warm-apricot-to-kiremit gradient ties the button into
              // the card's cream/white palette. backgroundBuilder just wraps
              // the button's already-built Material, so the theme's bevel band
              // and this elevation shadow still paint on top of it.
              backgroundBuilder: (context, states, child) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE08A4B), AppColors.kiremit],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: child,
              ),
            ),
            // Ekonomi ve reklam henüz yok; kapalı testten önce bağlanacak.
            onPressed: () {},
            child: Text(item.buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppFont.caption,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class MarketTabButton extends StatelessWidget {
  const MarketTabButton({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onColor = color.computeLuminance() > 0.5 ? AppColors.ink : Colors.white;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
        child: CustomPaint(
          foregroundPainter: const BevelPainter(borderRadius: AppRadius.sm),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: selected ? onColor : Colors.transparent, width: 2),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onColor,
                fontSize: AppFont.caption,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
