import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/mandi_price_model.dart';
import 'animated_counter.dart';
import 'bouncy_tap.dart';
import 'pulse_badge.dart';

/// A sleek, borderless horizontal ticker for live mandi commodity prices.
/// Inspired by Kiwi UPI live ticker & FinTech streams.
class MandiTickerRibbon extends StatelessWidget {
  final List<MandiPriceModel> prices;
  final bool isHindi;
  final VoidCallback onTapViewAll;

  const MandiTickerRibbon({
    super.key,
    required this.prices,
    required this.isHindi,
    required this.onTapViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const PulseBadge(
                    color: Color(0xFF22C55E),
                    size: 7,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHindi ? 'लाइव मंडी भाव (आज के भाव)' : 'Live Mandi Rates',
                    style: AppTypography.headingSmall(isHindi: isHindi).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              BouncyTap(
                onTap: onTapViewAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isHindi ? 'सभी देखें' : 'View All',
                        style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(LucideIcons.chevron_right, size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: prices.length,
            separatorBuilder: (context, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = prices[index];
              final name = isHindi ? item.commodityHindi : item.commodity;

              return BouncyTap(
                onTap: onTapViewAll,
                scaleDown: 0.95,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.trending_up,
                          size: 13,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        name,
                        style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AnimatedCounter(
                        value: item.modalPrice,
                        prefix: '₹',
                        suffix: '/Q',
                        fractionDigits: 0,
                        style: AppTypography.metricValue().copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
