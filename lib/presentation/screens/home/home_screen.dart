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
import '../../../data/services/weather_alert_service.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/borderless_action_tile.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/mandi_ticker_ribbon.dart';
import '../../widgets/pulse_badge.dart';
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
    final weather = loc.currentWeather;
    final mandiService = MandiService();
    final tickerPrices = mandiService.getTickerPrices(state: loc.currentState);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: const CustomAppBar(titleKey: 'appName'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ambient Borderless Status Ribbon (Weather Cockpit)
            Align(
              alignment: Alignment.centerRight,
              child: BouncyTap(
                onTap: () => onNavigateTab(3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.035),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.cloud_sun, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 6),
                      AnimatedCounter(
                        value: (weather?.temperature ?? 31.0).toDouble(),
                        suffix: '°C',
                        fractionDigits: 0,
                        style: AppTypography.metricValue().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
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
                        ? 'आज का मौसम बुवाई, छिड़काव व मंडी भाव के लिए अनुकूल है'
                        : 'Today is favorable for sowing, spraying & mandi trade',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. AI Voice Assistant Tactile Capsule (Kiwi-Style Micro-Surface)
            BouncyTap(
              onTap: () {
                HapticHelper.mediumImpact();
                VoiceAssistantSheet.show(
                  context,
                  onVoiceAction: (intent) => _handleVoiceAction(context, intent),
                );
              },
              scaleDown: 0.96,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF14532D), Color(0xFF166534)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14532D).withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const PulseBadge(
                          color: Color(0xFF4ADE80),
                          size: 38,
                        ),
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.mic, color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  lang.isHindi ? 'बोलकर पूछें (Voice Krishi AI)' : 'Ask Voice Krishi Assistant',
                                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  lang.isHindi ? 'नया' : 'NEW',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            lang.isHindi
                                ? 'माइक दबाएं और फसल रोग, खाद या मंडी का भाव पूछें'
                                : 'Tap mic and ask any crop disease, fertilizer or rate',
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevron_right, color: Colors.white70, size: 20),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0),
            const SizedBox(height: 20),

            // 4. Live Mandi Rates Stream (Borderless Horizontal Ribbon)
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
            const SizedBox(height: 22),

            // Visual How-To Guide For Farmers (Illustration-Rich Step Guide)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.isHindi ? 'एप कैसे उपयोग करें?' : 'How To Use App',
                    style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    lang.isHindi ? '3 आसान कदम' : '3 Easy Steps',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 11.5,
                      color: const Color(0xFF15803D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: BouncyTap(
                    onTap: () {
                      HapticHelper.lightImpact();
                      onNavigateTab(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/crop_doctor_scan.png',
                              height: 74,
                              width: 74,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang.isHindi ? '1. रोग जांच' : '1. Scan Leaf',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF14532D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.isHindi ? 'पत्ती की फोटो' : 'Take photo',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BouncyTap(
                    onTap: () {
                      HapticHelper.lightImpact();
                      onNavigateTab(2);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFEF08A), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/mandi_market_hero.png',
                              height: 74,
                              width: 74,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang.isHindi ? '2. मंडी भाव' : '2. Mandi Rate',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF854D0E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.isHindi ? 'ताज़ा भाव' : 'Live rates',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BouncyTap(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      VoiceAssistantSheet.show(
                        context,
                        onVoiceAction: (intent) => _handleVoiceAction(context, intent),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBAE6FD), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/voice_assistant_hero.png',
                              height: 74,
                              width: 74,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang.isHindi ? '3. बोलें' : '3. Speak',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0369A1),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.isHindi ? 'माइक दबाएं' : 'Tap & speak',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Illustrated Feature Hub for Farmers (Visual Carousel)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.isHindi ? 'किसान सचित्र मार्गदर्शिका' : 'Visual Farming Guides',
                    style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    lang.isHindi ? 'देखें व सीखें' : 'Learn visually',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 11.5,
                      color: const Color(0xFF15803D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal Visual Feature Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.isHindi ? 'मृदा स्वास्थ्य व खाद' : 'Soil Health & Fertilizer',
                    subtitle: lang.isHindi ? 'NPK जांचें, सही खाद जानें' : 'Test soil, get NPK plan',
                    badge: lang.isHindi ? 'सॉइल कार्ड' : 'Soil Health',
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
                    title: lang.isHindi ? 'फसल विकास कैलेंडर' : 'Crop Growth Calendar',
                    subtitle: lang.isHindi ? 'अंकुरण से कटाई का रोडमैप' : 'Sowing to harvest schedule',
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
                    subtitle: lang.isHindi ? 'पीएम-किसान, सोलर पंप' : 'PM-Kisan, Solar subsidy',
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
                    title: lang.isHindi ? 'फसल बुवाई व मौसम चक्र' : 'Crop Sowing & Seasons',
                    subtitle: lang.isHindi ? 'खरीफ, रबी व जायद सलाह' : 'Kharif, Rabi, Zaid tips',
                    badge: lang.isHindi ? 'बुवाई' : 'Sowing',
                    imagePath: 'assets/images/sowing_seasons_hero.png',
                    onTap: () => onNavigateTab(3),
                  ),
                  const SizedBox(width: 12),
                  _buildVisualGuideCard(
                    context: context,
                    title: lang.isHindi ? 'मौसम व बारिश अलर्ट' : 'Weather & Rain Alerts',
                    subtitle: lang.isHindi ? 'मौसम के अनुसार कृषि सलाह' : 'Climate-smart farm guide',
                    badge: lang.isHindi ? 'मौसम' : 'Weather',
                    imagePath: 'assets/images/weather_advisory_hero.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WeatherAlertScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 6. Smart Alert & Farm Advisory Ribbon (Single Inset Surface)
            if (weather != null) ...[
              Builder(
                builder: (context) {
                  final alerts = WeatherAlertService().generateAlerts(weather);
                  final topAlert = alerts.isNotEmpty ? alerts.first : null;

                  return Column(
                    children: [
                      if (topAlert != null)
                        BouncyTap(
                          onTap: () {
                            HapticHelper.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WeatherAlertScreen()),
                            );
                          },
                          scaleDown: 0.97,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: topAlert.severityBgColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: topAlert.severityColor.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(topAlert.icon, color: topAlert.severityColor, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 6,
                                        runSpacing: 2,
                                        children: [
                                          PulseBadge(
                                            label: lang.isHindi ? topAlert.shortSeverityLabelHindi : topAlert.shortSeverityLabelEnglish,
                                            color: topAlert.severityColor,
                                          ),
                                          Text(
                                            lang.isHindi ? '• ICAR अलर्ट' : '• ICAR Alert',
                                            style: AppTypography.bodySmall().copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        lang.isHindi ? topAlert.titleHindi : topAlert.titleEnglish,
                                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textMuted),
                              ],
                            ),
                          ),
                        ),

                      // Agro Advisory Pill
                      BouncyTap(
                        onTap: () => onNavigateTab(3),
                        scaleDown: 0.98,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(LucideIcons.sprout, color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.tr('weatherCardTitle'),
                                      style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      lang.isHindi ? weather.advisoryHindi : weather.advisory,
                                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 16),
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
