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
            const SizedBox(height: 16),

            // 2. Pure Typography Greeting (Zero Box Framing)
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
                  const SizedBox(height: 2),
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
            const SizedBox(height: 18),

            // Live Mandi Rates Stream (Borderless Horizontal Ribbon)
            MandiTickerRibbon(
              prices: tickerPrices,
              isHindi: lang.isHindi,
              onTapViewAll: () => onNavigateTab(2),
            ),
            const SizedBox(height: 22),

            // Key Services - Visual Farming Hub (Like Visual Farming Guides)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.tr('quickActions'),
                    style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    lang.isHindi ? 'सभी सेवाएं' : 'All services',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 11.5,
                      color: const Color(0xFF15803D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Visual Feature Cards for Key Services
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.tr('cropDoctorTitle'),
                    subtitle: lang.isHindi ? 'पत्ती स्कैन कर तुरंत रोग व उपचार जानें' : 'Instant AI leaf scan & crop diagnosis',
                    badge: 'AI Doctor',
                    imagePath: 'assets/images/crop_doctor_guide.png',
                    onTap: () => onNavigateTab(1),
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.tr('mandiPriceTitle'),
                    subtitle: lang.isHindi ? 'ताज़ा मंडी भाव, न्यूनतम व अधिकतम मूल्य' : 'Live APMC market rates & price trends',
                    badge: 'Live Mandi',
                    imagePath: 'assets/images/mandi_market_hero.png',
                    onTap: () => onNavigateTab(2),
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.tr('sowingAdvisorTitle'),
                    subtitle: lang.isHindi ? 'खरीफ, रबी व जायद की सही फसल चुनें' : 'Smart season & crop selection',
                    badge: lang.isHindi ? 'बुवाई' : 'Sowing',
                    imagePath: 'assets/images/sowing_seasons_hero.png',
                    onTap: () => onNavigateTab(3),
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.isHindi ? 'मृदा स्वास्थ्य व खाद' : 'Soil Health & Fertilizer',
                    subtitle: lang.isHindi ? 'NPK जांचें, संतुलित खाद की मात्रा जानें' : 'Test soil, get balanced NPK plan',
                    badge: lang.isHindi ? 'खाद' : 'Soil Health',
                    imagePath: 'assets/images/soil_test_hero.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SoilCardScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.tr('cropCalendarTitle'),
                    subtitle: lang.isHindi ? 'अंकुरण से कटाई का संपूर्ण रोडमैप' : 'Sowing to harvest schedule',
                    badge: lang.isHindi ? 'कैलेंडर' : 'Calendar',
                    imagePath: 'assets/images/crop_calendar_hero.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CropCalendarScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.isHindi ? 'सरकारी योजनाएं व सब्सिडी' : 'Govt Subsidies & Schemes',
                    subtitle: lang.isHindi ? 'पीएम-किसान, सोलर पंप व कृषि यंत्र' : 'PM-Kisan, Solar subsidy & schemes',
                    badge: lang.isHindi ? 'सब्सिडी' : 'Subsidy',
                    imagePath: 'assets/images/govt_schemes_hero.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GovtSchemesScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.isHindi ? 'फसल डायरी व प्रबंधन' : 'Crop Diary & Farm Manager',
                    subtitle: lang.isHindi ? 'खेत का हिसाब व फसल प्रोफाइल' : 'Track farm stages & health',
                    badge: lang.isHindi ? 'डायरी' : 'Diary',
                    imagePath: 'assets/images/hero_krishi_banner.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CropProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualGuideCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String badge,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return BouncyTap(
      onTap: () {
        HapticHelper.lightImpact();
        onTap();
      },
      scaleDown: 0.96,
      child: Container(
        width: 195,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
              child: Stack(
                children: [
                  Image.asset(
                    imagePath,
                    height: 105,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
