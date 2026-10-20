import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/haptic_helper.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isSecondary;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSecondary ? Colors.white : AppColors.accent;
    final fgColor = isSecondary ? AppColors.primaryDark : Colors.white;
    final borderColor = isSecondary ? AppColors.primary : AppColors.accent;

    return Container(
      height: 52, // 48px+ touch target rule
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isSecondary
            ? null
            : const [
                BoxShadow(
                  color: Color(0x18A16207),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading
              ? null
              : () {
                  HapticHelper.mediumConfirm();
                  onPressed();
                },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: fgColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: fgColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: AppTypography.labelLarge().copyWith(
                          color: fgColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
