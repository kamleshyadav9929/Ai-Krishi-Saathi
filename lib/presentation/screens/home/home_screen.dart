import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/services/mandi_service.dart';
import '../../../data/services/voice_assistant_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../anti_counterfeit/anti_counterfeit_screen.dart';
import '../calendar/crop_calendar_screen.dart';
import '../crop_doctor/crop_doctor_screen.dart';
import '../crop_profile/crop_profile_screen.dart';
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
/// - Important Updates!: Soft unbordered mint banner with chevron toggle
/// - WhatsApp Updates: Clean unboxed flat card with vibrant green "Turn on" button
/// - Quick Action Grid: 4 light icon tiles with labels OUTSIDE/BELOW the icons
/// - Videos for you: Authentic horizontal carousel with search pill
/// - Mandi Price Update: Live Agmarknet rates with "View All Markets →"
/// - Crop Calendar: Active crop stage + daily ICAR agronomy + TTS audio playback
/// - Floating mascot chatbot button at bottom-right
class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  bool _isPlayingAudio = false;
  bool _isUpdatesExpanded = true;
  bool _isQuickLinksExpanded = false;
  bool _isWhatsAppSubscribed = false;
  final int _userCoins = 0;

  @override
  void dispose() {
    _voiceService.stopSpeaking();
    super.dispose();
  }

  Future<void> _toggleAdvisoryAudio(String text) async {
    HapticHelper.lightImpact();
    if (_isPlayingAudio) {
      await _voiceService.stopSpeaking();
      setState(() => _isPlayingAudio = false);
    } else {
      setState(() => _isPlayingAudio = true);
      await _voiceService.speak(text, isHindi: true);
      if (mounted) setState(() => _isPlayingAudio = false);
    }
  }

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
                          ? '• असली बायर दवाओं के QR कोड स्कैन करने पर 50 सिक्के\n• फसल डॉक्टर से रोग पहचान करने पर 20 सिक्के\n• खेत प्रोफाइल पूरा करने पर 100 सिक्के'
                          : '• Scan genuine Bayer product QR codes (+50 coins)\n• Diagnose plant disease via Crop Doctor (+20 coins)\n• Complete your farm profile (+100 coins)',
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
    final mandiService = MandiService();
    final tickerPrices = mandiService.getTickerPrices(state: loc.currentState);

    const activeCropDailyText =
        'राम राम किसान भाई! आपकी गेहूं की फसल आज 35 दिन की हो चुकी है। कल्ले फूटने (Tillering) की यह अवस्था अत्यंत महत्वपूर्ण है। खेत में पर्याप्त नमी रखें और प्रति एकड़ 40 से 45 किग्रा यूरिया की पहली टॉप-ड्रेसिंग करें। पीला रतुआ रोग की नियमित निगरानी रखें।';

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
                  widget.onNavigateTab(4);
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
              // 3. IMPORTANT UPDATES! (Expandable clean banner)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        HapticHelper.lightTap();
                        setState(() => _isUpdatesExpanded = !_isUpdatesExpanded);
                      },
                      child: Row(
                        children: [
                          const Text('📣', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(
                            isHindi ? 'Important Updates!' : 'Important Updates!',
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            _isUpdatesExpanded ? LucideIcons.chevron_up : LucideIcons.chevron_down,
                            size: 20,
                            color: const Color(0xFF0E8B30),
                          ),
                        ],
                      ),
                    ),
                    if (_isUpdatesExpanded) ...[
                      const SizedBox(height: 10),
                      BouncyTap(
                        onTap: () {
                          HapticHelper.lightTap();
                          widget.onNavigateTab(4); // Navigate to Profile / My Farm
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6FBF7), // Soft mint tint from FarmRise
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCFCE7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    LucideIcons.sparkles,
                                    color: Color(0xFF0E8B30),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isHindi ? 'अपनी प्रोफाइल पूरी करें' : 'Complete your profile',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isHindi
                                          ? 'व्यक्तिगत कृषि अनुभव और सटीक सलाह पाएं'
                                          : 'Unlock a personalised experience',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6B7280),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0E8B30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.arrow_right,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 4. GET WHATSAPP UPDATES (Clean FarmRise Card - NO BOX BORDER!)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // WhatsApp Green Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.message_circle,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Text
                      Expanded(
                        child: Text(
                          isHindi ? 'व्हाट्सएप पर अपडेट पाएं' : 'Get WhatsApp Updates',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),

                      // Turn On Button
                      ElevatedButton(
                        onPressed: () {
                          HapticHelper.mediumImpact();
                          setState(() => _isWhatsAppSubscribed = !_isWhatsAppSubscribed);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isWhatsAppSubscribed
                                    ? (isHindi
                                        ? '✅ व्हाट्सएप अलर्ट सफलतापूर्वक सक्रिय हो गया!'
                                        : '✅ WhatsApp daily alerts enabled!')
                                    : (isHindi ? 'व्हाट्सएप अलर्ट बंद कर दिया गया।' : 'WhatsApp alerts paused.'),
                              ),
                              backgroundColor: const Color(0xFF0E8B30),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isWhatsAppSubscribed ? const Color(0xFF64748B) : const Color(0xFF0E8B30),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          _isWhatsAppSubscribed
                              ? (isHindi ? 'सक्रिय' : 'Active')
                              : (isHindi ? 'शुरू करें' : 'Turn on'),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 5. 4 QUICK ACTION TILES (Authentic FarmRise Layout)
              // (Icons in rounded squircle, labels BELOW icons - NO BOXES!)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item 1: Verify Bayer Products (Anti-Counterfeit)
                    Expanded(
                      child: _buildFarmRiseActionTile(
                        icon: LucideIcons.scan_line,
                        iconColor: const Color(0xFF0284C7), // Blue
                        label: isHindi ? 'Verify Bayer\nProducts' : 'Verify Bayer\nProducts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const AntiCounterfeitScreen()),
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

              // "View More ⌵" Expander Link
              Center(
                child: InkWell(
                  onTap: () {
                    HapticHelper.lightTap();
                    setState(() => _isQuickLinksExpanded = !_isQuickLinksExpanded);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isQuickLinksExpanded
                              ? (isHindi ? 'कम देखें' : 'View Less')
                              : (isHindi ? 'View More' : 'View More'),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0E8B30),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isQuickLinksExpanded ? LucideIcons.chevron_up : LucideIcons.chevron_down,
                          size: 18,
                          color: const Color(0xFF0E8B30),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Secondary Quick Links (When View More is toggled)
              if (_isQuickLinksExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

              const SizedBox(height: 6),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 6. VIDEOS FOR YOU (Horizontal Carousel with Search Pill)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi ? 'Videos for you' : 'Videos for you',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    InkWell(
                      onTap: () => widget.onNavigateTab(2), // Navigate to Videos tab
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.search, size: 14, color: Color(0xFF6B7280)),
                            SizedBox(width: 4),
                            Text(
                              'Search',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Videos Horizontal Carousel
              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildVideoCard(
                      views: '6.9K',
                      category: '9 गतिविधियाँ',
                      title: 'डायरेक्ट सीडेड राइस (DSR) व गेहूं में कल्ले',
                      channel: 'Bayer CropScience',
                      badgeColor: const Color(0xFF0E8B30),
                      thumbnailGradient: const [Color(0xFF065F46), Color(0xFF047857)],
                      onTap: () => widget.onNavigateTab(2),
                    ),
                    const SizedBox(width: 14),
                    _buildVideoCard(
                      views: '3.3K',
                      category: 'फसल सुरक्षा',
                      title: 'सरसों में माहू कीट नियंत्रण व स्प्रे की विधि',
                      channel: 'Bayer Academy',
                      badgeColor: const Color(0xFFD97706),
                      thumbnailGradient: const [Color(0xFF78350F), Color(0xFFB45309)],
                      onTap: () => widget.onNavigateTab(2),
                    ),
                    const SizedBox(width: 14),
                    _buildVideoCard(
                      views: '31.6K',
                      category: 'ड्रोन स्प्रे',
                      title: 'कृषि ड्रोन से नैनो यूरिया व कीटनाशक स्प्रे तकनीक',
                      channel: 'Agri Drone Pro',
                      badgeColor: const Color(0xFF0284C7),
                      thumbnailGradient: const [Color(0xFF0C4A6E), Color(0xFF0284C7)],
                      onTap: () => widget.onNavigateTab(2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 7. MANDI PRICE UPDATE (Matching FarmRise home_screen_mandi_card.xml)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Row(
                  children: [
                    const Icon(LucideIcons.map_pin, size: 16, color: Color(0xFF0E8B30)),
                    const SizedBox(width: 6),
                    Text(
                      isHindi ? 'MANDI PRICE UPDATE' : 'MANDI PRICE UPDATE',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0E8B30),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isHindi ? 'लाइव भाव' : 'Live APMC',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Mandi Listings (Clean flat rows)
              if (tickerPrices.isNotEmpty) ...[
                for (final item in tickerPrices.take(3))
                  InkWell(
                    onTap: () => widget.onNavigateTab(1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFEF3C7),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(LucideIcons.circle_dollar_sign, color: Color(0xFFD97706), size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isHindi ? item.commodityHindi : item.commodity,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                Text(
                                  '${item.market}, ${item.district}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${item.modalPrice.round()}/Q',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.trending_up, size: 12, color: Color(0xFF16A34A)),
                                  SizedBox(width: 2),
                                  Text(
                                    '+₹50',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],

              // View All Markets Link
              InkWell(
                onTap: () => widget.onNavigateTab(1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        isHindi ? 'सभी मंडियों के भाव देखें' : 'View All Markets',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0E8B30),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.arrow_right, size: 16, color: Color(0xFF0E8B30)),
                    ],
                  ),
                ),
              ),

              // Solid Gray Section Separator Bar
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 8. CROP CALENDAR & AGRONOMY (home_screen_crop_calendar_card.xml)
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi ? 'Crop Calendar' : 'Crop Calendar',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Text(
                      'PBW-502 • 35 Days',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E8B30),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.sprout, color: Color(0xFF0E8B30), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isHindi ? 'सक्रिय अवस्था: कल्ले फूटना (Tillering)' : 'Active Stage: Tillering Stage',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const Text(
                                  'DAS: 25 - 45 Days',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                                ),
                              ],
                            ),
                          ),
                          // TTS Audio Listen Button
                          BouncyTap(
                            onTap: () => _toggleAdvisoryAudio(activeCropDailyText),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _isPlayingAudio ? const Color(0xFFDCFCE7) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF0E8B30)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isPlayingAudio ? LucideIcons.volume_2 : LucideIcons.volume_1,
                                    size: 14,
                                    color: const Color(0xFF0E8B30),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isPlayingAudio ? (isHindi ? 'रोकें' : 'Stop') : (isHindi ? 'सुनें' : 'Listen'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0E8B30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isHindi
                            ? 'खेत में पर्याप्त नमी रखें और प्रति एकड़ 40 से 45 किग्रा यूरिया की पहली टॉप-ड्रेसिंग करें।'
                            : 'Maintain adequate moisture and apply first top-dressing of 45 kg Urea per acre.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
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

  /// Authentic FarmRise Video Card for Carousel
  Widget _buildVideoCard({
    required String views,
    required String category,
    required String title,
    required String channel,
    required Color badgeColor,
    required List<Color> thumbnailGradient,
    required VoidCallback onTap,
  }) {
    return BouncyTap(
      onTap: onTap,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail Container
            Container(
              height: 125,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: thumbnailGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Play Circle Button
                  Center(
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.play, color: Color(0xFF0E8B30), size: 20),
                      ),
                    ),
                  ),
                  // View Count Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.eye, color: Colors.white, size: 11),
                          const SizedBox(width: 4),
                          Text(
                            views,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Video Title & Channel
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
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
