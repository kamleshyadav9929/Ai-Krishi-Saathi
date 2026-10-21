import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/services/mandi_service.dart';
import '../../../data/services/voice_assistant_service.dart';
import '../../widgets/borderless_action_tile.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/mandi_ticker_ribbon.dart';
import '../calendar/crop_calendar_screen.dart';
import '../crop_profile/crop_profile_screen.dart';
import '../schemes/govt_schemes_screen.dart';
import '../soil_card/soil_card_screen.dart';
import '../voice_assistant/voice_assistant_sheet.dart';
import '../weather_alert/weather_alert_screen.dart';

/// Next-level borderless Home Screen inspired by Kiwi UPI and modern mobile interfaces.
/// Eliminates card-fatigue by replacing 14 separate boxed containers with fluid negative space,
/// an ambient status bar, a horizontal live mandi stream, and a tactile 4x2 quick actions grid.
class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  void _handleVoiceAction(BuildContext context, VoiceActionIntent intent) {
    switch (intent) {
      case VoiceActionIntent.navigateMandi:
        onNavigateTab(2);
        break;
      case VoiceActionIntent.navigateCropDoctor:
        onNavigateTab(1);
        break;
      case VoiceActionIntent.navigateSowing:
        onNavigateTab(3);
        break;
      case VoiceActionIntent.navigateCalendar:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CropCalendarScreen()),
        );
        break;
      case VoiceActionIntent.navigateSoilCard:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SoilCardScreen()),
        );
        break;
      case VoiceActionIntent.navigateSchemes:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GovtSchemesScreen()),
        );
        break;
      case VoiceActionIntent.navigateFarmManager:
        onNavigateTab(4);
        break;
      case VoiceActionIntent.navigateCropProfile:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CropProfileScreen()),
        );
        break;
      case VoiceActionIntent.navigateAlerts:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherAlertScreen()),
        );
        break;
      case VoiceActionIntent.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    final mandiService = MandiService();
    final tickerPrices = mandiService.getTickerPrices(state: loc.currentState);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: const CustomAppBar(titleKey: 'appName'),
      floatingActionButton: BouncyTap(
        onTap: () {
          HapticHelper.mediumImpact();
          VoiceAssistantSheet.show(
            context,
            onVoiceAction: (intent) => _handleVoiceAction(context, intent),
          );
        },
        scaleDown: 0.92,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF15803D),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF14532D).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(LucideIcons.mic, color: Colors.white, size: 26),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Pure Typography Greeting (Above the Hero Image)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.tr('greeting'),
                    style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lang.isHindi
                        ? 'आपकी फसल, उपज व मंडी का संपूर्ण डिजिटल साथी'
                        : 'Your complete digital companion for crops & mandi',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Visual Hero Banner (Lush Indian Farm Landscape & Smart Farmer)
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 148,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14532D).withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/hero_krishi_banner.png',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.72),
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lang.isHindi ? 'डिजिटल कृषि क्रांति' : 'Smart Farming AI',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lang.isHindi ? 'फसल की सुरक्षा,\nसटीक पैदावार' : 'Protect Your Crop,\nMaximize Yield',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.22,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lang.isHindi
                                ? 'रोग पहचान • आज का मंडी भाव • सही खाद'
                                : 'Disease Detection • Mandi Prices • Soil Care',
                            style: const TextStyle(
                              color: Color(0xFFDCFCE7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0),
            const SizedBox(height: 20),

            // Live Mandi Rates Stream (Borderless Horizontal Ribbon)
            MandiTickerRibbon(
              prices: tickerPrices,
              isHindi: lang.isHindi,
              onTapViewAll: () => onNavigateTab(2),
            ),
            const SizedBox(height: 22),

            // 5. Borderless Quick Services Hub (Tactile 4x2 Icon Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                lang.tr('quickActions'),
                style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Row 1 of 4 Action Tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.scan_line,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: AppColors.primary,
                    title: lang.tr('cropDoctorTitle'),
                    badge: 'AI',
                    isHindi: lang.isHindi,
                    onTap: () => onNavigateTab(1),
                    index: 0,
                  ),
                ),
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.trending_up,
                    iconBg: const Color(0xFFFEF3C7),
                    iconColor: AppColors.accent,
                    title: lang.tr('mandiPriceTitle'),
                    badge: 'Live',
                    isHindi: lang.isHindi,
                    onTap: () => onNavigateTab(2),
                    index: 1,
                  ),
                ),
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.sprout,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0369A1),
                    title: lang.tr('sowingAdvisorTitle'),
                    isHindi: lang.isHindi,
                    onTap: () => onNavigateTab(3),
                    index: 2,
                  ),
                ),
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.book_open,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: AppColors.primary,
                    title: lang.isHindi ? 'फसल डायरी' : 'Crop Diary',
                    badge: lang.isHindi ? 'नया' : 'NEW',
                    isHindi: lang.isHindi,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CropProfileScreen()),
                      );
                    },
                    index: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 2 of 4 Action Tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.flask_conical,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                    title: lang.isHindi ? 'खाद कैलकुलेटर' : 'Fertilizers',
                    isHindi: lang.isHindi,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SoilCardScreen()),
                      );
                    },
                    index: 4,
                  ),
                ),
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.calendar,
                    iconBg: const Color(0xFFFEF3C7),
                    iconColor: AppColors.accent,
                    title: lang.tr('cropCalendarTitle'),
                    isHindi: lang.isHindi,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CropCalendarScreen()),
                      );
                    },
                    index: 5,
                  ),
                ),
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.landmark,
                    iconBg: const Color(0xFFFEF3C7),
                    iconColor: AppColors.accent,
                    title: lang.isHindi ? 'सरकारी योजना' : 'Govt Schemes',
                    isHindi: lang.isHindi,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GovtSchemesScreen()),
                      );
                    },
                    index: 6,
                  ),
                ),
                Expanded(
                  child: BorderlessActionTile(
                    icon: LucideIcons.calculator,
                    iconBg: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF7E22CE),
                    title: lang.tr('expenseTrackerTitle'),
                    isHindi: lang.isHindi,
                    onTap: () => onNavigateTab(4),
                    index: 7,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
