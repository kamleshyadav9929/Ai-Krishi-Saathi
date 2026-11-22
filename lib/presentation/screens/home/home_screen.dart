import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/services/voice_assistant_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../calendar/crop_calendar_screen.dart';
import '../crop_doctor/crop_doctor_screen.dart';
import '../crop_profile/crop_profile_screen.dart';
import '../farm_manager/farm_manager_screen.dart';
import '../products/agri_products_screen.dart';
import '../retailers/nearby_retailers_screen.dart';
import '../schemes/govt_schemes_screen.dart';
import '../soil_card/soil_card_screen.dart';
import '../sowing/sowing_advisor_screen.dart';
import '../voice_assistant/voice_assistant_sheet.dart';
import '../weather_alert/weather_alert_screen.dart';

/// FarmRise 1:1 Pixel-Perfect Authentic Home Screen for AI Krishi Saathi.
/// Matches Bayer FarmRise's exact decompiled layout, flat surfaces, and spacing:
/// - Pure white canvas with flat full-width 8px section dividers (NO boxy cards!)
/// - Header: Circular emblem logo + "Namaskar 🙏" + Gold Coin reward pill
/// - Weather: Pure flat row directly on white background
/// - Quick Action Grid: All 8 services directly visible (2 rows of 4)
/// - Floating mascot chatbot button at bottom-right
class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _userCoins = 0;

  void _showCoinRewardSheet(BuildContext context, bool isHindi) {
    HapticHelper.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                    ),
                    child: const Center(
                      child: Text(
                        'B',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHindi ? 'बायरा किसान सिक्के (Rewards)' : 'Bayer Farmer Coins',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        isHindi ? 'कुल उपलब्ध सिक्के: $_userCoins' : 'Available Balance: $_userCoins Coins',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF15803D)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'सिक्के कैसे कमाएं?' : 'How to earn coins?',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isHindi
                          ? '• फसल डॉक्टर से रोग पहचान करने पर 20 सिक्के\n• खेत प्रोफाइल पूरा करने पर 100 सिक्के\n• नियमित दैनिक कृषि सलाह देखने पर 10 सिक्के'
                          : '• Diagnose plant disease via Crop Doctor (+20 coins)\n• Complete your farm profile (+100 coins)\n• Check daily agronomy advisory (+10 coins)',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E8B30),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(isHindi ? 'समझ गया' : 'Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    final isHindi = lang.isHindi;
    final weather = loc.currentWeather;

    final tempString = weather != null ? '${weather.temperature.round()}°' : '21°';
    final conditionString = weather != null
        ? (isHindi ? weather.conditionHindi : weather.condition)
        : (isHindi ? 'बादल, बारिश नहीं' : 'Cloudy, No Rain');

    return Scaffold(
      backgroundColor: Colors.white,
      // FarmRise Floating Green Mascot Chatbot at bottom-right
      floatingActionButton: BouncyTap(
        onTap: () {
          HapticHelper.mediumImpact();
          VoiceAssistantSheet.show(
            context,
            onVoiceAction: (intent) {
              switch (intent) {
                case VoiceActionIntent.navigateMandi:
                  widget.onNavigateTab(1);
                  break;
                case VoiceActionIntent.navigateCropDoctor:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const CropDoctorScreen()),
                  );
                  break;
                case VoiceActionIntent.navigateSowing:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const SowingAdvisorScreen()),
                  );
                  break;
                case VoiceActionIntent.navigateSoilCard:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const SoilCardScreen()),
                  );
                  break;
                case VoiceActionIntent.navigateCalendar:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const CropCalendarScreen()),
                  );
                  break;
                case VoiceActionIntent.navigateSchemes:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const GovtSchemesScreen()),
                  );
                  break;
                case VoiceActionIntent.navigateFarmManager:
                  widget.onNavigateTab(3);
                  break;
                case VoiceActionIntent.navigateCropProfile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const CropProfileScreen()),
                  );
                  break;
                case VoiceActionIntent.navigateAlerts:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const WeatherAlertScreen()),
                  );
                  break;
                case VoiceActionIntent.none:
                  break;
              }
            },
          );
        },
        scaleDown: 0.92,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF047857), // Deep emerald green matching FarmRise mascot
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF047857).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mascot Face
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF86EFAC),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(radius: 2.5, backgroundColor: Color(0xFF065F46)),
                        CircleAvatar(radius: 2.5, backgroundColor: Color(0xFF065F46)),
                      ],
                    ),
                  ),
                ),
              ),
              // Top antenna leaf
              const Positioned(
                top: 8,
                child: Icon(LucideIcons.sprout, size: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // 1. TOP HEADER (FarmRise Signature Clean Header)
              // ==========================================================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Bayer Circular Cross Logo Emblem
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF0284C7), width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0284C7),
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.sprout,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Greeting Text: "Namaskar 🙏"
                    Expanded(
                      child: Text(
                        isHindi ? 'नमस्कार  🙏' : 'Namaskar  🙏',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    // Bayer Gold Coin Capsule Pill (bayerCoinsLayout)
                    BouncyTap(
                      onTap: () => _showCoinRewardSheet(context, isHindi),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF59E0B),
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Center(
                                child: Text(
                                  'B',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_userCoins',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hairline 1px Divider under Header
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

              // ==========================================================
              // 2. WEATHER (Directly on white background - NO BOX)
              // ==========================================================
              BouncyTap(
                onTap: () async {
                  HapticHelper.lightImpact();
                  await loc.detectCurrentLocation();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Weather Location & Description Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today, ${loc.locationTitle}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              conditionString,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Temperature & Cloud Icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            tempString,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.cloud,
                            size: 28,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 3. 4 QUICK ACTION TILES (Authentic FarmRise Layout)
              // (Icons in rounded squircle, labels BELOW icons - NO BOXES!)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item 1: Farm Ledger (Farm Income & Expense)
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.calculator,
                        iconColor: const Color(0xFF0284C7), // Blue
                        label: isHindi ? 'Farm\nLedger' : 'Farm\nLedger',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const FarmManagerScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 2: Bayer Products Catalog
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.flask_conical,
                        iconColor: const Color(0xFF0284C7), // Blue
                        label: isHindi ? 'Bayer\nProducts' : 'Bayer\nProducts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const AgriProductsScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 3: Crop Doctor
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.stethoscope,
                        iconColor: const Color(0xFF0E8B30), // Green
                        label: isHindi ? 'Crop\nDoctor' : 'Crop\nDoctor',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const CropDoctorScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 4: Nearby Retailers
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.store,
                        iconColor: const Color(0xFFD97706), // Amber
                        label: isHindi ? 'Nearby\nRetailers' : 'Nearby\nRetailers',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const NearbyRetailersScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Row 2 of Services (All Services shown)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item 5: Sowing Advisor
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.sprout,
                        iconColor: const Color(0xFF0E8B30),
                        label: isHindi ? 'Sowing\nAdvisor' : 'Sowing\nAdvisor',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const SowingAdvisorScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 6: Crop Calendar
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.calendar_days,
                        iconColor: const Color(0xFF0284C7),
                        label: isHindi ? 'Crop\nCalendar' : 'Crop\nCalendar',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const CropCalendarScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 7: Soil Health Card
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.test_tube,
                        iconColor: const Color(0xFF7C3AED),
                        label: isHindi ? 'Soil Health\nCard' : 'Soil Health\nCard',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const SoilCardScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 8: Govt Schemes
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.landmark,
                        iconColor: const Color(0xFFD97706),
                        label: isHindi ? 'Govt\nSchemes' : 'Govt\nSchemes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const GovtSchemesScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Authentic FarmRise Unboxed Action Tile (Icon in light squircle + label below)
  Widget _buildFarmRiseActionTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return BouncyTap(
      onTap: () {
        HapticHelper.lightTap();
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Light Squircle Icon Tile (NO OUTER CARD BOX!)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Light clean background from FarmRise
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          // Label directly on white canvas (NO BOX!)
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
              height: 1.25,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
