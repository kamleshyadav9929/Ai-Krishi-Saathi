import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Kamlesh Yadav');
  final TextEditingController _districtController = TextEditingController(text: 'Patna, Bihar');
  final TextEditingController _landController = TextEditingController(text: '3.5');
  final TextEditingController _cropController = TextEditingController(text: 'Wheat / Paddy (गेहूं व धान)');
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _nameController.text = prefs.getString('farmer_name') ?? 'Kamlesh Yadav';
        _districtController.text = prefs.getString('farmer_district') ?? 'Patna, Bihar';
        _landController.text = prefs.getString('farmer_land') ?? '3.5';
        _cropController.text = prefs.getString('farmer_crop') ?? 'Wheat / Paddy (गेहूं व धान)';
      });
    } catch (_) {}
  }

  Future<void> _saveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('farmer_name', _nameController.text.trim());
      await prefs.setString('farmer_district', _districtController.text.trim());
      await prefs.setString('farmer_land', _landController.text.trim());
      await prefs.setString('farmer_crop', _cropController.text.trim());

      setState(() => _isSaved = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isSaved = false);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'settingsHeader', showLanguageToggle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farmer Profile Section (Real Persistence)
            Row(
              children: [
                const Icon(LucideIcons.user, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  lang.tr('farmerProfile'),
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: lang.tr('farmerName'),
                      prefixIcon: const Icon(LucideIcons.user, size: 18, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _districtController,
                    decoration: InputDecoration(
                      labelText: lang.tr('farmLocation'),
                      prefixIcon: const Icon(LucideIcons.map_pin, size: 18, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _landController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: lang.isHindi ? 'जमीन (एकड़)' : 'Land (Acres)',
                            prefixIcon: const Icon(LucideIcons.maximize_2, size: 18, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _cropController,
                          decoration: InputDecoration(
                            labelText: lang.isHindi ? 'मुख्य फसल' : 'Primary Crop',
                            prefixIcon: const Icon(LucideIcons.sprout, size: 18, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      _saveProfile();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isSaved ? const Color(0xFF14532D) : const Color(0xFF15803D),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF15803D).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isSaved ? LucideIcons.circle_check : LucideIcons.save,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isSaved
                                ? (lang.isHindi ? 'सफलतापूर्वक सहेजा गया' : 'Profile Saved')
                                : lang.tr('save'),
                            style: AppTypography.bodySmall().copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Language Selection Group
            Row(
              children: [
                const Icon(LucideIcons.languages, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  lang.tr('languageToggle'),
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      HapticHelper.lightTap();
                      lang.setLanguage('hi');
                    },
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: lang.isHindi ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              LucideIcons.languages,
                              size: 18,
                              color: lang.isHindi ? const Color(0xFF15803D) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'हिंदी (Hindi — अनुशंसित)',
                                  style: AppTypography.bodyMedium(isHindi: true).copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: lang.isHindi ? const Color(0xFF14532D) : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'भारतीय किसानों के लिए सरल हिंदी भाषा',
                                  style: AppTypography.bodySmall(isHindi: true).copyWith(
                                    fontSize: 11.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (lang.isHindi)
                            const Icon(LucideIcons.check, size: 20, color: Color(0xFF15803D))
                          else
                            const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFFE2E8F0), height: 1, indent: 54),
                  InkWell(
                    onTap: () {
                      HapticHelper.lightTap();
                      lang.setLanguage('en');
                    },
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: !lang.isHindi ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              LucideIcons.globe,
                              size: 18,
                              color: !lang.isHindi ? const Color(0xFF15803D) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'English',
                                  style: AppTypography.bodyMedium(isHindi: false).copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: !lang.isHindi ? const Color(0xFF14532D) : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'English interface with agricultural terms',
                                  style: AppTypography.bodySmall(isHindi: false).copyWith(
                                    fontSize: 11.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!lang.isHindi)
                            const Icon(LucideIcons.check, size: 20, color: Color(0xFF15803D))
                          else
                            const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Academic Attribution Group
            Row(
              children: [
                const Icon(LucideIcons.graduation_cap, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  lang.tr('academicNotice'),
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                        ),
                        child: const Icon(LucideIcons.graduation_cap, color: Color(0xFF15803D), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppConstants.developer,
                          style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                            color: const Color(0xFF14532D),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${AppConstants.programme}\n${AppConstants.institution}',
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.legalDisclaimer,
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
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
}
