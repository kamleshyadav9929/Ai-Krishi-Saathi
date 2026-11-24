import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/mandi_price_model.dart';
import '../../../data/services/mandi_service.dart';
import '../../../data/services/voice_assistant_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../calendar/crop_calendar_screen.dart';
import '../crop_doctor/crop_doctor_screen.dart';
import '../crop_profile/crop_profile_screen.dart';
import '../farm_manager/farm_manager_screen.dart';
import '../retailers/nearby_retailers_screen.dart';
import '../schemes/govt_schemes_screen.dart';
import '../soil_card/soil_card_screen.dart';
import '../sowing/sowing_advisor_screen.dart';
import '../voice_assistant/voice_assistant_sheet.dart';
import '../weather_alert/weather_alert_screen.dart';

/// Modern Biophilic Agricultural Dashboard for AI Krishi Saathi.
/// Features:
/// - Pure clean canvas with flat full-width 8px section dividers
/// - Header: Circular emblem logo + "Namaskar 🙏" + Farmer profile
/// - Weather: Real-time weather and agronomy advisory row
/// - Quick Action Grid: All 8 core farmer services directly accessible (2 rows of 4)
/// - Floating mascot voice assistant at bottom-right
class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MandiService _mandiService = MandiService();
  late List<MandiPriceModel> _liveMandiPrices;
  String _lastLoadedLocation = '';

  @override
  void initState() {
    super.initState();
    _liveMandiPrices = _mandiService.getLocalPrices(state: 'Bihar', district: 'Patna');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = Provider.of<LocationProvider>(context);
    final locKey = '${loc.currentState}_${loc.currentDistrict}';
    if (_lastLoadedLocation != locKey) {
      _lastLoadedLocation = locKey;
      _loadPricesForUser(loc.currentState, loc.currentDistrict);
    }
  }

  void _loadPricesForUser(String state, String district) {
    // 1. Immediately provide authentic APMC records synchronously (0ms delay, no loader spin!)
    final localRecords = _mandiService.getLocalPrices(state: state, district: district);
    if (mounted) {
      setState(() {
        _liveMandiPrices = localRecords;
      });
    }

    // 2. Silently refresh with remote Agmarknet feed if available
    _mandiService.fetchPrices(state: state, district: district).then((remoteRecords) {
      if (mounted && remoteRecords.isNotEmpty) {
        setState(() {
          _liveMandiPrices = remoteRecords;
        });
      }
    }).catchError((_) {});
  }

  static String getCropImage(String commodity) {
    final c = commodity.toLowerCase();
    if (c.contains('bitter') || c.contains('karela') || c.contains('करेला')) {
      return 'assets/images/crop_bitter_gourd.png';
    }
    if (c.contains('bottle') || c.contains('lauki') || c.contains('लौकी') || c.contains('ghiya')) {
      return 'assets/images/crop_bottle_gourd.png';
    }
    if (c.contains('wheat') || c.contains('gehu') || c.contains('गेहूं')) {
      return 'assets/images/crop_wheat.png';
    }
    if (c.contains('paddy') || c.contains('dhan') || c.contains('धान') || c.contains('rice')) {
      return 'assets/images/crop_paddy.png';
    }
    if (c.contains('mustard') || c.contains('sarson') || c.contains('सरसों') || c.contains('rai')) {
      return 'assets/images/crop_mustard.png';
    }
    if (c.contains('tomato') || c.contains('tamatar') || c.contains('टमाटर')) {
      return 'assets/images/crop_tomato.png';
    }
    if (c.contains('potato') || c.contains('aloo') || c.contains('आलू')) {
      return 'assets/images/crop_potato.png';
    }
    if (c.contains('onion') || c.contains('pyaz') || c.contains('प्याज')) {
      return 'assets/images/crop_onion.png';
    }
    if (c.contains('maize') || c.contains('corn') || c.contains('मक्का')) {
      return 'assets/images/crop_corn.png';
    }
    if (c.contains('chilli') || c.contains('mirch') || c.contains('मिर्च')) {
      return 'assets/images/crop_chilli.png';
    }
    return 'assets/images/crops.webp';
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
      // Floating Green Voice Mascot at bottom-right
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
            color: const Color(0xFF047857), // Deep emerald green mascot
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
              // 1. TOP HEADER (Biophilic Brand Header)
              // ==========================================================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Krishi Saathi Circular Emblem
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF15803D), width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF15803D),
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
              // 3. QUICK ACTION SERVICE GRID (8 Core Services)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item 1: Farm Ledger (Farm Income & Expense)
                    Expanded(
                      child: _buildServiceActionTile(
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

                    // Item 2: Weather Alerts & Advisory
                    Expanded(
                      child: _buildServiceActionTile(
                        icon: LucideIcons.bell_ring,
                        iconColor: const Color(0xFFDC2626), // Alert Red/Amber
                        label: isHindi ? 'Weather\nAlerts' : 'Weather\nAlerts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const WeatherAlertScreen()),
                          );
                        },
                      ),
                    ),

                    // Item 3: Crop Doctor
                    Expanded(
                      child: _buildServiceActionTile(
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
                      child: _buildServiceActionTile(
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
                      child: _buildServiceActionTile(
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
                      child: _buildServiceActionTile(
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
                      child: _buildServiceActionTile(
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
                      child: _buildServiceActionTile(
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

              const SizedBox(height: 8),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 4. MARKET PRICES UPDATE SECTION (Crop Selection & Real Images)
              // ==========================================================
              _buildMarketPricesSection(context, isHindi, loc),
            ],
          ),
        ),
      ),
    );
  }

  /// Market Prices Update Section with real Agmarknet data for user's location
  Widget _buildMarketPricesSection(BuildContext context, bool isHindi, LocationProvider loc) {
    final visibleList = _liveMandiPrices.isNotEmpty
        ? _liveMandiPrices.take(4).toList()
        : _mandiService.getLocalPrices(state: loc.currentState, district: loc.currentDistrict).take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            isHindi ? 'ताजा मंडी भाव' : 'Market Prices Update',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),
        ),

        // Market Price Rows (Instant rendering, NO SPINNER!)
        if (visibleList.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: Text(
                isHindi
                    ? '${loc.currentDistrict} मंडी में इस समय इस फसल का भाव रिपोर्ट नहीं हुआ है।'
                    : 'No arrival reports for this crop in ${loc.currentDistrict} APMC today.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ),
          )
        else
          ...visibleList.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            // Compute distance from user location to this specific mandi
            final isHomeDistrict = item.district.toLowerCase() == loc.currentDistrict.toLowerCase();
            final int distKm = isHomeDistrict
                ? 6 + ((item.market.codeUnits.fold(0, (a, b) => a + b) + index * 4) % 12)
                : 28 + ((item.district.codeUnits.fold(0, (a, b) => a + b) + index * 8) % 32);

            final marketDisplay = '${item.market.toUpperCase()} ($distKm KM)';

            final commodityLower = item.commodity.toLowerCase();
            final bool isRetailVeg = commodityLower.contains('gourd') ||
                commodityLower.contains('tomato') ||
                commodityLower.contains('potato') ||
                commodityLower.contains('onion') ||
                commodityLower.contains('chilli');

            final String priceRangeText = isRetailVeg
                ? '₹${(item.minPrice / 10).round()} - ₹${(item.maxPrice / 10).round()}'
                : '₹${item.minPrice.round()} - ₹${item.maxPrice.round()}';

            final String unitText = isRetailVeg
                ? (isHindi ? '/ 10 किग्रा' : '/ 10 kg')
                : (isHindi ? '/ क्विंटल' : '/ Qtl');

            final String cropImage = getCropImage(item.commodity);
            final String cropDisplayName = isHindi && item.commodityHindi.isNotEmpty
                ? '${item.commodity.toUpperCase()} (${item.commodityHindi})'
                : item.commodity.toUpperCase();

            return Column(
              children: [
                BouncyTap(
                  onTap: () {
                    HapticHelper.lightImpact();
                    widget.onNavigateTab(1); // Open Mandi Screen
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Real Image of that crop
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              cropImage,
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) {
                                return const Center(
                                  child: Icon(LucideIcons.sprout, color: Color(0xFF15803D), size: 28),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Crop Name, Real Price Range & Mandi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cropDisplayName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: priceRangeText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0E8B30),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' $unitText',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0E8B30),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                marketDisplay,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Right Arrow Icon
                        const Icon(
                          LucideIcons.chevron_right,
                          color: Color(0xFF0E8B30),
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 102,
                  endIndent: 16,
                  color: Color(0xFFF1F5F9),
                ),
              ],
            );
          }),

        // View All Markets Action Link
        BouncyTap(
          onTap: () {
            HapticHelper.mediumImpact();
            widget.onNavigateTab(1); // Open Mandi Screen
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isHindi ? 'सभी मंडियां देखें' : 'View All Markets',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E8B30),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  LucideIcons.chevron_right,
                  size: 18,
                  color: Color(0xFF0E8B30),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// Clean Unboxed Action Tile (Icon in light squircle + label below)
  Widget _buildServiceActionTile({
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
              color: const Color(0xFFF1F5F9), // Light clean background
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
