import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/crop_disease_model.dart';
import '../../../data/services/gemini_vision_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';
import 'diagnosis_result_screen.dart';

class CropDoctorScreen extends StatefulWidget {
  const CropDoctorScreen({super.key});

  @override
  State<CropDoctorScreen> createState() => _CropDoctorScreenState();
}

class _CropDoctorScreenState extends State<CropDoctorScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final GeminiVisionService _geminiService = GeminiVisionService();
  bool _isAnalyzing = false;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _scanController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _handleImagePick(ImageSource source) async {
    HapticHelper.lightImpact();
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo == null) return; // User cancelled picker

      setState(() => _isAnalyzing = true);

      // Read real image bytes
      final bytes = await photo.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = photo.mimeType ?? 'image/jpeg';

      // Analyze via Gemini Vision API with real base64 image data
      final rawDiagnosis = await _geminiService.diagnoseLeafImage(
        imageBase64: base64Image,
        mimeType: mimeType,
      );

      // Attach actual photographed file path
      final diagnosisWithImage = CropDiseaseModel(
        diseaseName: rawDiagnosis.diseaseName,
        diseaseNameHindi: rawDiagnosis.diseaseNameHindi,
        cropType: rawDiagnosis.cropType,
        confidence: rawDiagnosis.confidence,
        symptoms: rawDiagnosis.symptoms,
        symptomsHindi: rawDiagnosis.symptomsHindi,
        organicTreatments: rawDiagnosis.organicTreatments,
        organicTreatmentsHindi: rawDiagnosis.organicTreatmentsHindi,
        safetyWarning: rawDiagnosis.safetyWarning,
        safetyWarningHindi: rawDiagnosis.safetyWarningHindi,
        scannedAt: DateTime.now(),
        imagePath: photo.path,
        isPlant: rawDiagnosis.isPlant,
        detectedObject: rawDiagnosis.detectedObject,
      );

      if (!mounted) return;
      setState(() => _isAnalyzing = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosisResultScreen(diagnosis: diagnosisWithImage),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process image. Please try again with clear lighting.'),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'cropDoctorHeader'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3-Step Farmer Visual Workflow Banner
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
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
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.camera, size: 13, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            lang.isHindi ? '1. फोटो लें' : '1. Take photo',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('→', style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.sparkles, size: 13, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            lang.isHindi ? '2. AI जांच' : '2. AI Scan',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('→', style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.pill, size: 13, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            lang.isHindi ? '3. इलाज पाएं' : '3. Get Cure',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 1. Next-Gen Kiwi-Style AI Viewfinder Studio
            _buildViewfinderStudio(lang),
            const SizedBox(height: 20),



            // 3. Photographic Quality Guidelines (3-Pillar Micro Grid)
            Text(
              lang.tr('cameraGuideTitle'),
              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildGuidelinePill(
                    icon: LucideIcons.focus,
                    title: lang.isHindi ? '15-20 सेमी' : '15-20 cm',
                    desc: lang.isHindi ? 'स्पष्ट फोकस' : 'Clear Focus',
                    tintColor: const Color(0xFFDCFCE7),
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGuidelinePill(
                    icon: LucideIcons.sun,
                    title: lang.isHindi ? 'प्राकृतिक धूप' : 'Daylight',
                    desc: lang.isHindi ? 'साफ़ रोशनी' : 'Good Light',
                    tintColor: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGuidelinePill(
                    icon: LucideIcons.leaf,
                    title: lang.isHindi ? 'एक पत्ती' : 'Single Leaf',
                    desc: lang.isHindi ? 'संक्रमित भाग' : 'Affected Part',
                    tintColor: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Visual Photo Guide Comparison Cards (Right vs Wrong)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.camera, size: 16, color: Color(0xFF15803D)),
                      const SizedBox(width: 6),
                      Text(
                        lang.isHindi ? 'फोटो खींचने का सही व गलत तरीका' : 'Correct vs Wrong Photo Guide',
                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Correct Guide
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/photo_guide_good.png',
                                  height: 85,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.circle_check, size: 14, color: Color(0xFF16A34A)),
                                  const SizedBox(width: 4),
                                  Text(
                                    lang.isHindi ? 'सही तरीका' : 'Correct',
                                    style: const TextStyle(
                                      color: Color(0xFF15803D),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang.isHindi ? 'साफ व नजदीकी फोटो' : 'Clear & close-up',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF166534),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Wrong Guide
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFECACA), width: 1.2),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/photo_guide_bad.png',
                                  height: 85,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.circle_x, size: 14, color: Color(0xFFDC2626)),
                                  const SizedBox(width: 4),
                                  Text(
                                    lang.isHindi ? 'गलत तरीका' : 'Incorrect',
                                    style: const TextStyle(
                                      color: Color(0xFFB91C1C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang.isHindi ? 'धुंधला या बहुत दूर' : 'Blurry or too far',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF991B1B),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  /// AI Viewfinder Studio with Corner Reticle, Pulsing Laser, and Tactile Shutter Pill
  Widget _buildViewfinderStudio(LanguageProvider lang) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          children: [
            // Center Reticle Viewfinder Target
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFF0FDF4),
                border: Border.all(
                  color: const Color(0xFF86EFAC),
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Viewfinder 4 Corner Brackets
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _buildCornerBracket(isTop: true, isLeft: true),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _buildCornerBracket(isTop: true, isLeft: false),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: _buildCornerBracket(isTop: false, isLeft: true),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: _buildCornerBracket(isTop: false, isLeft: false),
                  ),

                  // Animated Laser Scan Bar
                  if (_isAnalyzing)
                    AnimatedBuilder(
                      animation: _scanController,
                      builder: (context, child) {
                        return Positioned(
                          top: 20 + (_scanController.value * 120),
                          left: 16,
                          right: 16,
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF15803D),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF15803D).withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Center Icon / State
                  if (_isAnalyzing)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 38,
                          height: 38,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            color: Color(0xFF15803D),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lang.tr('analyzing'),
                          style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                            color: const Color(0xFF15803D),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/crop_doctor_guide.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lang.isHindi ? 'पत्ती को फ्रेम में रखें' : 'Align leaf in frame',
                          style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Description
            Text(
              lang.tr('cropDoctorTitle'),
              textAlign: TextAlign.center,
              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lang.tr('cropDoctorDesc'),
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),

            // Tactile Action Dock (Kiwi Style Buttons)
            if (!_isAnalyzing)
              Row(
                children: [
                  // Big Deep Emerald Shutter Button
                  Expanded(
                    flex: 3,
                    child: BouncyTap(
                      onTap: () => _handleImagePick(ImageSource.camera),
                      scaleDown: 0.96,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15803D),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF15803D).withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.camera, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              lang.tr('takePhoto'),
                              style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Soft Mint Gallery Button
                  Expanded(
                    flex: 2,
                    child: BouncyTap(
                      onTap: () => _handleImagePick(ImageSource.gallery),
                      scaleDown: 0.96,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF86EFAC),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.image, color: Color(0xFF15803D), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              lang.isHindi ? 'गैलरी' : 'Gallery',
                              style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
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
    );
  }

  Widget _buildCornerBracket({required bool isTop, required bool isLeft}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFF15803D), width: 2.5) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFF15803D), width: 2.5) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFF15803D), width: 2.5) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF15803D), width: 2.5) : BorderSide.none,
        ),
      ),
    );
  }


  Widget _buildGuidelinePill({
    required IconData icon,
    required String title,
    required String desc,
    required Color tintColor,
    required Color iconColor,
  }) {
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: tintColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          Text(
            desc,
            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
              fontSize: 9.5,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
