import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/services/voice_assistant_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';
import '../crop_doctor/crop_doctor_screen.dart';

class CropStageItem {
  final int stageNumber;
  final String stageName;
  final String stageNameHindi;
  final String dasRange;
  final String irrigationHindi;
  final String fertilizerHindi;
  final String pestAlertHindi;
  final String audioScriptHindi;

  const CropStageItem({
    required this.stageNumber,
    required this.stageName,
    required this.stageNameHindi,
    required this.dasRange,
    required this.irrigationHindi,
    required this.fertilizerHindi,
    required this.pestAlertHindi,
    required this.audioScriptHindi,
  });
}

class CropAdvisoryScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const CropAdvisoryScreen({super.key, this.onNavigateTab});

  @override
  State<CropAdvisoryScreen> createState() => _CropAdvisoryScreenState();
}

class _CropAdvisoryScreenState extends State<CropAdvisoryScreen> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  int _selectedCropIndex = 0;
  int _selectedStageIndex = 1; // Default to Active Stage 2 (Tillering)
  bool _isPlayingAudio = false;

  final List<Map<String, String>> _crops = [
    {'name': 'Wheat', 'hindi': 'गेहूं (Wheat)', 'variety': 'PBW-502'},
    {'name': 'Mustard', 'hindi': 'सरसों (Mustard)', 'variety': 'Pusa Bold'},
    {'name': 'Gram', 'hindi': 'चना (Gram)', 'variety': 'JG-14'},
    {'name': 'Potato', 'hindi': 'आलू (Potato)', 'variety': 'Kufri Jyoti'},
  ];

  final List<CropStageItem> _wheatStages = const [
    CropStageItem(
      stageNumber: 1,
      stageName: 'Germination & CRI',
      stageNameHindi: 'अंकुरण व पहली सिंचाई (CRI)',
      dasRange: '0 - 25 दिन',
      irrigationHindi: 'बुवाई के 21-25 दिन पर पहली अत्यंत आवश्यक सिंचाई (CRI stage) अवश्य करें।',
      fertilizerHindi: 'बुवाई के समय NPK या DAP की पूरी आधार खुराक दें।',
      pestAlertHindi: 'दीमक से बचाव हेतु बीजोपचार आवश्यक है।',
      audioScriptHindi: 'किसान भाई, गेहूं की पहली सिंचाई बुवाई के 21 से 25 दिन पर सीआरआई अवस्था में अवश्य करें। यह जड़ों के विकास के लिए सबसे महत्वपूर्ण समय है।',
    ),
    CropStageItem(
      stageNumber: 2,
      stageName: 'Tillering Stage',
      stageNameHindi: 'कल्ले फूटना (Tillering)',
      dasRange: '26 - 45 दिन',
      irrigationHindi: 'खेत में पर्याप्त नमी रखें। कल्ले फूटते समय पानी की कमी न होने दें।',
      fertilizerHindi: 'पहली सिंचाई के 3-4 दिन बाद प्रति एकड़ 40-45 किग्रा यूरिया की टॉप ड्रेसिंग करें।',
      pestAlertHindi: 'पीला रतुआ (Yellow Rust) और माहू कीट की नियमित निगरानी करें।',
      audioScriptHindi: 'गेहूं की कल्ले फूटने की अवस्था में यूरिया की पहली खुराक दें। जिंक की कमी दिखने पर 0.5% जिंक सल्फेट का छिड़काव करें।',
    ),
    CropStageItem(
      stageNumber: 3,
      stageName: 'Jointing & Booting',
      stageNameHindi: 'गांठ बनना व गभोट अवस्था',
      dasRange: '46 - 75 दिन',
      irrigationHindi: 'दूसरी व तीसरी सिंचाई आवश्यकतानुसार 20 दिन के अंतराल पर करें।',
      fertilizerHindi: 'अंतिम यूरिया की खुराक गभोट अवस्था से पहले पूरी कर लें।',
      pestAlertHindi: 'पत्तियों पर धब्बे दिखने पर तुरंत फफूंदनाशी का छिड़काव करें।',
      audioScriptHindi: 'गभोट अवस्था में बालियां तने के अंदर बन रही होती हैं। इस समय खेत में नमी की कमी से बालियों का आकार छोटा रह सकता है।',
    ),
    CropStageItem(
      stageNumber: 4,
      stageName: 'Flowering & Grain Filling',
      stageNameHindi: 'फूल व दाना भराव (Milk Stage)',
      dasRange: '76 - 105 दिन',
      irrigationHindi: 'दाना दूधिया अवस्था में हो तब हल्की सिंचाई करें, तेज हवा में पानी न लगाएं ताकि फसल न गिरे।',
      fertilizerHindi: '0:0:50 (पोटाश) 1 किग्रा प्रति एकड़ 150 लीटर पानी में मिलाकर स्प्रे करें।',
      pestAlertHindi: 'चूहे और पक्षियों से फसल की सुरक्षा करें।',
      audioScriptHindi: 'दाना भराव के समय पोटाश के छिड़काव से दानों में चमक और वजन बढ़ता है। तेज हवा चलने पर सिंचाई रोक दें।',
    ),
    CropStageItem(
      stageNumber: 5,
      stageName: 'Maturity & Harvest',
      stageNameHindi: 'परिपक्वता व कटाई (Harvest)',
      dasRange: '106 - 125 दिन',
      irrigationHindi: 'कटाई से 12-15 दिन पहले सिंचाई पूर्णतः बंद कर दें।',
      fertilizerHindi: 'किसी रासायनिक खाद की आवश्यकता नहीं है।',
      pestAlertHindi: 'दाने में 12% से कम नमी होने पर ही सुरक्षित भंडारण करें।',
      audioScriptHindi: 'फसल की सुनहरी चमक आने और दानों में कड़ापन आने पर कटाई करें। भंडारण से पूर्व अनाज को अच्छी तरह सुखा लें।',
    ),
  ];

  @override
  void dispose() {
    _voiceService.stopSpeaking();
    super.dispose();
  }

  Future<void> _toggleAudio(String script) async {
    HapticHelper.lightImpact();
    if (_isPlayingAudio) {
      await _voiceService.stopSpeaking();
      setState(() => _isPlayingAudio = false);
    } else {
      setState(() => _isPlayingAudio = true);
      await _voiceService.speak(script, isHindi: true);
      if (mounted) setState(() => _isPlayingAudio = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final stage = _wheatStages[_selectedStageIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: CustomAppBar(titleKey: lang.isHindi ? 'navAdvisory' : 'navAdvisory'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Crop Selector Ribbon (FarmRise Top Strip)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _crops.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final isSelected = idx == _selectedCropIndex;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(lang.isHindi ? item['hindi']! : item['name']!),
                      selected: isSelected,
                      selectedColor: const Color(0xFF15803D),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticHelper.lightImpact();
                        setState(() => _selectedCropIndex = idx);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // 2. FarmRise Growth Stage Stepper (Horizontal Timeline - UNBOXED!)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
                      Text(
                        lang.isHindi ? 'फसल विकास चक्र (Package of Practices)' : 'Crop Stage Timeline',
                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stage.dasRange,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Horizontal Stage Stepper Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _wheatStages.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final s = entry.value;
                        final isSelected = idx == _selectedStageIndex;
                        final isPassed = idx < _selectedStageIndex;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              HapticHelper.lightImpact();
                              setState(() => _selectedStageIndex = idx);
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF15803D)
                                    : (isPassed ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 9,
                                    backgroundColor: isSelected ? Colors.white : (isPassed ? const Color(0xFF15803D) : const Color(0xFF94A3B8)),
                                    child: Text(
                                      '${s.stageNumber}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected ? const Color(0xFF15803D) : Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    lang.isHindi ? s.stageNameHindi.split('(').first : s.stageName,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. FarmRise Active Stage Practice Card + Audio Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row with FarmRise Audio Speaker Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.isHindi ? stage.stageNameHindi : stage.stageName,
                              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${lang.isHindi ? 'अवधि' : 'DAS'}: ${stage.dasRange}',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),

                      // FarmRise Signature Audio Play Button
                      BouncyTap(
                        onTap: () => _toggleAudio(stage.audioScriptHindi),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isPlayingAudio ? const Color(0xFFDCFCE7) : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF22C55E), width: 1.2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isPlayingAudio ? LucideIcons.volume_2 : LucideIcons.volume_x,
                                color: const Color(0xFF15803D),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isPlayingAudio
                                    ? (lang.isHindi ? 'सुन रहे हैं...' : 'Playing...')
                                    : (lang.isHindi ? 'ऑडियो सुनें' : 'Listen Audio'),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),

                  // Practice 1: Irrigation
                  _buildPracticeItem(
                    icon: LucideIcons.droplets,
                    iconColor: const Color(0xFF0284C7),
                    bgColor: const Color(0xFFE0F2FE),
                    title: lang.isHindi ? 'सिंचाई सलाह (Irrigation)' : 'Irrigation Advice',
                    desc: stage.irrigationHindi,
                  ),
                  const SizedBox(height: 12),

                  // Practice 2: Fertilizer
                  _buildPracticeItem(
                    icon: LucideIcons.flask_conical,
                    iconColor: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFEF3C7),
                    title: lang.isHindi ? 'उर्वरक व पोषण (Nutrients)' : 'Nutrient Dosage',
                    desc: stage.fertilizerHindi,
                  ),
                  const SizedBox(height: 12),

                  // Practice 3: Pest Watch
                  _buildPracticeItem(
                    icon: LucideIcons.shield_alert,
                    iconColor: const Color(0xFFDC2626),
                    bgColor: const Color(0xFFFEE2E2),
                    title: lang.isHindi ? 'कीट व रोग चेतावनी (Pest Alert)' : 'Pest Alert',
                    desc: stage.pestAlertHindi,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. FarmRise AI Crop Doctor Direct Launch Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF14532D), Color(0xFF166534)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF14532D).withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.camera, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.isHindi ? 'पत्ती पर कोई रोग दिख रहा है?' : 'Spot any disease on leaf?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang.isHindi ? 'कैमरा से तुरंत फोटो खींचकर AI जांच व जैविक उपचार पाएं' : 'Take photo to get instant AI diagnosis and remedies',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  BouncyTap(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CropDoctorScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        lang.isHindi ? 'जांचें' : 'Check',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                      ),
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

  Widget _buildPracticeItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
