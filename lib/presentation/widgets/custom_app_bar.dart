import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../core/localization/language_provider.dart';
import '../../core/utils/haptic_helper.dart';

/// Clean, beautiful, modern App Bar adhering to Anti-AI & Google Material You standards.
/// Seamlessly adjusts for Root screens (Brand identity) and Child screens (Circular back button).
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final bool showLanguageToggle;
  final List<Widget>? actions;
  final Widget? leading;
  final String? subtitle;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.titleKey,
    this.showLanguageToggle = true,
    this.actions,
    this.leading,
    this.subtitle,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final canPop = Navigator.canPop(context);
    final isHomeBrand = titleKey == 'appName';

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leading ??
          (canPop
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        HapticHelper.lightTap();
                        Navigator.maybePop(context);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.arrow_left,
                            size: 18,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null),
      titleSpacing: canPop ? 6 : 16,
      title: isHomeBrand
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF15803D),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF15803D).withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.sprout,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang.tr('appName'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                        fontFamily: lang.isHindi ? 'NotoSansDevanagari' : 'Poppins',
                      ),
                    ),
                    Text(
                      lang.isHindi ? 'स्मार्ट कृषि सहायक' : 'Smart Farming Assistant',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF15803D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.tr(titleKey),
                  style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                    fontFamily: lang.isHindi ? 'NotoSansDevanagari' : 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
      actions: [
        if (showLanguageToggle)
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: InkWell(
                onTap: () {
                  HapticHelper.lightTap();
                  lang.toggleLanguage();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.languages,
                        size: 14,
                        color: Color(0xFF15803D),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lang.isHindi ? 'English' : 'हिंदी',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (actions != null) ...actions!,
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.8),
        child: Divider(height: 0.8, thickness: 0.8, color: Color(0xFFF1F5F9)),
      ),
    );
  }
}
