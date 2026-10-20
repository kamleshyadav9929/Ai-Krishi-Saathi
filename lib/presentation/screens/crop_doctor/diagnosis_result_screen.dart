import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/crop_disease_model.dart';
import '../../widgets/action_button.dart';

class DiagnosisResultScreen extends StatelessWidget {
  final CropDiseaseModel diagnosis;

  const DiagnosisResultScreen({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final diseaseTitle = lang.isHindi ? diagnosis.diseaseNameHindi : diagnosis.diseaseName;
    final symptomsList = lang.isHindi ? diagnosis.symptomsHindi : diagnosis.symptoms;
    final treatmentsList = lang.isHindi ? diagnosis.organicTreatmentsHindi : diagnosis.organicTreatments;
    final confidencePercent = (diagnosis.confidence * 100).toInt();

    final hasLocalImage = diagnosis.imagePath != null &&
        diagnosis.imagePath!.isNotEmpty &&
        File(diagnosis.imagePath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('diagnosisResult')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photographed Leaf Image Preview Card
            if (hasLocalImage) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(diagnosis.imagePath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            if (!diagnosis.isPlant) ...[
              // Non-Plant Detected Warning Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.accentLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.scan_line, color: AppColors.accent, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.isHindi ? 'यह फसल या पौधे की तस्वीर नहीं है' : 'Not a Plant or Crop Photo',
                                style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF92400E),
                                ),
                              ),
                              if (diagnosis.detectedObject != null && diagnosis.detectedObject!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '${lang.isHindi ? 'पहचानी गई वस्तु' : 'Detected Object'}: ${diagnosis.detectedObject}',
                                  style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF78350F),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      lang.isHindi
                          ? 'AI फसल डॉक्टर केवल कृषि फसलों, पौधों की पत्तियों, तनों अथवा फलों के रोगों की जांच करता है। बोतल, घरेलू उत्पाद या अन्य वस्तुओं पर रोग का निदान संभव नहीं है।'
                          : 'AI Crop Doctor only analyzes agricultural crops, leaves, stems, or fruits. Photos of domestic products or random objects cannot be diagnosed.',
                      style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                        color: const Color(0xFF78350F),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.lightbulb, size: 18, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lang.isHindi
                                  ? 'सुझाव: खेत में जाकर संक्रमित पौधे की पत्ती को कैमरे के सामने साफ़ व रोशनी में खींचें।'
                                  : 'Tip: Take a clear photo of an infected leaf in good natural light.',
                              style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                color: const Color(0xFF78350F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ActionButton(
                label: lang.isHindi ? '📸 सही पौधे की फोटो खींचें' : '📸 Retake Crop Photo',
                icon: LucideIcons.camera,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Top Condition Card with Confidence Score
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            diagnosis.cropType,
                            style: AppTypography.bodySmall().copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.shield_check, color: Color(0xFF15803D), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '$confidencePercent% ${lang.isHindi ? 'सटीक' : 'Confidence'}',
                                style: AppTypography.bodySmall().copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF15803D),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      lang.tr('issueDetected'),
                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      diseaseTitle,
                      style: AppTypography.headingMedium(isHindi: lang.isHindi).copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Symptoms Section
              Text(
                lang.tr('symptoms'),
                style: AppTypography.headingSmall(isHindi: lang.isHindi),
              ),
              const SizedBox(height: 8),
              ...symptomsList.map((symptom) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(LucideIcons.circle_check, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            symptom,
                            style: AppTypography.bodyMedium(isHindi: lang.isHindi),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Recommended Safe / Organic Treatments
              Text(
                lang.tr('recommendedSteps'),
                style: AppTypography.headingSmall(isHindi: lang.isHindi),
              ),
              const SizedBox(height: 8),
              ...treatmentsList.map((treatment) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.025),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.leaf, size: 16, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            treatment,
                            style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Safety Warning & Legal Disclaimer Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.triangle_alert, color: AppColors.accent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.tr('safetyNoticeTitle'),
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.tr('safetyNoticeText'),
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              color: const Color(0xFF78350F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ActionButton(
                label: lang.tr('newScan'),
                icon: LucideIcons.camera,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
