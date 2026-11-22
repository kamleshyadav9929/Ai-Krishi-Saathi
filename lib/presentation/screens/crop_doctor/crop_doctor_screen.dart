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

class _CropDoctorScreenState extends State<CropDoctorScreen> {
  final ImagePicker _picker = ImagePicker();
  final GeminiVisionService _geminiService = GeminiVisionService();
  bool _isAnalyzing = false;

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

      // Genuine Multimodal Vision AI diagnosis using Google Gemini
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. AI Vision Engine Status Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF0FDF4), Color(0xFFF7FEE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF15803D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.sparkles,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Gemini Multimodal Vision AI',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.headingSmall().copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF14532D),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF86EFAC)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF15803D),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    lang.isHindi ? 'लाइव विज़न' : 'Live Vision',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang.isHindi
                              ? 'बाजरा, गेहूं, धान, सरसों व सभी फसलों की सटीक वैज्ञानिक जांच'
                              : 'Real-time ICAR diagnostic analysis for all Indian field crops',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF166534),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 1. Direct AI Action Studio (Capture with Camera or Gallery)
            _buildActionStudio(lang),
            const SizedBox(height: 22),

            // 2. Photographic Quality Guidelines (3-Pillar Micro Grid)
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Clean, Modern AI Action Studio with Camera & Gallery Options
  Widget _buildActionStudio(LanguageProvider lang) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: _isAnalyzing
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF15803D),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lang.tr('analyzing'),
                  style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                    color: const Color(0xFF15803D),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  lang.isHindi
                      ? 'पौधे की पत्ती का एआई विश्लेषण हो रहा है...'
                      : 'AI is analyzing leaf pathology & remedies...',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Badge & Title
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.scan_line,
                          size: 22,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.tr('cropDoctorTitle'),
                            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.tr('cropDoctorDesc'),
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 1. Capture with Camera Button (Primary Action)
                BouncyTap(
                  onTap: () => _handleImagePick(ImageSource.camera),
                  scaleDown: 0.97,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
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
                        const Icon(LucideIcons.camera, color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          lang.tr('takePhoto'),
                          style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Choose from Gallery Button (Secondary Action)
                BouncyTap(
                  onTap: () => _handleImagePick(ImageSource.gallery),
                  scaleDown: 0.97,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.image, color: Color(0xFF0F172A), size: 20),
                        const SizedBox(width: 10),
                        Text(
                          lang.tr('chooseGallery'),
                          style: AppTypography.labelLarge(isHindi: lang.isHindi).copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
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
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
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
