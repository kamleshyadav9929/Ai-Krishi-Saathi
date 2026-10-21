import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/pulse_badge.dart';
import '../weather_alert/weather_alert_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    final weather = loc.currentWeather;
    final isLoading = loc.isLoading && weather == null;

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'weatherHeader'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () async {
                HapticHelper.lightImpact();
                await loc.detectCurrentLocation();
              },
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. GPS Location Capsule Bar
                    _buildLocationCapsule(loc, lang, context),
                    const SizedBox(height: 12),

                    // Visual Weather Advisory Hero Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/weather_advisory_hero.png',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.76),
                                    Colors.black.withValues(alpha: 0.38),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      lang.isHindi ? 'मौसम व कृषि सलाह' : 'Agro-Weather Advisory',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    lang.isHindi
                                        ? 'मानसून, वर्षा व तापमान\nका सटीक पूर्वानुमान'
                                        : 'Monsoon, Rain & Heat\nSmart Farming Forecast',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lang.isHindi
                                        ? 'सिंचाई, कीटनाशक व कटाई की सही योजना बनाएं'
                                        : 'Plan irrigation, spraying & harvest with confidence',
                                    style: const TextStyle(
                                      color: Color(0xFFE0F2FE),
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
                    ),
                    const SizedBox(height: 12),

                    // 2. Weather & Pest Alert Button Banner
                    _buildAlertBanner(context, lang),
                    const SizedBox(height: 14),

                    if (weather != null) ...[
                      // 3. Apple/Kiwi-Style Hero Temperature Cockpit
                      _buildHeroWeatherCockpit(weather, lang),
                      const SizedBox(height: 14),

                      // 4. ICAR Farming Advisory Ribbon
                      _buildAgroAdvisoryRibbon(weather, lang),
                      const SizedBox(height: 20),

                      // 5. Unified 7-Day Forecast Card (Zero Card-Fatigue)
                      Text(
                        lang.tr('weeklyForecast'),
                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildWeeklyForecastCard(weather, lang),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLocationCapsule(LocationProvider loc, LanguageProvider lang, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: loc.isGpsDetected ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              loc.isGpsDetected ? LucideIcons.map_pin : LucideIcons.navigation,
              size: 17,
              color: loc.isGpsDetected ? AppColors.primary : const Color(0xFFD97706),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        loc.locationTitle,
                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (loc.isGpsDetected)
                      const PulseBadge(
                        label: 'GPS',
                        color: AppColors.primary,
                        size: 5.5,
                      ),
                  ],
                ),
                Text(
                  loc.latitude != null && loc.longitude != null
                      ? 'Lat: ${loc.latitude!.toStringAsFixed(2)}, Lon: ${loc.longitude!.toStringAsFixed(2)}'
                      : (lang.isHindi ? 'स्थान सक्रिय है' : 'Location active'),
                  style: AppTypography.bodySmall().copyWith(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          BouncyTap(
            onTap: () async {
              HapticHelper.lightImpact();
              await loc.detectCurrentLocation();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.locate_fixed, size: 14, color: AppColors.primaryDark),
                  const SizedBox(width: 4),
                  Text(
                    lang.isHindi ? 'ताजा करें' : 'Refresh',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner(BuildContext context, LanguageProvider lang) {
    return BouncyTap(
      onTap: () {
        HapticHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherAlertScreen()),
        );
      },
      scaleDown: 0.98,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.shield_alert, color: Color(0xFFDC2626), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PulseBadge(
                        label: 'LIVE',
                        color: Color(0xFFDC2626),
                        size: 5.5,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        lang.tr('weatherAlertsTitle'),
                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF991B1B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.isHindi
                        ? 'पाला, बारिश, लू व कीट-रोग पूर्व-चेतावनी देखें'
                        : 'View frost, rain, heatwave & pest alerts',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 11,
                      color: const Color(0xFF7F1D1D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevron_right, size: 18, color: Color(0xFFDC2626)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroWeatherCockpit(dynamic weather, LanguageProvider lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City & Source Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weather.location,
                style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'IMD & Open-Meteo',
                  style: AppTypography.bodySmall().copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Big Temperature + Weather Condition
          Row(
            children: [
              AnimatedCounter(
                value: (weather.temperature as num).toDouble(),
                suffix: '°C',
                fractionDigits: 0,
                style: AppTypography.metricValue().copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.isHindi ? weather.conditionHindi : weather.condition,
                      style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(LucideIcons.cloud_rain, size: 14, color: Color(0xFF0284C7)),
                        const SizedBox(width: 4),
                        Text(
                          '${lang.tr('rainChance')}: ${weather.rainProbability}%',
                          style: AppTypography.bodySmall().copyWith(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4-Pill Micro-Climate Grid (Humidity, Wind, Rain, Comfort)
          Row(
            children: [
              Expanded(
                child: _buildMetricPill(
                  icon: LucideIcons.droplets,
                  label: lang.tr('humidity'),
                  value: '${weather.humidity}%',
                  color: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFE0F2FE),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricPill(
                  icon: LucideIcons.wind,
                  label: lang.tr('windSpeed'),
                  value: '${weather.windSpeed} km/h',
                  color: const Color(0xFF059669),
                  bgColor: const Color(0xFFD1FAE5),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricPill(
                  icon: LucideIcons.cloud_rain,
                  label: lang.isHindi ? 'वर्षा' : 'Rain',
                  value: '${weather.rainProbability}%',
                  color: const Color(0xFF7E22CE),
                  bgColor: const Color(0xFFF3E8FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAgroAdvisoryRibbon(dynamic weather, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
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
                  lang.tr('farmingAlert'),
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lang.isHindi ? weather.advisoryHindi : weather.advisory,
                  style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyForecastCard(dynamic weather, LanguageProvider lang) {
    final list = weather.weeklyForecast;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(list.length, (index) {
          final df = list[index];
          final isLast = index == list.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Day Name
                    SizedBox(
                      width: 90,
                      child: Text(
                        lang.isHindi ? df.dayNameHindi : df.dayName,
                        style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // Rain Probability Pill
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.cloud_rain, size: 14, color: Color(0xFF0284C7)),
                        const SizedBox(width: 4),
                        Text(
                          '${df.rainChance}%',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Max / Min Temp
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${df.maxTemp.toInt()}°',
                          style: AppTypography.metricValue().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          ' / ${df.minTemp.toInt()}°C',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 0.8,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.black.withValues(alpha: 0.05),
                ),
            ],
          );
        }),
      ),
    );
  }
}
