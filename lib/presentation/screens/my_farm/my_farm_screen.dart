import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../widgets/bouncy_tap.dart';
import '../calendar/crop_calendar_screen.dart';
import '../crop_doctor/crop_doctor_screen.dart';
import '../farm_manager/farm_manager_screen.dart';
import '../products/agri_products_screen.dart';
import '../retailers/nearby_retailers_screen.dart';
import '../schemes/govt_schemes_screen.dart';
import '../settings/settings_screen.dart';
import '../soil_card/soil_card_screen.dart';

/// Clean Profile and Services Hub for AI Krishi Saathi.
/// - Unboxed layout: Pure white canvas, 8px solid gray dividers.
/// - Top Farmer Profile Header: Avatar, Name, Land size, and Edit button.
/// - Group 1: Agri Inputs & Centers (Agri Products, Nearby Retailers & PMKSK).
/// - Group 2: Smart Farming (Crop Doctor, Crop Calendar, Soil Health Card, Farm Ledger, Govt Schemes).
/// - Group 3: Settings & Support (Language Toggle, Kisan Call Centre 1800-180-1551).
class MyFarmScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const MyFarmScreen({super.key, this.onNavigateTab});

  @override
  State<MyFarmScreen> createState() => _MyFarmScreenState();
}

class _MyFarmScreenState extends State<MyFarmScreen> {
  String _farmerName = 'Kamlesh Yadav';
  String _farmerLand = '3.5';
  String _farmerCrop = 'Wheat / Paddy (गेहूं व धान)';
  bool _whatsAppEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _farmerName = prefs.getString('farmer_name') ?? 'Kamlesh Yadav';
      _farmerLand = prefs.getString('farmer_land') ?? '3.5';
      _farmerCrop = prefs.getString('farmer_crop') ?? 'Wheat / Paddy (गेहूं व धान)';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    final isHindi = lang.isHindi;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isHindi ? 'अधिक सुविधाएं (More)' : 'More',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF111827)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // 1. TOP FARMER PROFILE HEADER
            // ==========================================================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F5132), Color(0xFF14532D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14532D).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Farmer Avatar
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Center(
                            child: Icon(LucideIcons.user, color: Colors.white, size: 28),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Name & Location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _farmerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${loc.currentDistrict}, ${loc.currentState} • $_farmerCrop',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Edit Button
                        BouncyTap(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
                            ).then((_) => _loadProfile());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.pencil, color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  isHindi ? 'बदलें' : 'Edit',
                                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Quick Stats Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileStat(isHindi ? 'कुल रकबा' : 'Land Size', '$_farmerLand एकड़'),
                          Container(width: 1, height: 20, color: Colors.white.withValues(alpha: 0.25)),
                          _buildProfileStat(isHindi ? 'मिट्टी' : 'Soil', isHindi ? 'दोमट' : 'Loam'),
                          Container(width: 1, height: 20, color: Colors.white.withValues(alpha: 0.25)),
                          _buildProfileStat(isHindi ? 'सिंचाई' : 'Irrigation', isHindi ? 'ट्यूबवेल' : 'Tubewell'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Solid Gray Section Separator
            Container(height: 8, color: const Color(0xFFF3F4F6)),

            // ==========================================================
            // 2. GROUP 1: AGRI INPUTS & RETAILERS
            // ==========================================================
            _buildSectionHeader(isHindi ? 'कृषि इनपुट व केंद्र (AGRI INPUTS)' : 'AGRI INPUT SERVICES'),

            // Item 1: Agri Products Catalog
            _buildMenuItem(
              icon: LucideIcons.flask_conical,
              iconColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFFE0F2FE),
              title: isHindi ? 'कृषि उत्पाद कैटलॉग (Agri Products)' : 'Agri Products & Formulations',
              subtitle: isHindi ? 'प्रमाणित बीज, जैविक उर्वरक, कीटनाशक व सही खुराक' : 'Certified seeds, bio-fertilizers & dosage advice',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgriProductsScreen()),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 2: Nearby Retailers & PMKSK
            _buildMenuItem(
              icon: LucideIcons.store,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFFEF3C7),
              title: isHindi ? 'नजदीकी कृषि विक्रेता (Nearby Retailers)' : 'Nearby Retailers & PMKSK',
              subtitle: isHindi ? 'पीएम किसान समृद्धि केंद्र, इफको व अधिकृत डीलर खोजें' : 'Locate PMKSK, IFFCO & licensed agri-dealers',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NearbyRetailersScreen()),
                );
              },
            ),

            // Solid Gray Section Separator
            Container(height: 8, color: const Color(0xFFF3F4F6)),

            // ==========================================================
            // 3. GROUP 2: SMART FARMING & AGRONOMY TOOLS
            // ==========================================================
            _buildSectionHeader(isHindi ? 'स्मार्ट कृषि उपकरण (SMART FARMING)' : 'SMART FARMING TOOLS'),

            // Item 4: AI Crop Doctor
            _buildMenuItem(
              icon: LucideIcons.stethoscope,
              iconColor: const Color(0xFF0E8B30),
              iconBgColor: const Color(0xFFDCFCE7),
              title: isHindi ? 'फसल डॉक्टर (AI Crop Doctor)' : 'AI Crop Doctor',
              subtitle: isHindi ? 'पत्ती की फोटो खींचकर रोग पहचानें व सटीक दवा जानें' : 'Diagnose pests & plant diseases from leaf photos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CropDoctorScreen()),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 5: Crop Calendar & Stage Guide
            _buildMenuItem(
              icon: LucideIcons.calendar_days,
              iconColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFFE0F2FE),
              title: isHindi ? 'फसल कैलेंडर (Crop Calendar)' : 'Crop Calendar',
              subtitle: isHindi ? 'अंकुरण से कटाई तक अवस्था अनुसार वैज्ञानिक सलाह' : 'Stage-wise agronomy guide from sowing to harvest',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CropCalendarScreen()),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 6: Soil Health Card
            _buildMenuItem(
              icon: LucideIcons.test_tube,
              iconColor: const Color(0xFF7C3AED),
              iconBgColor: const Color(0xFFEDE9FE),
              title: isHindi ? 'मृदा स्वास्थ्य कार्ड (Soil Health Card)' : 'Soil Health Card',
              subtitle: isHindi ? 'NPK व सूक्ष्म पोषक तत्व विश्लेषण और खाद कैलकुलेटर' : 'NPK soil testing & customized fertilizer calculator',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SoilCardScreen()),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 7: Farm Ledger (खेत का बहीखाता)
            _buildMenuItem(
              icon: LucideIcons.calculator,
              iconColor: const Color(0xFF0E8B30),
              iconBgColor: const Color(0xFFDCFCE7),
              title: isHindi ? 'खेत का बहीखाता (Farm Ledger)' : 'Farm Income & Expense Ledger',
              subtitle: isHindi ? 'बीज, खाद, डीजल लागत और शुद्ध मुनाफे का हिसाब' : 'Track crop production costs and net profits',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmManagerScreen()),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 8: Govt Schemes (सरकारी योजनाएं)
            _buildMenuItem(
              icon: LucideIcons.landmark,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFFEF3C7),
              title: isHindi ? 'सरकारी योजनाएं (Govt Schemes)' : 'Government Schemes',
              subtitle: isHindi ? 'PM-किसान, फसल बीमा, ट्रैक्टर व सोलर पंप सब्सिडी' : 'PM-Kisan, Fasal Bima & agri subsidies',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GovtSchemesScreen()),
                );
              },
            ),

            // Solid Gray Section Separator
            Container(height: 8, color: const Color(0xFFF3F4F6)),

            // ==========================================================
            // 4. GROUP 3: SETTINGS & SUPPORT
            // ==========================================================
            _buildSectionHeader(isHindi ? 'सेटिंग्स व सहायता (SETTINGS & SUPPORT)' : 'SETTINGS & SUPPORT'),

            // Item 9: Language Selection Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.languages, color: Color(0xFF334155), size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'ऐप की भाषा (App Language)' : 'App Language',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          isHindi ? 'वर्तमान भाषा: हिन्दी' : 'Current: English',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  BouncyTap(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      lang.toggleLanguage();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isHindi ? 'English करें' : 'हिन्दी करें',
                        style: const TextStyle(
                          color: Color(0xFF15803D),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 10: WhatsApp Updates Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.message_circle, color: Color(0xFF16A34A), size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'व्हाट्सएप नोटिफिकेशन' : 'WhatsApp Notifications',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          isHindi ? 'दैनिक मौसम, मंडी भाव व कृषि सलाह' : 'Daily weather, mandi rates & advisory',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _whatsAppEnabled,
                    activeThumbColor: const Color(0xFF0E8B30),
                    onChanged: (val) {
                      HapticHelper.lightTap();
                      setState(() => _whatsAppEnabled = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            val
                                ? (isHindi ? 'व्हाट्सएप अपडेट सक्रिय!' : 'WhatsApp updates enabled!')
                                : (isHindi ? 'व्हाट्सएप अपडेट बंद।' : 'WhatsApp updates paused.'),
                          ),
                          backgroundColor: const Color(0xFF0E8B30),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, indent: 68, color: Color(0xFFF1F5F9)),

            // Item 11: Kisan Call Centre (Toll-free Government Helpline)
            _buildMenuItem(
              icon: LucideIcons.phone_call,
              iconColor: const Color(0xFF0E8B30),
              iconBgColor: const Color(0xFFDCFCE7),
              title: isHindi ? 'किसान कॉल सेंटर (भारत सरकार)' : 'Kisan Call Centre (Govt of India)',
              subtitle: '1800-180-1551 (Toll-Free • 24x7 कृषि सलाह)',
              badgeText: 'TOLL-FREE',
              badgeColor: const Color(0xFF0E8B30),
              onTap: () {
                HapticHelper.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('📞 Calling Kisan Call Centre: 1800-180-1551...'),
                    backgroundColor: Color(0xFF0E8B30),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // App Version Footer
            Center(
              child: Column(
                children: [
                  const Text(
                    'AI Krishi Saathi • National Farmer Edition',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'v1.0.0 • Developed at BIT Mesra, Patna Campus',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Color(0xFF6B7280),
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticHelper.lightTap();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 20),
              ),
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
                          title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (badgeColor ?? const Color(0xFF0E8B30)).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: badgeColor ?? const Color(0xFF0E8B30),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevron_right, size: 18, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 10.5)),
      ],
    );
  }
}
