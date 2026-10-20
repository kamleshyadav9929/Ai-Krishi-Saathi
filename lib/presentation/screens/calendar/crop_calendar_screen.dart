import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/custom_app_bar.dart';

class CropStageTimeline {
  final String stageName;
  final String stageNameHindi;
  final String daysAfterSowing;
  final String description;
  final String descriptionHindi;
  final String criticalAction;
  final String criticalActionHindi;
  final IconData icon;

  CropStageTimeline({
    required this.stageName,
    required this.stageNameHindi,
    required this.daysAfterSowing,
    required this.description,
    required this.descriptionHindi,
    required this.criticalAction,
    required this.criticalActionHindi,
    required this.icon,
  });
}

class CropCalendarScreen extends StatefulWidget {
  const CropCalendarScreen({super.key});

  @override
  State<CropCalendarScreen> createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends State<CropCalendarScreen> {
  String _selectedCrop = 'Wheat';

  final Map<String, List<CropStageTimeline>> _cropTimelines = {
    'Wheat': [
      CropStageTimeline(
        stageName: 'Sowing & Germination',
        stageNameHindi: 'बुवाई व अंकुरण',
        daysAfterSowing: '0 – 10 DAS',
        description: 'Coleoptile emergence and radical anchor root establishment.',
        descriptionHindi: 'बीज से अंकुर निकलना व प्राथमिक जड़ों का मिट्टी में स्थापित होना।',
        criticalAction: 'Apply basal dose of NPK (120:60:40) & ensure optimal seed moisture.',
        criticalActionHindi: 'बुवाई के समय NPK की आधार खुराक दें और खेत में नमी सुनिश्चित करें।',
        icon: LucideIcons.sprout,
      ),
      CropStageTimeline(
        stageName: 'Crown Root Initiation (CRI)',
        stageNameHindi: 'मुकुट जड़ निर्माण (CRI स्टेज)',
        daysAfterSowing: '20 – 25 DAS',
        description: 'Crown roots emerge just below soil surface. Most moisture-sensitive stage.',
        descriptionHindi: 'जमीन की सतह के नीचे मुकुट जड़ें फूटती हैं। यह फसल की सबसे संवेदनशील अवस्था है।',
        criticalAction: 'CRITICAL: First irrigation is mandatory. Delay causes 30% yield loss.',
        criticalActionHindi: 'अति आवश्यक: पहली सिंचाई अवश्य करें। देरी से पैदावार में 30% गिरावट आ सकती है।',
        icon: LucideIcons.droplets,
      ),
      CropStageTimeline(
        stageName: 'Active Tillering & Jointing',
        stageNameHindi: 'कल्ले फूटना व तना बढ़ना',
        daysAfterSowing: '40 – 45 DAS',
        description: 'Rapid side tillers expansion and internode elongation.',
        descriptionHindi: 'पौधों में अधिक कल्ले बनते हैं और तना तेजी से ऊपर बढ़ता है।',
        criticalAction: 'Top-dress first split of Urea (30-35 kg/acre) followed by second irrigation.',
        criticalActionHindi: 'यूरिया की पहली टॉप-ड्रेसिंग करें और दूसरी हल्की सिंचाई करें।',
        icon: LucideIcons.layers,
      ),
      CropStageTimeline(
        stageName: 'Booting & Flowering / Heading',
        stageNameHindi: 'गभोभ व बालियां निकलना',
        daysAfterSowing: '65 – 75 DAS',
        description: 'Panicle emerges from flag leaf sheath; flowering and pollination occur.',
        descriptionHindi: 'झंडा पत्ती से बालियां बाहर निकलती हैं और परागण होता है।',
        criticalAction: 'Third irrigation. Scout for yellow rust and armyworm attacks.',
        criticalActionHindi: 'तीसरी सिंचाई करें। पीला रतुआ और सुंडी कीट के प्रकोप पर नजर रखें।',
        icon: LucideIcons.sun,
      ),
      CropStageTimeline(
        stageName: 'Milking & Grain Dough Stage',
        stageNameHindi: 'दूधिया अवस्था व दाना भराव',
        daysAfterSowing: '85 – 100 DAS',
        description: 'Kernel fluid transitions from milky sap to solid starch dough.',
        descriptionHindi: 'दाने में स्टार्च का भराव होता है और दूधिया रस ठोस बनता है।',
        criticalAction: 'Final light irrigation on calm non-windy day to prevent lodging.',
        criticalActionHindi: 'हवा शांत होने पर अंतिम हल्की सिंचाई करें ताकि फसल गिरे नहीं।',
        icon: LucideIcons.wheat,
      ),
      CropStageTimeline(
        stageName: 'Physiological Maturity & Harvest',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '115 – 125 DAS',
        description: 'Straw and ears turn golden yellow; grain moisture drops below 14%.',
        descriptionHindi: 'पौधे सुनहरे पीले पड़ जाते हैं और दानों में नमी 14% से कम हो जाती है।',
        criticalAction: 'Harvest with combine or sickle on sunny day; sun-dry before storage.',
        criticalActionHindi: 'धूप वाले दिन कटाई करें और अनाज को सुखाकर ही भंडारित करें।',
        icon: LucideIcons.circle_check,
      ),
    ],
    'Paddy': [
      CropStageTimeline(
        stageName: 'Nursery Raising & Sowing',
        stageNameHindi: 'नर्सरी तैयारी व बुवाई',
        daysAfterSowing: '0 – 25 DAS',
        description: 'Seed soaking, sprout germination, and nursery bed maintenance.',
        descriptionHindi: 'बीज उपचार, अंकुरण और नर्सरी में स्वस्थ पौध तैयार करना।',
        criticalAction: 'Treat seeds with Carbendazim (2g/kg) and protect nursery from thrips.',
        criticalActionHindi: 'बीज को फफूंदनाशी से उपचारित करें और नर्सरी में कीटों से सुरक्षा रखें।',
        icon: LucideIcons.sprout,
      ),
      CropStageTimeline(
        stageName: 'Transplanting (रोपाई)',
        stageNameHindi: 'खेत में रोपाई',
        daysAfterSowing: '25 – 30 DAS',
        description: 'Transfer 21-25 day seedlings into puddled field (2-3 seedlings/hill).',
        descriptionHindi: '21-25 दिन की स्वस्थ पौध को तैयार खेत में 20x15 सेमी की दूरी पर लगाएं।',
        criticalAction: 'Maintain 2-3 cm shallow water layer; apply zinc sulphate (25 kg/ha).',
        criticalActionHindi: 'खेत में 2-3 सेमी पानी रखें और जिंक सल्फेट खाद अवश्य डालें।',
        icon: LucideIcons.droplets,
      ),
      CropStageTimeline(
        stageName: 'Panicle Initiation & Flowering',
        stageNameHindi: 'बाली बनना व फूल आना',
        daysAfterSowing: '60 – 75 DAS',
        description: 'Stem thickens as embryo panicle develops inside sheath.',
        descriptionHindi: 'तने के अंदर बाली का विकास होता है और दाना बनना शुरू होता है।',
        criticalAction: 'Strict moisture maintenance; inspect for stem borer and blast disease.',
        criticalActionHindi: 'खेत में पानी की कमी न होने दें; तना छेदक व झोंका रोग की जांच करें।',
        icon: LucideIcons.shield_alert,
      ),
      CropStageTimeline(
        stageName: 'Harvesting & Threshing',
        stageNameHindi: 'फसल कटाई व गहाई',
        daysAfterSowing: '120 – 135 DAS',
        description: '80-85% grains turn golden yellow and hard.',
        descriptionHindi: '85% दाने सुनहरे और कड़े हो जाएं तब फसल कटाई करें।',
        criticalAction: 'Drain field 7-10 days before harvest to facilitate machinery access.',
        criticalActionHindi: 'कटाई से 7-10 दिन पहले खेत का पानी निकाल दें।',
        icon: LucideIcons.circle_check,
      ),
    ],
    'Mustard': [
      CropStageTimeline(
        stageName: 'Sowing & Seedling Emergence',
        stageNameHindi: 'बुवाई व अंकुरण',
        daysAfterSowing: '0 – 10 DAS',
        description: 'Germination and cotyledon leaf opening.',
        descriptionHindi: 'बीज अंकुरण व प्राथमिक पत्तियों का निकलना।',
        criticalAction: 'Thinning at 12-15 days to maintain 10-15 cm plant spacing.',
        criticalActionHindi: '12-15 दिन में विरलीकरण (Thinning) करके 10-15 सेमी की दूरी बनाएं।',
        icon: LucideIcons.sprout,
      ),
      CropStageTimeline(
        stageName: 'Flowering & Aphid Scouting',
        stageNameHindi: 'फूल आना व माहू निगरानी',
        daysAfterSowing: '40 – 55 DAS',
        description: 'Vibrant yellow flowers bloom across field. High aphid susceptibility.',
        descriptionHindi: 'पीले फूल खिलना; इस समय माहू (चेपा) कीट का भारी खतरा रहता है।',
        criticalAction: 'Spray Dimethoate 30% EC (1.5 ml/L) or Neem oil if aphids exceed ETL.',
        criticalActionHindi: 'माहू दिखने पर तुरंत डाइमेथोएट (1.5 मिली/लीटर) या नीम तेल का छिड़काव करें।',
        icon: LucideIcons.shield_alert,
      ),
      CropStageTimeline(
        stageName: 'Pod Filling & Harvesting',
        stageNameHindi: 'फलियां पकना व कटाई',
        daysAfterSowing: '100 – 115 DAS',
        description: 'Pods turn golden brown and seeds darken inside.',
        descriptionHindi: 'फलियां सुनहरी-भूरी हो जाती हैं और बीज काले/चमकदार पड़ जाते हैं।',
        criticalAction: 'Harvest early morning to prevent pod shattering and seed loss.',
        criticalActionHindi: 'फलियां चटकने से बचाने के लिए सुबह के समय ही कटाई करें।',
        icon: LucideIcons.circle_check,
      ),
    ],
    'Chickpea': [
      CropStageTimeline(
        stageName: 'Sowing & Nodule Formation',
        stageNameHindi: 'बुवाई व गांठ निर्माण',
        daysAfterSowing: '0 – 25 DAS',
        description: 'Root emergence and symbiotic rhizobium nodule development.',
        descriptionHindi: 'जड़ों में नाइट्रोजन स्थिरीकरण करने वाली ग्रंथियों (Nodules) का विकास।',
        criticalAction: 'Treat seeds with Rhizobium culture; avoid over-irrigation to prevent wilt.',
        criticalActionHindi: 'राइजोबियम कल्चर से बीजोपचार करें; उकठा रोग से बचाव हेतु जलभराव न होने दें।',
        icon: LucideIcons.sprout,
      ),
      CropStageTimeline(
        stageName: 'Branching & Pod Borer Check',
        stageNameHindi: 'शाखाएं निकलना व फली छेदक',
        daysAfterSowing: '50 – 70 DAS',
        description: 'Profuse vegetative branching and pod initiation.',
        descriptionHindi: 'घनी शाखाएं निकलना और फलियां बनना शुरू होना।',
        criticalAction: 'Install pheromone traps (5/ha) for Helicoverpa pod borer.',
        criticalActionHindi: 'फली छेदक इल्ली की रोकथाम के लिए फेरोमोन ट्रैप (5 प्रति हेक्टेयर) लगाएं।',
        icon: LucideIcons.shield_alert,
      ),
      CropStageTimeline(
        stageName: 'Pod Maturity & Harvest',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '110 – 125 DAS',
        description: 'Plants dry out and turn light brownish yellow.',
        descriptionHindi: 'पौधे सूखकर हल्के भूरे हो जाते हैं और फलियों में दाने खड़कने लगते हैं।',
        criticalAction: 'Harvest when leaves fall and pods rattle on shaking.',
        criticalActionHindi: 'पत्ते झड़ने और फलियों में दाने खड़कने पर कटाई करें।',
        icon: LucideIcons.circle_check,
      ),
    ],
  };

  DateTime _sowingDate = DateTime.now().subtract(const Duration(days: 22));

  int get _currentDas => DateTime.now().difference(_sowingDate).inDays;

  Future<void> _pickSowingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sowingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 180)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _sowingDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final stages = _cropTimelines[_selectedCrop] ?? _cropTimelines['Wheat']!;

    return Scaffold(
      appBar: CustomAppBar(
        titleKey: lang.isHindi ? 'फसल कैलेंडर' : 'Crop Calendar',
        showLanguageToggle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Switcher Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildCropPill('Wheat', lang.isHindi ? 'गेहूं' : 'Wheat'),
                  const SizedBox(width: 8),
                  _buildCropPill('Paddy', lang.isHindi ? 'धान' : 'Paddy'),
                  const SizedBox(width: 8),
                  _buildCropPill('Mustard', lang.isHindi ? 'सरसों' : 'Mustard'),
                  const SizedBox(width: 8),
                  _buildCropPill('Chickpea', lang.isHindi ? 'चना' : 'Gram'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Sowing Date & Current Age Cockpit (Borderless Surface)
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.isHindi ? 'बुवाई की तिथि (Sowing Date)' : 'Sowing Date',
                        style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${_sowingDate.day}/${_sowingDate.month}/${_sowingDate.year}',
                            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                        ),
                        child: Text(
                          lang.isHindi ? 'आयु: $_currentDas दिन (DAS)' : 'Age: $_currentDas Days',
                          style: AppTypography.bodySmall().copyWith(
                            color: const Color(0xFF15803D),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _pickSowingDate,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
                          ),
                          child: Text(
                            lang.isHindi ? 'बदलें' : 'Change',
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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

            Row(
              children: [
                const Icon(LucideIcons.git_commit_vertical, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  lang.isHindi
                      ? 'ICAR प्रामाणिक फसल विकास चक्र (Stages Timeline)'
                      : 'ICAR Package of Practices Timeline',
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Connected Vertical Timeline Stages
            ...List.generate(stages.length, (idx) {
              final stage = stages[idx];
              final isLast = idx == stages.length - 1;
              return _buildTimelineItem(context, stage, isLast);
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCropPill(String cropKey, String label) {
    final isSelected = _selectedCrop == cropKey;
    return InkWell(
      onTap: () => setState(() => _selectedCrop = cropKey),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF15803D) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF15803D).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall().copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, CropStageTimeline stage, bool isLast) {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final title = lang.isHindi ? stage.stageNameHindi : stage.stageName;
    final desc = lang.isHindi ? stage.descriptionHindi : stage.description;
    final action = lang.isHindi ? stage.criticalActionHindi : stage.criticalAction;

    int startDays = 0;
    int endDays = 10;
    final dasClean = stage.daysAfterSowing.replaceAll('DAS', '').trim();
    final parts = dasClean.split(RegExp(r'[–\-]'));
    if (parts.isNotEmpty) {
      startDays = int.tryParse(parts[0].trim()) ?? 0;
      endDays = parts.length > 1 ? (int.tryParse(parts[1].trim()) ?? startDays + 5) : startDays + 5;
    }

    final targetStartDate = _sowingDate.add(Duration(days: startDays));
    final targetEndDate = _sowingDate.add(Duration(days: endDays));
    final now = DateTime.now();
    final isPassed = now.isAfter(targetEndDate);
    final isCurrent = !isPassed && now.isAfter(targetStartDate.subtract(const Duration(days: 1)));

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline Spine & Node
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Node
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF15803D)
                        : (isPassed ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFF15803D)
                          : (isPassed ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1)),
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isPassed
                          ? LucideIcons.check
                          : (isCurrent ? LucideIcons.dot : stage.icon),
                      size: isPassed ? 14 : (isCurrent ? 20 : 13),
                      color: isCurrent
                          ? Colors.white
                          : (isPassed ? const Color(0xFF15803D) : const Color(0xFF94A3B8)),
                    ),
                  ),
                ),
                // Spine line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isPassed ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right Stage Content Card (Borderless Surface)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCurrent ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                  width: isCurrent ? 1.2 : 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCurrent
                        ? const Color(0xFF15803D).withValues(alpha: 0.08)
                        : const Color(0x05000000),
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
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                            fontSize: 15,
                            color: isCurrent ? const Color(0xFF14532D) : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFF15803D)
                              : (isPassed ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF15803D)
                                : (isPassed ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0)),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isCurrent)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(LucideIcons.radio, size: 10, color: Colors.white),
                              )
                            else if (isPassed)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(LucideIcons.check, size: 10, color: Color(0xFF15803D)),
                              ),
                            Text(
                              isCurrent
                                  ? (lang.isHindi ? 'वर्तमान' : 'Current')
                                  : (isPassed
                                      ? (lang.isHindi ? 'संपन्न' : 'Done')
                                      : stage.daysAfterSowing),
                              style: AppTypography.bodySmall().copyWith(
                                color: isCurrent
                                    ? Colors.white
                                    : (isPassed ? const Color(0xFF15803D) : AppColors.textMuted),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar_days, size: 12, color: Color(0xFF15803D)),
                      const SizedBox(width: 4),
                      Text(
                        '${targetStartDate.day}/${targetStartDate.month} – ${targetEndDate.day}/${targetEndDate.month}',
                        style: AppTypography.bodySmall().copyWith(
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ICAR Critical Action Pill Banner
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        left: BorderSide(color: Color(0xFFF59E0B), width: 3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.triangle_alert, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            action,
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 12,
                              color: const Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
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
}
