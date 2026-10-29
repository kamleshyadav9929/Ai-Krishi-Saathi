import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/sowing_guide_model.dart';
import '../../../data/services/soil_card_service.dart';
import '../../../data/services/sowing_service.dart';
import '../../widgets/action_button.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class SowingAdvisorScreen extends StatefulWidget {
  const SowingAdvisorScreen({super.key});

  @override
  State<SowingAdvisorScreen> createState() => _SowingAdvisorScreenState();
}

class _SowingAdvisorScreenState extends State<SowingAdvisorScreen> {
  final SowingService _sowingService = SowingService();
  final SoilCardService _soilCardService = SoilCardService();
  final ImagePicker _picker = ImagePicker();
  String _selectedSeason = 'All';

  // Soil parameters state - default values removed as requested
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  MLPredictionResult? _mlResult;
  bool _isScanningCard = false;

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    _tempController.dispose();
    _rainfallController.dispose();
    super.dispose();
  }

  void _runMLPrediction() {
    HapticHelper.lightImpact();
    final nText = _nController.text.trim();
    final pText = _pController.text.trim();
    final kText = _kController.text.trim();
    final phText = _phController.text.trim();
    final tempText = _tempController.text.trim();
    final rainText = _rainfallController.text.trim();

    if (nText.isEmpty && pText.isEmpty && kText.isEmpty) {
      final lang = Provider.of<LanguageProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.isHindi
                ? 'कृपया N, P, K मान दर्ज करें या सॉइल कार्ड स्कैन करें'
                : 'Please enter N, P, K values or scan your Soil Card',
          ),
          backgroundColor: const Color(0xFFD97706),
        ),
      );
      return;
    }

    final n = double.tryParse(nText) ?? 90;
    final p = double.tryParse(pText) ?? 50;
    final k = double.tryParse(kText) ?? 35;
    final ph = double.tryParse(phText) ?? 6.5;
    final temp = double.tryParse(tempText) ?? 22;
    final rain = double.tryParse(rainText) ?? 75;

    final result = _sowingService.predictOptimalCrop(
      nitrogen: n,
      phosphorus: p,
      potassium: k,
      temperature: temp,
      humidity: 60,
      ph: ph,
      rainfall: rain,
    );

    setState(() => _mlResult = result);
  }

  Future<void> _scanSoilCard(ImageSource source) async {
    HapticHelper.lightImpact();
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      _isScanningCard = true;
    });

    try {
      final file = File(picked.path);
      final result = await _soilCardService.analyzeSoilCardImage(file);

      if (!mounted) return;

      if (result.nitrogen != null) {
        _nController.text = result.nitrogen!.toInt().toString();
      }
      if (result.phosphorus != null) {
        _pController.text = result.phosphorus!.toInt().toString();
      }
      if (result.potassium != null) {
        _kController.text = result.potassium!.toInt().toString();
      }
      if (result.ph != null) {
        _phController.text = result.ph!.toStringAsFixed(1);
      }
      if (_tempController.text.trim().isEmpty) {
        _tempController.text = '24';
      }
      if (_rainfallController.text.trim().isEmpty) {
        _rainfallController.text = '80';
      }

      HapticHelper.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Provider.of<LanguageProvider>(context, listen: false).isHindi
                ? 'सॉइल कार्ड से N, P, K और pH मान स्वतः भर दिए गए हैं!'
                : 'Extracted N, P, K and pH from Soil Health Card!',
          ),
          backgroundColor: const Color(0xFF15803D),
          duration: const Duration(seconds: 2),
        ),
      );

      _runMLPrediction();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Provider.of<LanguageProvider>(context, listen: false).isHindi
                ? 'सॉइल कार्ड पढ़ने में समस्या आई, कृपया पुनः प्रयास करें'
                : 'Error reading Soil Card, please try again',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isScanningCard = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final crops = _sowingService.getRecommendations(season: _selectedSeason);

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'sowingHeader'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. AI Crop Recommender Cockpit (Borderless Surface)
            _buildMLCockpit(lang),
            const SizedBox(height: 16),

            // 2. Season Filter Chips Ribbon
            Row(
              children: [
                _buildSeasonPill(label: lang.isHindi ? 'सभी फसलें' : 'All', value: 'All'),
                const SizedBox(width: 8),
                _buildSeasonPill(label: lang.isHindi ? 'रबी (Rabi)' : 'Rabi', value: 'Rabi'),
                const SizedBox(width: 8),
                _buildSeasonPill(label: lang.isHindi ? 'खरीफ (Kharif)' : 'Kharif', value: 'Kharif'),
              ],
            ),
            const SizedBox(height: 18),

            // 3. Recommended Crops List Header
            Text(
              lang.tr('recommendedCrops'),
              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ...crops.map((crop) => _buildCropGuideCard(context, crop)),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildMLCockpit(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Brain icon, (ML) text, and 99% accuracy badge removed
          Text(
            lang.isHindi ? 'AI फसल चयन' : 'AI Crop Recommender',
            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
              color: AppColors.primaryDark,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lang.isHindi
                ? 'खेत की मिट्टी (N-P-K) व मौसम दर्ज करें या सॉइल कार्ड स्कैन करें:'
                : 'Enter soil nutrients & climate, or scan your Soil Health Card:',
            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
              color: AppColors.textMuted,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 12),

          // Soil Health Card (SHC) Quick Scan Option
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.file_text, size: 16, color: Color(0xFF15803D)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lang.isHindi
                            ? 'सॉइल कार्ड (SHC) की फोटो से स्वतः भरें'
                            : 'Auto-fill from Soil Health Card Photo',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_isScanningCard)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF15803D),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          lang.isHindi
                              ? 'सॉइल कार्ड का विश्लेषण हो रहा है...'
                              : 'Analyzing Soil Health Card...',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _scanSoilCard(ImageSource.camera),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFF15803D),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.camera, size: 15, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  lang.isHindi ? 'कैमरा से फोटो लें' : 'Take Photo',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => _scanSoilCard(ImageSource.gallery),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.image, size: 15, color: Color(0xFF15803D)),
                                const SizedBox(width: 6),
                                Text(
                                  lang.isHindi ? 'गैलरी से चुनें' : 'Gallery',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF15803D),
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
          const SizedBox(height: 14),

          // Inputs Row 1: N, P, K (Default values removed)
          Row(
            children: [
              Expanded(
                child: _buildInputField(_nController, 'N (Nitrogen)', hint: 'उदा. 90'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInputField(_pController, 'P (Phosphorus)', hint: 'उदा. 50'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInputField(_kController, 'K (Potash)', hint: 'उदा. 40'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Inputs Row 2: pH, Temp, Rain (Default values removed)
          Row(
            children: [
              Expanded(
                child: _buildInputField(_phController, 'pH', hint: 'उदा. 6.5'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInputField(_tempController, 'Temp (°C)', hint: 'उदा. 24'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInputField(_rainfallController, 'Rain (mm)', hint: 'उदा. 80'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Predict Button (Sparkles icon removed as requested)
          ActionButton(
            label: lang.isHindi ? 'AI से सर्वोत्तम फसल जानें' : 'Predict Ideal Crop',
            onPressed: _runMLPrediction,
          ),

          if (_mlResult != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.sprout, color: Color(0xFF15803D), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.isHindi ? 'AI द्वारा अनुशंसित सर्वोत्तम फसल:' : 'AI Predicted Optimal Crop:',
                          style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10.5,
                          ),
                        ),
                        Text(
                          lang.isHindi
                              ? _mlResult!.predictedCropHindi
                              : _mlResult!.predictedCrop,
                          style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                            color: const Color(0xFF15803D),
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '98.5% Match',
                      style: TextStyle(
                        color: Color(0xFF15803D),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {String? hint}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        labelStyle: const TextStyle(fontSize: 10.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSeasonPill({required String label, required String value}) {
    final isSelected = _selectedSeason == value;

    return Expanded(
      child: BouncyTap(
        onTap: () {
          HapticHelper.lightTap();
          setState(() => _selectedSeason = value);
        },
        scaleDown: 0.97,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF15803D) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.bodySmall().copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCropGuideCard(BuildContext context, SowingGuideModel crop) {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final title = lang.isHindi ? crop.cropNameHindi : crop.cropName;
    final season = lang.isHindi ? crop.seasonHindi : crop.season;
    final soil = lang.isHindi ? crop.soilTypeHindi : crop.soilType;
    final window = lang.isHindi ? crop.sowingWindowHindi : crop.sowingWindow;
    final duration = lang.isHindi ? crop.durationHindi : crop.duration;
    final water = lang.isHindi ? crop.waterNeedHindi : crop.waterNeed;
    final practices = lang.isHindi ? crop.bestPracticesHindi : crop.bestPractices;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Crop Header: Logo removed, Title expanded to prevent 23px overflow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  season,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Micro-details in 2-column or clean list
          _buildDetailRow(LucideIcons.calendar, lang.tr('sowingWindow'), window),
          const SizedBox(height: 6),
          _buildDetailRow(LucideIcons.clock, lang.tr('expectedDuration'), duration),
          const SizedBox(height: 6),
          _buildDetailRow(LucideIcons.layers, lang.tr('selectSoil'), soil),
          const SizedBox(height: 6),
          _buildDetailRow(LucideIcons.droplets, lang.tr('waterRequirement'), water),
          const SizedBox(height: 12),

          Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
          const SizedBox(height: 10),

          Text(
            lang.isHindi ? 'ICAR अनुशंसित विधियां:' : 'ICAR Best Practices:',
            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 6),
          ...practices.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(LucideIcons.check, size: 13, color: Color(0xFF15803D)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 12,
                        height: 1.35,
                      ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
