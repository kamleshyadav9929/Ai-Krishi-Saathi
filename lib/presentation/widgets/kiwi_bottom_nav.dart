import 'package:flutter/material.dart';
import '../../core/utils/haptic_helper.dart';

class GoogleNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool hasBadge;

  const GoogleNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.hasBadge = false,
  });
}

// Backward compatibility alias
typedef KiwiNavItem = GoogleNavItem;

/// Google Apps-Grade Material You Navigation Bar.
/// Features signature Google-style active pill indicator capsule,
/// smooth animated transitions, 5-tab balanced distribution,
/// and tactile haptic feedback.
class GoogleBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GoogleNavItem> items;

  const GoogleBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == currentIndex;
              final item = items[index];

              return Expanded(
                child: InkWell(
                  onTap: () {
                    HapticHelper.lightImpact();
                    onTap(index);
                  },
                  splashColor: const Color(0xFFDCFCE7).withValues(alpha: 0.4),
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google signature active pill capsule
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.fastOutSlowIn,
                            width: isSelected ? 56 : 38,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFDCFCE7) // Soft Google Biophilic Green Pill
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                size: 21,
                                color: isSelected
                                    ? const Color(0xFF14532D) // Google Deep Slate Green
                                    : const Color(0xFF5F6368), // Iconic Google Slate Inactive
                              ),
                            ),
                          ),
                          if (item.hasBadge)
                            Positioned(
                              top: 2,
                              right: isSelected ? 12 : 4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Text label underneath pill
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF14532D)
                              : const Color(0xFF5F6368),
                          letterSpacing: 0.1,
                          height: 1.15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// Backward compatibility alias for KiwiBottomNav
typedef KiwiBottomNav = GoogleBottomNav;
