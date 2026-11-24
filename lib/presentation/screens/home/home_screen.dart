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
  String _selectedCropFilter = 'all';

  static const List<Map<String, String>> _cropFilters = [
    {'id': 'all', 'en': 'All Crops', 'hi': 'सभी फसलें'},
    {'id': 'bitter_gourd', 'en': 'Bitter Gourd', 'hi': 'करेला'},
    {'id': 'bottle_gourd', 'en': 'Bottle Gourd', 'hi': 'लौकी'},
    {'id': 'wheat', 'en': 'Wheat', 'hi': 'गेहूं'},
    {'id': 'paddy', 'en': 'Paddy', 'hi': 'धान'},
    {'id': 'mustard', 'en': 'Mustard', 'hi': 'सरसों'},
    {'id': 'tomato', 'en': 'Tomato', 'hi': 'टमाटर'},
    {'id': 'potato', 'en': 'Potato', 'hi': 'आलू'},
    {'id': 'onion', 'en': 'Onion', 'hi': 'प्याज'},
    {'id': 'corn', 'en': 'Maize', 'hi': 'मक्का'},
    {'id': 'chilli', 'en': 'Chilli', 'hi': 'मिर्च'},
  ];

  static const List<_HomeCropMarketItem> _cropMarketItems = [
    _HomeCropMarketItem(
      id: 'bitter_gourd',
      nameEn: 'BITTER GOURD',
      nameHi: 'करेला',
      priceRange: '₹320 - ₹350',
      unit: '/ 10 kg',
      defaultMarket: 'BHOJPUR',
      defaultDistanceKm: 43,
      imageAsset: 'assets/images/crop_bitter_gourd.jpg',
    ),
    _HomeCropMarketItem(
      id: 'bottle_gourd',
      nameEn: 'BOTTLE GOURD',
      nameHi: 'लौकी',
      priceRange: '₹200 - ₹250',
      unit: '/ 10 kg',
      defaultMarket: 'BHOJPUR',
      defaultDistanceKm: 43,
      imageAsset: 'assets/images/crop_bottle_gourd.jpg',
    ),
    _HomeCropMarketItem(
      id: 'wheat',
      nameEn: 'WHEAT',
      nameHi: 'गेहूं (लोकवन/कल्याण)',
      priceRange: '₹2,275 - ₹2,450',
      unit: '/ क्विंटल',
      defaultMarket: 'PATNA APMC',
      defaultDistanceKm: 12,
      imageAsset: 'assets/images/crop_wheat.jpg',
    ),
    _HomeCropMarketItem(
      id: 'paddy',
      nameEn: 'PADDY (DHAN)',
      nameHi: 'धान (बासमती व कॉमन)',
      priceRange: '₹2,183 - ₹2,350',
      unit: '/ क्विंटल',
      defaultMarket: 'DANAPUR',
      defaultDistanceKm: 8,
      imageAsset: 'assets/images/crop_paddy.jpg',
    ),
    _HomeCropMarketItem(
      id: 'mustard',
      nameEn: 'MUSTARD',
      nameHi: 'सरसों / राई',
      priceRange: '₹5,400 - ₹5,850',
      unit: '/ क्विंटल',
      defaultMarket: 'BIHAR SHARIF',
      defaultDistanceKm: 65,
      imageAsset: 'assets/images/crop_mustard.jpg',
    ),
    _HomeCropMarketItem(
      id: 'tomato',
      nameEn: 'TOMATO',
      nameHi: 'टमाटर (देसी/हाइब्रिड)',
      priceRange: '₹250 - ₹350',
      unit: '/ 10 kg',
      defaultMarket: 'PATNA MANDI',
      defaultDistanceKm: 12,
      imageAsset: 'assets/images/crop_tomato.jpg',
    ),
    _HomeCropMarketItem(
      id: 'potato',
      nameEn: 'POTATO',
      nameHi: 'आलू (चिप्सोना/सफेद)',
      priceRange: '₹160 - ₹220',
      unit: '/ 10 kg',
      defaultMarket: 'BIHTA',
      defaultDistanceKm: 28,
      imageAsset: 'assets/images/crop_potato.jpg',
    ),
    _HomeCropMarketItem(
      id: 'onion',
      nameEn: 'ONION',
      nameHi: 'प्याज (लाल नासिक)',
      priceRange: '₹300 - ₹420',
      unit: '/ 10 kg',
      defaultMarket: 'FATUHA',
      defaultDistanceKm: 22,
      imageAsset: 'assets/images/crop_onion.jpg',
    ),
    _HomeCropMarketItem(
      id: 'corn',
      nameEn: 'MAIZE (CORN)',
      nameHi: 'मक्का (पीला दाना)',
      priceRange: '₹1,950 - ₹2,200',
      unit: '/ क्विंटल',
      defaultMarket: 'SAMASTIPUR',
      defaultDistanceKm: 78,
      imageAsset: 'assets/images/crop_corn.jpg',
    ),
    _HomeCropMarketItem(
      id: 'chilli',
      nameEn: 'GREEN CHILLI',
      nameHi: 'हरी मिर्च',
      priceRange: '₹650 - ₹850',
      unit: '/ 10 kg',
      defaultMarket: 'PATNA APMC',
      defaultDistanceKm: 12,
      imageAsset: 'assets/images/crop_chilli.jpg',
    ),
  ];

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

  /// Interactive Market Prices Update Section matching exact farmer dashboard design
  Widget _buildMarketPricesSection(BuildContext context, bool isHindi, LocationProvider loc) {
    final visibleCrops = _selectedCropFilter == 'all'
        ? _cropMarketItems.take(3).toList()
        : _cropMarketItems.where((c) => c.id == _selectedCropFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'ताजा मंडी भाव' : 'Market Prices Update',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isHindi ? 'लाइव भाव' : 'Live Mandi',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal Crop Selection Pills
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _cropFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _cropFilters[index];
              final isSelected = _selectedCropFilter == filter['id'];
              final label = isHindi ? filter['hi']! : filter['en']!;

              return BouncyTap(
                onTap: () {
                  HapticHelper.lightImpact();
                  setState(() {
                    _selectedCropFilter = filter['id']!;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF15803D) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF15803D).withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Market Price Rows
        ...visibleCrops.map((crop) {
          // Adjust distance display grounded in user's state/district if available
          final marketText = '${crop.defaultMarket} (${crop.defaultDistanceKm} KM)';

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
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            crop.imageAsset,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) {
                              return const Center(
                                child: Icon(LucideIcons.sprout, color: Color(0xFF15803D), size: 30),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Crop Name, Price Range & Mandi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              crop.nameEn,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: crop.priceRange,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0E8B30),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${crop.unit}',
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
                              marketText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.2,
                              ),
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

/// Helper model for Home Screen Market Prices Update
class _HomeCropMarketItem {
  final String id;
  final String nameEn;
  final String nameHi;
  final String priceRange;
  final String unit;
  final String defaultMarket;
  final int defaultDistanceKm;
  final String imageAsset;

  const _HomeCropMarketItem({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.priceRange,
    required this.unit,
    required this.defaultMarket,
    required this.defaultDistanceKm,
    required this.imageAsset,
  });
}
