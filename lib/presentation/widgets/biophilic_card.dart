import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'bouncy_tap.dart';

/// Kiwi-grade Biophilic Card with tactile spring physics,
/// 18px smooth radius, and clean anti-AI border elevation.
class BiophilicCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

  const BiophilicCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: (borderColor ?? AppColors.border).withValues(alpha: 0.15),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return BouncyTap(
        onTap: onTap,
        scaleDown: 0.968,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
