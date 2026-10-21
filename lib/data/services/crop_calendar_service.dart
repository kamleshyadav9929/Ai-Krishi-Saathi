class CropStageTimeline {
  final String stageName;
  final String stageNameHindi;
  final String daysAfterSowing;
  final String description;
  final String descriptionHindi;
  final String criticalAction;
  final String criticalActionHindi;
  final int stageIndex;
  final int minDays;
  final int maxDays;

  const CropStageTimeline({
    required this.stageName,
    required this.stageNameHindi,
    required this.daysAfterSowing,
    required this.description,
    required this.descriptionHindi,
    required this.criticalAction,
    required this.criticalActionHindi,
    required this.stageIndex,
    required this.minDays,
    required this.maxDays,
  });
}

class CropCalendarService {
  static const Map<String, List<CropStageTimeline>> _cropTimelines = {
    'Wheat': [
      CropStageTimeline(
        stageName: 'Sowing & Germination',
        stageNameHindi: 'बुवाई व अंकुरण',
        daysAfterSowing: '0 – 10 DAS',
        description: 'Coleoptile emergence and radical anchor root establishment.',
        descriptionHindi: 'बीज से अंकुर निकलना व प्राथमिक जड़ों का मिट्टी में स्थापित होना।',
        criticalAction: 'Seed treatment with Trichoderma (5g/kg) and proper shallow depth sowing (4-5 cm).',
        criticalActionHindi: 'ट्राइकोडर्मा (5 ग्राम/किग्रा) से बीजोपचार व 4-5 सेमी गहराई पर बुवाई।',
        stageIndex: 0,
        minDays: 0,
        maxDays: 10,
      ),
      CropStageTimeline(
        stageName: 'Crown Root Initiation (CRI)',
        stageNameHindi: 'मुकुट जड़ निर्माण (CRI स्टेज)',
        daysAfterSowing: '20 – 25 DAS',
        description: 'Crown roots emerge just below soil surface. Most moisture-sensitive stage.',
        descriptionHindi: 'जमीन की सतह के नीचे मुकुट जड़ें फूटती हैं। यह फसल की सबसे संवेदनशील अवस्था है।',
        criticalAction: 'First critical irrigation + first top dressing of Urea (30 kg/acre).',
        criticalActionHindi: 'पहली अनिवार्य सिंचाई करें + 30 किग्रा यूरिया प्रति एकड़ टॉप ड्रेसिंग।',
        stageIndex: 1,
        minDays: 20,
        maxDays: 25,
      ),
      CropStageTimeline(
        stageName: 'Active Tillering & Jointing',
        stageNameHindi: 'कल्ले फूटना व तना बढ़ना',
        daysAfterSowing: '40 – 45 DAS',
        description: 'Rapid side tillers expansion and internode elongation.',
        descriptionHindi: 'पौधों में अधिक कल्ले बनते हैं और तना तेजी से ऊपर बढ़ता है।',
        criticalAction: 'Second irrigation + broadleaf weed control (Metsulfuron Methyl spray).',
        criticalActionHindi: 'दूसरी सिंचाई करें + चौड़ी पत्ती वाले खरपतवार नियंत्रण हेतु मेटसल्फ्यूरॉन का छिड़काव।',
        stageIndex: 2,
        minDays: 40,
        maxDays: 45,
      ),
      CropStageTimeline(
        stageName: 'Flowering & Booting',
        stageNameHindi: 'बाली निकलना व फूल आना',
        daysAfterSowing: '65 – 75 DAS',
        description: 'Spikelets develop inside boot leaf and pollen anthesis occurs.',
        descriptionHindi: 'पौधे की गोभ से बाली बाहर आती है और परागण की प्रक्रिया होती है।',
        criticalAction: 'Third irrigation (avoid during strong winds to prevent lodging) + Aphid scouting.',
        criticalActionHindi: 'हल्की सिंचाई (तेज हवा में न करें) + माहू/चेपा कीट की नियमित निगरानी।',
        stageIndex: 3,
        minDays: 65,
        maxDays: 75,
      ),
      CropStageTimeline(
        stageName: 'Milking & Grain Filling',
        stageNameHindi: 'दुग्ध व दाना भराव अवस्था',
        daysAfterSowing: '85 – 95 DAS',
        description: 'Nutrients accumulate inside kernels, starting with milky sap then firming up.',
        descriptionHindi: 'बालियों में दूधिया रस भरता है जो धीरे-धीरे ठोस दाने में बदलता है।',
        criticalAction: 'Fourth light irrigation. Spray 0:52:34 (1 kg/acre) for bold, heavy grain yield.',
        criticalActionHindi: 'हल्की सिंचाई + 0:52:34 (1 किग्रा/एकड़) का छिड़काव चमकदार व मोटे दानों हेतु।',
        stageIndex: 4,
        minDays: 85,
        maxDays: 95,
      ),
      CropStageTimeline(
        stageName: 'Physiological Maturity & Harvest',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '115 – 125 DAS',
        description: 'Grains turn golden amber and moisture drops below 14% for storage.',
        descriptionHindi: 'फसल सुनहरी पीली पड़ जाती है और दानों में नमी 14% से कम हो जाती है।',
        criticalAction: 'Harvest when stalks are crisp. Thresh and store at safe moisture.',
        criticalActionHindi: 'धूप में अच्छी तरह सूखने पर कंबाइन/रीपर से कटाई करें व सुरक्षित भंडारण करें।',
        stageIndex: 5,
        minDays: 115,
        maxDays: 125,
      ),
    ],
    'Paddy': [
      CropStageTimeline(
        stageName: 'Nursery & Seedling',
        stageNameHindi: 'नर्सरी व पौध तैयार करना',
        daysAfterSowing: '0 – 25 DAS',
        description: 'Seed sprouting in nursery bed, achieving 4-5 leaf stage.',
        descriptionHindi: 'नर्सरी में बीज अंकुरण व 20-25 दिन में 4-5 पत्ती वाली स्वस्थ पौध तैयार होना।',
        criticalAction: 'Pre-germinated seed sowing + zinc sulfate spray in nursery bed.',
        criticalActionHindi: 'अंकुरित बीज की बुवाई + नर्सरी में जिंक सल्फेट का छिड़काव।',
        stageIndex: 0,
        minDays: 0,
        maxDays: 25,
      ),
      CropStageTimeline(
        stageName: 'Transplanting & Rooting',
        stageNameHindi: 'रोपाई व जड़ स्थापना',
        daysAfterSowing: '25 – 35 DAS',
        description: 'Seedlings transplanted into puddled field with standing water.',
        descriptionHindi: 'लेह किए हुए खेत में 2-3 सेमी पानी रखकर 2-3 पौधों की रोपाई।',
        criticalAction: 'Basal application of DAP + Potash + Zinc. Maintain 2-3 cm water level.',
        criticalActionHindi: 'डीएपी + पोटाश + जिंक की बेसल खुराक दें। खेत में 2-3 सेमी पानी बनाए रखें।',
        stageIndex: 1,
        minDays: 25,
        maxDays: 35,
      ),
      CropStageTimeline(
        stageName: 'Max Tillering Stage',
        stageNameHindi: 'कल्ले फूटना (टिलरिंग)',
        daysAfterSowing: '45 – 55 DAS',
        description: 'Hill produces 15-25 active tillers for prospective panicles.',
        descriptionHindi: 'प्रति पौधा 15 से 25 कल्ले फूटते हैं जो उपज का मुख्य आधार हैं।',
        criticalAction: 'First top dressing of Urea (35 kg/acre) + Stem borer pheromone traps.',
        criticalActionHindi: 'यूरिया (35 किग्रा/एकड़) का पहला छिड़काव + तना छेदक हेतु फेरोमोन ट्रैप लगाएं।',
        stageIndex: 2,
        minDays: 45,
        maxDays: 55,
      ),
      CropStageTimeline(
        stageName: 'Panicle Initiation & Booting',
        stageNameHindi: 'बाली का निर्माण (गोभ अवस्था)',
        daysAfterSowing: '70 – 80 DAS',
        description: 'Panicle primordia elongates inside sheath. Critical water stage.',
        descriptionHindi: 'तने के अंदर बाली का निर्माण शुरू होता है। पानी की कमी नहीं होनी चाहिए।',
        criticalAction: 'Continuous 5 cm standing water. Apply Neem coated Urea.',
        criticalActionHindi: 'खेत में 5 सेमी पानी बनाए रखें। नीम लेपित यूरिया की बची खुराक डालें।',
        stageIndex: 3,
        minDays: 70,
        maxDays: 80,
      ),
      CropStageTimeline(
        stageName: 'Flowering & Milky Grain',
        stageNameHindi: 'फूल आना व दूधिया दाना',
        daysAfterSowing: '90 – 105 DAS',
        description: 'Anthesis in mornings followed by starch deposition inside grain.',
        descriptionHindi: 'सुबह के समय फूल खिलते हैं और दानों में चावल का भराव शुरू होता है।',
        criticalAction: 'BPH (Brown Planthopper) monitoring. Drain excess water 10 days before harvest.',
        criticalActionHindi: 'माहू/भूरा फुदका कीट की जांच करें। कटाई से 10-12 दिन पहले खेत से पानी निकाल दें।',
        stageIndex: 4,
        minDays: 90,
        maxDays: 105,
      ),
      CropStageTimeline(
        stageName: 'Ripening & Harvesting',
        stageNameHindi: 'फसल पकना व कटाई',
        daysAfterSowing: '125 – 140 DAS',
        description: 'Panicles bend gracefully, changing from green to golden straw color.',
        descriptionHindi: 'बालियां झुक जाती हैं और 85% दाने सुनहरे पीले रंग के हो जाते हैं।',
        criticalAction: 'Harvest when grains are golden. Dry grains to 12% moisture before bagging.',
        criticalActionHindi: 'कटाई करें व दानों को सुखाकर 12% नमी पर बोरों में सुरक्षित रखें।',
        stageIndex: 5,
        minDays: 125,
        maxDays: 140,
      ),
    ],
    'Mustard': [
      CropStageTimeline(
        stageName: 'Germination & Emergence',
        stageNameHindi: 'अंकुरण व फैलाव',
        daysAfterSowing: '0 – 8 DAS',
        description: 'Small cotyledon leaves emerge in rows.',
        descriptionHindi: 'बीज से दो दल वाली हरी पत्तियां जमीन से बाहर निकलती हैं।',
        criticalAction: 'Ensure adequate seed moisture at sowing. Protect from painted bug.',
        criticalActionHindi: 'बुवाई के समय पर्याप्त नमी रखें। चितकबरा कीट (पेंटेड बग) से रक्षा करें।',
        stageIndex: 0,
        minDays: 0,
        maxDays: 8,
      ),
      CropStageTimeline(
        stageName: 'Thinning & Vegetative',
        stageNameHindi: 'छंटाई व वनस्पति वृद्धि',
        daysAfterSowing: '15 – 25 DAS',
        description: 'Plants thinned to 10-12 cm spacing for bushy lateral growth.',
        descriptionHindi: 'पौधों के बीच 10-12 सेमी की दूरी रखने हेतु अतिरिक्त पौधे उखाड़ दें।',
        criticalAction: 'Thinning is mandatory for high branching. Light weeding.',
        criticalActionHindi: 'छंटाई (थिनिंग) अनिवार्य रूप से करें। हल्की निराई-गुड़ाई करें।',
        stageIndex: 1,
        minDays: 15,
        maxDays: 25,
      ),
      CropStageTimeline(
        stageName: 'Branching & Pre-Flowering',
        stageNameHindi: 'शाखाएं निकलना (ब्रांचिंग)',
        daysAfterSowing: '35 – 45 DAS',
        description: 'Numerous primary and secondary branches sprout from main axis.',
        descriptionHindi: 'मुख्य तने से कई मजबूत शाखाएं निकलती हैं।',
        criticalAction: 'First critical irrigation + top dressing of Urea and Sulfur (20 kg/acre).',
        criticalActionHindi: 'पहली सिंचाई करें + यूरिया के साथ 20 किग्रा सल्फर/एकड़ डालें (तेल की मात्रा बढ़ेगी)।',
        stageIndex: 2,
        minDays: 35,
        maxDays: 45,
      ),
      CropStageTimeline(
        stageName: 'Full Flowering Stage',
        stageNameHindi: 'पीले फूलों की बहार',
        daysAfterSowing: '55 – 65 DAS',
        description: 'Field turns bright yellow. Honeybees pollinate blooms.',
        descriptionHindi: 'पूरा खेत पीले फूलों से ढक जाता है। मधुमक्खियां परागण करती हैं।',
        criticalAction: 'Scout for Aphid (माहू) infestation. Spray Neem oil (5ml/L) or Dimethoate if needed.',
        criticalActionHindi: 'माहू कीट पर नजर रखें। प्रारंभिक अवस्था में नीम तेल (5 मिली/लीटर) का छिड़काव करें।',
        stageIndex: 3,
        minDays: 55,
        maxDays: 65,
      ),
      CropStageTimeline(
        stageName: 'Siliqua (Pod) Formation',
        stageNameHindi: 'फलियां (सिलिक्वा) बनना',
        daysAfterSowing: '75 – 90 DAS',
        description: 'Elongated pods fill with mustard seeds.',
        descriptionHindi: 'फूलों के स्थान पर लंबी फलियां बनती हैं और दानों में तेल का संचय होता है।',
        criticalAction: 'Second light irrigation if winter rain fails. Protect from frost (पाला).',
        criticalActionHindi: 'यदि बारिश न हो तो हल्की सिंचाई करें। पाले से बचाव हेतु खेत की मेड़ों पर धुआं करें।',
        stageIndex: 4,
        minDays: 75,
        maxDays: 90,
      ),
      CropStageTimeline(
        stageName: 'Maturity & Harvesting',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '110 – 125 DAS',
        description: 'Siliquae turn golden brown and seeds rattle inside.',
        descriptionHindi: 'फलियां सूखकर सुनहरी भूरी हो जाती हैं और दाने खड़कने लगते हैं।',
        criticalAction: 'Harvest early morning to prevent pod shattering. Sun dry on tarpaulin.',
        criticalActionHindi: 'फलियां चटकने से बचाने हेतु सुबह के समय कटाई करें व तिरपाल पर सुखाएं।',
        stageIndex: 5,
        minDays: 110,
        maxDays: 125,
      ),
    ],
  };

  static List<String> getSupportedCrops() => _cropTimelines.keys.toList();

  static List<CropStageTimeline> getTimelineForCrop(String crop) {
    return _cropTimelines[crop] ?? _cropTimelines['Wheat']!;
  }

  /// Calculates the current biological stage based on sowing date
  static CropStageTimeline getCurrentStage(String crop, DateTime sowingDate) {
    final stages = getTimelineForCrop(crop);
    final daysElapsed = DateTime.now().difference(sowingDate).inDays;

    for (final stage in stages.reversed) {
      if (daysElapsed >= stage.minDays) {
        return stage;
      }
    }
    return stages.first;
  }
}
