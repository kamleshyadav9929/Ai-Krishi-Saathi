import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/services/soil_card_service.dart';
import '../../widgets/custom_app_bar.dart';

class SoilCardScreen extends StatefulWidget {
  const SoilCardScreen({super.key});

  @override
  State<SoilCardScreen> createState() => _SoilCardScreenState();
}

class _SoilCardScreenState extends State<SoilCardScreen> {
  final SoilCardService _service = SoilCardService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isAnalyzing = false;
  SoilTestResult? _soilResult;

  String _selectedCrop = 'Wheat';
  double _acres = 1.0;
  final TextEditingController _acreController = TextEditingController(text: '1.0');

  final List<String> _crops = ['Wheat', 'Paddy', 'Mustard', 'Potato', 'Cotton', 'Chickpea'];

  @override
  void initState() {
    super.initState();
    // Default baseline initial result so calculator is immediately interactive even before camera scan
    _soilResult = SoilTestResult(
      isSoilCard: true,
      detectedTitle: 'मृदा स्वास्थ्य नमूना (Standard Soil Baseline)',
      nitrogen: 220,
      nitrogenStatus: 'Low',
      phosphorus: 24,
      phosphorusStatus: 'Medium',
      potassium: 210,
      potassiumStatus: 'High',
      ph: 7.2,
      phStatus: 'Neutral',
      organicCarbon: 0.54,
      recommendationHindi: 'मिट्टी में नाइट्रोजन की कमी है। बुवाई के समय संतुलित DAP व बाद में यूरिया दें।',
      recommendationEnglish: 'Soil is deficient in nitrogen. Apply basal DAP and split-apply Urea.',
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    HapticHelper.lightImpact();
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    final file = File(picked.path);
    setState(() {
      _selectedImage = file;
      _isAnalyzing = true;
    });

    final result = await _service.analyzeSoilCardImage(file);
    if (!mounted) return;

    HapticHelper.mediumImpact();
    setState(() {
      _soilResult = result;
      _isAnalyzing = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'low':
        return AppColors.warning;
      case 'medium':
        return AppColors.primary;
      case 'high':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    FertilizerPlan? plan;
    if (_soilResult != null && _soilResult!.isSoilCard) {
      plan = _service.calculateFertilizerPlan(
        crop: _selectedCrop,
        acres: _acres > 0 ? _acres : 1.0,
        nitrogenStatus: _soilResult!.nitrogenStatus,
        phosphorusStatus: _soilResult!.phosphorusStatus,
        potassiumStatus: _soilResult!.potassiumStatus,
        ph: _soilResult!.ph ?? 7.0,
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        titleKey: lang.isHindi ? 'सॉइल कार्ड व खाद कैलकुलेटर' : 'Soil Card & Fertilizer Plan',
        showLanguageToggle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Banner Cockpit (Borderless Surface)
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                        ),
                        child: const Icon(LucideIcons.file_text, size: 22, color: Color(0xFF15803D)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.isHindi ? 'मृदा स्वास्थ्य कार्ड (SHC) स्कैन करें' : 'Scan Soil Health Card',
                              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang.isHindi
                                  ? 'कार्ड की फोटो खींचें, AI खुद NPK व pH निकाल लेगा'
                                  : 'Upload soil test report to auto-extract nutrients',
                              style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                color: AppColors.textMuted,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
                    )
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/soil_test_hero.png',
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF86EFAC), width: 0.8),
                                ),
                                child: Text(
                                  lang.isHindi ? 'सरकारी मृदा स्वास्थ्य कार्ड का नमूना' : 'Sample Soil Health Card',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _isAnalyzing ? null : () => _pickImage(ImageSource.camera),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                              color: const Color(0xFF15803D),
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
                                const Icon(LucideIcons.camera, size: 16, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  lang.isHindi ? 'कैमरा' : 'Camera',
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: _isAnalyzing ? null : () => _pickImage(ImageSource.gallery),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.image, size: 16, color: Color(0xFF15803D)),
                                const SizedBox(width: 8),
                                Text(
                                  lang.isHindi ? 'गैलरी' : 'Gallery',
                                  style: AppTypography.bodySmall().copyWith(
                                    color: const Color(0xFF15803D),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            if (_isAnalyzing)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 12),
                      Text('AI सॉइल कार्ड की जांच कर रहा है...'),
                    ],
                  ),
                ),
              )
            else if (_soilResult != null) ...[
              // Non-Soil Card Warning
              if (!_soilResult!.isSoilCard)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.circle_alert, color: AppColors.error, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lang.isHindi ? _soilResult!.recommendationHindi : _soilResult!.recommendationEnglish,
                          style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Extracted Soil Nutrients Grid
              Row(
                children: [
                  const Icon(LucideIcons.flask_conical, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    lang.isHindi ? 'जांच परिणाम (Soil Test Parameters)' : 'Extracted Soil Parameters',
                    style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildNutrientTile(
                      label: lang.isHindi ? 'नाइट्रोजन (N)' : 'Nitrogen (N)',
                      status: _soilResult!.nitrogenStatus,
                      value: _soilResult!.nitrogen != null ? '${_soilResult!.nitrogen!.toInt()} kg/ha' : 'Status',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNutrientTile(
                      label: lang.isHindi ? 'फास्फोरस (P)' : 'Phosphorus (P)',
                      status: _soilResult!.phosphorusStatus,
                      value: _soilResult!.phosphorus != null ? '${_soilResult!.phosphorus!.toInt()} kg/ha' : 'Status',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildNutrientTile(
                      label: lang.isHindi ? 'पोटाश (K)' : 'Potassium (K)',
                      status: _soilResult!.potassiumStatus,
                      value: _soilResult!.potassium != null ? '${_soilResult!.potassium!.toInt()} kg/ha' : 'Status',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNutrientTile(
                      label: 'pH मान (Acidity)',
                      status: _soilResult!.phStatus,
                      value: 'pH ${_soilResult!.ph?.toStringAsFixed(1) ?? "7.0"}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Interactive Fertilizer Calculator Cockpit (Borderless Surface)
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.isHindi ? 'सटीक खाद कैलकुलेटर' : 'Fertilizer Calculator',
                          style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.calculator, size: 16, color: Color(0xFF15803D)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Crop & Acres Selector
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedCrop,
                            decoration: InputDecoration(
                              labelText: lang.isHindi ? 'फसल' : 'Crop',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _crops.map((c) {
                              return DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCrop = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _acreController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: lang.isHindi ? 'रकबा (एकड़)' : 'Acres',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onChanged: (val) {
                              final parsed = double.tryParse(val) ?? 1.0;
                              setState(() => _acres = parsed);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (plan != null) ...[
                      Text(
                        lang.isHindi ? 'कुल आवश्यक खाद (50 kg बोरी में):' : 'Required Fertilizer (50 kg Bags):',
                        style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _buildBagTile(
                              title: 'यूरिया (Urea)',
                              bags: plan.ureaBags,
                              bgColor: const Color(0xFFF0FDF4),
                              borderColor: const Color(0xFFBBF7D0),
                              textColor: const Color(0xFF15803D),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildBagTile(
                              title: 'DAP (डीएपी)',
                              bags: plan.dapBags,
                              bgColor: const Color(0xFFFFFBEB),
                              borderColor: const Color(0xFFFDE68A),
                              textColor: const Color(0xFFB45309),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildBagTile(
                              title: 'पोटाश (MOP)',
                              bags: plan.mopBags,
                              bgColor: const Color(0xFFEFF6FF),
                              borderColor: const Color(0xFFBFDBFE),
                              textColor: const Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Schedule advice box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.clock, size: 15, color: Color(0xFF15803D)),
                                const SizedBox(width: 6),
                                Text(
                                  lang.isHindi ? 'डालने का सही समय (Application Schedule):' : 'Application Schedule:',
                                  style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF15803D),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang.isHindi ? plan.scheduleHindi : plan.scheduleEnglish,
                              style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                fontSize: 12,
                                height: 1.4,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Soil Amendment Notice (Lime or Gypsum)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(LucideIcons.info, size: 15, color: Color(0xFFD97706)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lang.isHindi ? plan.amendmentAdviceHindi : plan.amendmentAdviceEnglish,
                                style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                  fontSize: 12,
                                  color: const Color(0xFF92400E),
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientTile({
    required String label,
    required String status,
    required String value,
  }) {
    final statusColor = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBagTile({
    required String title,
    required double bags,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$bags बोरी',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
          ),
        ],
      ),
    );
  }
}
