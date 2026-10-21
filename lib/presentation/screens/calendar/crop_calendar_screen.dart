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

  const CropStageTimeline({
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
      const CropStageTimeline(
        stageName: 'Sowing & Germination',
        stageNameHindi: 'बुवाई व अंकुरण',
        daysAfterSowing: '0 – 10 DAS',
        description: 'Coleoptile emergence and radical anchor root establishment.',
        descriptionHindi: 'बीज से अंकुर निकलना व प्राथमिक जड़ों का मिट्टी में स्थापित होना।',
        criticalAction: 'Seed treatment with Trichoderma (5g/kg) and proper shallow depth sowing (4-5 cm).',
        criticalActionHindi: 'ट्राइकोडर्मा (5 ग्राम/किग्रा) से बीजोपचार व 4-5 सेमी गहराई पर बुवाई।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Crown Root Initiation (CRI)',
        stageNameHindi: 'मुकुट जड़ निर्माण (CRI स्टेज)',
        daysAfterSowing: '20 – 25 DAS',
        description: 'Crown roots emerge just below soil surface. Most moisture-sensitive stage.',
        descriptionHindi: 'जमीन की सतह के नीचे मुकुट जड़ें फूटती हैं। यह फसल की सबसे संवेदनशील अवस्था है।',
        criticalAction: 'First critical irrigation + first top dressing of Urea (30 kg/acre).',
        criticalActionHindi: 'पहली अनिवार्य सिंचाई करें + 30 किग्रा यूरिया प्रति एकड़ टॉप ड्रेसिंग।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Active Tillering & Jointing',
        stageNameHindi: 'कल्ले फूटना व तना बढ़ना',
        daysAfterSowing: '40 – 45 DAS',
        description: 'Rapid side tillers expansion and internode elongation.',
        descriptionHindi: 'पौधों में अधिक कल्ले बनते हैं और तना तेजी से ऊपर बढ़ता है।',
        criticalAction: 'Second irrigation + broadleaf weed control (Metsulfuron Methyl spray).',
        criticalActionHindi: 'दूसरी सिंचाई करें + चौड़ी पत्ती वाले खरपतवार नियंत्रण हेतु मेटसल्फ्यूरॉन का छिड़काव।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Flowering & Booting',
        stageNameHindi: 'बाली निकलना व फूल आना',
        daysAfterSowing: '65 – 75 DAS',
        description: 'Spikelets develop inside boot leaf and pollen anthesis occurs.',
        descriptionHindi: 'पौधे की गोभ से बाली बाहर आती है और परागण की प्रक्रिया होती है।',
        criticalAction: 'Third irrigation (avoid during strong winds to prevent lodging) + Aphid scouting.',
        criticalActionHindi: 'हल्की सिंचाई (तेज हवा में न करें) + माहू/चेपा कीट की नियमित निगरानी।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Milking & Grain Filling',
        stageNameHindi: 'दुग्ध व दाना भराव अवस्था',
        daysAfterSowing: '85 – 95 DAS',
        description: 'Nutrients accumulate inside kernels, starting with milky sap then firming up.',
        descriptionHindi: 'बालियों में दूधिया रस भरता है जो धीरे-धीरे ठोस दाने में बदलता है।',
        criticalAction: 'Fourth light irrigation. Spray 0:52:34 (1 kg/acre) for bold, heavy grain yield.',
        criticalActionHindi: 'हल्की सिंचाई + 0:52:34 (1 किग्रा/एकड़) का छिड़काव चमकदार व मोटे दानों हेतु।',
        icon: LucideIcons.wheat,
      ),
      const CropStageTimeline(
        stageName: 'Physiological Maturity & Harvest',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '115 – 125 DAS',
        description: 'Grains turn golden amber and moisture drops below 14% for storage.',
        descriptionHindi: 'फसल सुनहरी पीली पड़ जाती है और दानों में नमी 14% से कम हो जाती है।',
        criticalAction: 'Harvest when stalks are crisp. Thresh and store at safe moisture.',
        criticalActionHindi: 'धूप में अच्छी तरह सूखने पर कंबाइन/रीपर से कटाई करें व सुरक्षित भंडारण करें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Paddy': [
      const CropStageTimeline(
        stageName: 'Nursery & Sprouting',
        stageNameHindi: 'नर्सरी व पौध तैयार करना',
        daysAfterSowing: '0 – 25 DAS',
        description: 'Seed sprouting in nursery bed, achieving 4-5 leaf healthy seedlings.',
        descriptionHindi: 'नर्सरी में बीज अंकुरण व 20-25 दिन में 4-5 पत्ती वाली स्वस्थ पौध तैयार होना।',
        criticalAction: 'Pre-germinated seed sowing + zinc sulfate spray in nursery bed.',
        criticalActionHindi: 'अंकुरित बीज की बुवाई + नर्सरी में जिंक सल्फेट का छिड़काव।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Transplanting & Rooting',
        stageNameHindi: 'रोपाई व जड़ स्थापना',
        daysAfterSowing: '25 – 35 DAS',
        description: 'Seedlings transplanted into puddled field with standing water.',
        descriptionHindi: 'लेह किए हुए खेत में 2-3 सेमी पानी रखकर 2-3 पौधों की रोपाई।',
        criticalAction: 'Basal application of DAP + Potash + Zinc. Maintain 2-3 cm water level.',
        criticalActionHindi: 'डीएपी + पोटाश + जिंक की बेसल खुराक दें। खेत में 2-3 सेमी पानी बनाए रखें।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Maximum Tillering',
        stageNameHindi: 'कल्ले फूटना (टिलरिंग)',
        daysAfterSowing: '45 – 55 DAS',
        description: 'Hill produces 15-25 active tillers for prospective panicles.',
        descriptionHindi: 'प्रति पौधा 15 से 25 कल्ले फूटते हैं जो उपज का मुख्य आधार हैं।',
        criticalAction: 'First top dressing of Urea (35 kg/acre) + Stem borer pheromone traps.',
        criticalActionHindi: 'यूरिया (35 किग्रा/एकड़) का पहला छिड़काव + तना छेदक हेतु फेरोमोन ट्रैप लगाएं।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Panicle Initiation & Booting',
        stageNameHindi: 'बाली का निर्माण (गोभ अवस्था)',
        daysAfterSowing: '70 – 80 DAS',
        description: 'Panicle primordia elongates inside sheath. Critical water stage.',
        descriptionHindi: 'तने के अंदर बाली का निर्माण शुरू होता है। पानी की कमी नहीं होनी चाहिए।',
        criticalAction: 'Continuous 5 cm standing water. Apply Neem coated Urea.',
        criticalActionHindi: 'खेत में 5 सेमी पानी बनाए रखें। नीम लेपित यूरिया की बची खुराक डालें।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Flowering & Milky Grain',
        stageNameHindi: 'फूल आना व दूधिया दाना',
        daysAfterSowing: '90 – 105 DAS',
        description: 'Anthesis in mornings followed by starch deposition inside grain.',
        descriptionHindi: 'सुबह के समय फूल खिलते हैं और दानों में चावल का भराव शुरू होता है।',
        criticalAction: 'BPH (Brown Planthopper) monitoring. Drain excess water 10 days before harvest.',
        criticalActionHindi: 'माहू/भूरा फुदका कीट की जांच करें। कटाई से 10-12 दिन पहले खेत से पानी निकाल दें।',
        icon: LucideIcons.wheat,
      ),
      const CropStageTimeline(
        stageName: 'Ripening & Harvesting',
        stageNameHindi: 'फसल पकना व कटाई',
        daysAfterSowing: '125 – 140 DAS',
        description: 'Panicles bend gracefully, changing from green to golden straw color.',
        descriptionHindi: 'बालियां झुक जाती हैं और 85% दाने सुनहरे पीले रंग के हो जाते हैं।',
        criticalAction: 'Harvest when grains are golden. Dry grains to 12% moisture before bagging.',
        criticalActionHindi: 'कटाई करें व दानों को सुखाकर 12% नमी पर बोरों में सुरक्षित रखें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Mustard': [
      const CropStageTimeline(
        stageName: 'Germination & Emergence',
        stageNameHindi: 'अंकुरण व फैलाव',
        daysAfterSowing: '0 – 8 DAS',
        description: 'Small cotyledon leaves emerge in rows in moist soil.',
        descriptionHindi: 'बीज से दो दल वाली हरी पत्तियां जमीन से बाहर निकलती हैं।',
        criticalAction: 'Ensure adequate seed moisture at sowing. Protect from painted bug.',
        criticalActionHindi: 'बुवाई के समय पर्याप्त नमी रखें। चितकबरा कीट (पेंटेड बग) से रक्षा करें।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Thinning & Vegetative',
        stageNameHindi: 'छंटाई व वनस्पति वृद्धि',
        daysAfterSowing: '15 – 25 DAS',
        description: 'Plants thinned to 10-12 cm spacing for bushy lateral growth.',
        descriptionHindi: 'पौधों के बीच 10-12 सेमी की दूरी रखने हेतु अतिरिक्त पौधे उखाड़ दें।',
        criticalAction: 'Thinning is mandatory for high branching. Light weeding.',
        criticalActionHindi: 'छंटाई (थिनिंग) अनिवार्य रूप से करें। हल्की निराई-गुड़ाई करें।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Branching & Pre-Flowering',
        stageNameHindi: 'शाखाएं निकलना (ब्रांचिंग)',
        daysAfterSowing: '35 – 45 DAS',
        description: 'Numerous primary and secondary branches sprout from main axis.',
        descriptionHindi: 'मुख्य तने से कई मजबूत शाखाएं निकलती हैं।',
        criticalAction: 'First critical irrigation + top dressing of Urea and Sulfur (20 kg/acre).',
        criticalActionHindi: 'पहली सिंचाई करें + यूरिया के साथ 20 किग्रा सल्फर/एकड़ डालें।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Full Flowering Stage',
        stageNameHindi: 'पीले फूलों की बहार',
        daysAfterSowing: '55 – 65 DAS',
        description: 'Field turns bright yellow. Honeybees pollinate blooms.',
        descriptionHindi: 'पूरा खेत पीले फूलों से ढक जाता है। मधुमक्खियां परागण करती हैं।',
        criticalAction: 'Scout for Aphid (माहू) infestation. Spray Neem oil (5ml/L) or Dimethoate if needed.',
        criticalActionHindi: 'माहू कीट पर नजर रखें। प्रारंभिक अवस्था में नीम तेल (5 मिली/लीटर) का छिड़काव करें।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Siliqua (Pod) Formation',
        stageNameHindi: 'फलियां (सिलिक्वा) बनना',
        daysAfterSowing: '75 – 90 DAS',
        description: 'Elongated pods fill with mustard seeds.',
        descriptionHindi: 'फूलों के स्थान पर लंबी फलियां बनती हैं और दानों में तेल का संचय होता है।',
        criticalAction: 'Second light irrigation if winter rain fails. Protect from frost (पाला).',
        criticalActionHindi: 'यदि बारिश न हो तो हल्की सिंचाई करें। पाले से बचाव हेतु खेत की मेड़ों पर धुआं करें।',
        icon: LucideIcons.wheat,
      ),
      const CropStageTimeline(
        stageName: 'Maturity & Harvesting',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '110 – 125 DAS',
        description: 'Siliquae turn golden brown and seeds rattle inside.',
        descriptionHindi: 'फलियां सूखकर सुनहरी भूरी हो जाती हैं और दाने खड़कने लगते हैं।',
        criticalAction: 'Harvest early morning to prevent pod shattering. Sun dry on tarpaulin.',
        criticalActionHindi: 'फलियां चटकने से बचाने हेतु सुबह के समय कटाई करें व तिरपाल पर सुखाएं।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Chickpea': [
      const CropStageTimeline(
        stageName: 'Germination & Seedling',
        stageNameHindi: 'अंकुरण व प्रारंभिक पौध',
        daysAfterSowing: '0 – 12 DAS',
        description: 'Deep taproot emergence with compound pinnate leaves.',
        descriptionHindi: 'जमीन में गहरी मूसला जड़ निकलना व पत्तियों का फैलाव।',
        criticalAction: 'Treat seeds with Rhizobium and PSB culture (10g/kg).',
        criticalActionHindi: 'राइजोबियम व पीएसबी कल्चर (10 ग्राम/किग्रा) से बीजोपचार अनिवार्य।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Branching & Nipping',
        stageNameHindi: 'शाखाएं निकलना व तुड़ाई (निपिंग)',
        daysAfterSowing: '25 – 35 DAS',
        description: 'Vegetative shoots multiply from crown.',
        descriptionHindi: 'पौधों में पार्श्व शाखाओं का तेजी से विकास होता है।',
        criticalAction: 'Nip top tender shoots at 30 DAS to induce profuse bushy branching.',
        criticalActionHindi: '30 दिन पर ऊपरी कोमल टहनी तोड़ें (निपिंग) ताकि घनी शाखाएं और अधिक फलियां बनें।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Pre-Flowering & Budding',
        stageNameHindi: 'फूल आने से पहले की अवस्था',
        daysAfterSowing: '45 – 55 DAS',
        description: 'Floral buds appear on axillary branches.',
        descriptionHindi: 'शाखाओं पर नन्हीं कलियां बनने लगती हैं।',
        criticalAction: 'One light irrigation if soil is dry. Avoid heavy flooding.',
        criticalActionHindi: 'यदि मिट्टी सूखी हो तो हल्की सिंचाई करें (अधिक पानी से उकठा रोग का खतरा)।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Podding & Pod Borer Watch',
        stageNameHindi: 'फलियां बनना व इल्ली निगरानी',
        daysAfterSowing: '65 – 80 DAS',
        description: 'Pods inflate and green seeds develop inside.',
        descriptionHindi: 'फलियों में हरे दानों का भराव शुरू होता है।',
        criticalAction: "Install 'T' shaped bird perches (20/acre) and pheromone traps for Helicoverpa borer.",
        criticalActionHindi: "खेत में 'T' आकार की खूंटियां (20/एकड़) लगाएं व फल छेदक इल्ली की रोकथाम करें।",
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Pod Maturity & Harvest',
        stageNameHindi: 'परिपक्वता व कटाई',
        daysAfterSowing: '110 – 125 DAS',
        description: 'Plants dry out and turn light brownish yellow.',
        descriptionHindi: 'पौधे सूखकर हल्के भूरे हो जाते हैं और फलियों में दाने खड़कने लगते हैं।',
        criticalAction: 'Harvest when 90% pods turn brown. Store at 9-10% moisture.',
        criticalActionHindi: '90% फलियां भूरी होने पर कटाई करें। 9-10% नमी पर सुरक्षित रखें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Maize': [
      const CropStageTimeline(
        stageName: 'Emergence & V3 Stage',
        stageNameHindi: 'अंकुरण व प्राथमिक पत्तियां',
        daysAfterSowing: '0 – 15 DAS',
        description: 'Rapid germination and 3-leaf collar emergence.',
        descriptionHindi: 'बीज अंकुरण व 3-4 पत्तियों का निर्माण।',
        criticalAction: 'Maintain clean weed-free field. Apply Atrazine herbicide within 48 hours.',
        criticalActionHindi: 'खेत को खरपतवार मुक्त रखें। बुवाई के 48 घंटे के भीतर एट्राजिन का छिड़काव।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Knee High Stage (V6–V8)',
        stageNameHindi: 'घुटने की ऊंचाई (तीव्र वृद्धि)',
        daysAfterSowing: '25 – 35 DAS',
        description: 'Rapid stalk elongation and tassel initiation inside stem.',
        descriptionHindi: 'पौधे तेजी से बढ़ते हैं और तने के अंदर नर फूल (टैसल) का निर्माण होता है।',
        criticalAction: 'First top dressing of Urea (40 kg/acre) + Earthing up (मिट्टी चढ़ाना).',
        criticalActionHindi: 'यूरिया की टॉप ड्रेसिंग (40 किग्रा/एकड़) करें और पौधों पर मिट्टी चढ़ाएं।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Tasseling & Silking',
        stageNameHindi: 'मूंछ निकलना व परागण',
        daysAfterSowing: '50 – 60 DAS',
        description: 'Tassels shed pollen and silks emerge from ears. Most critical stage.',
        descriptionHindi: 'ऊपर नर फूल से पराग गिरता है और भुट्टे से रेशम (सिल्क) निकलती है।',
        criticalAction: 'Mandatory irrigation. Moisture stress here causes barren cobs.',
        criticalActionHindi: 'अनिवार्य सिंचाई करें। इस समय पानी की कमी से भुट्टे खाली रह जाते हैं।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Milking & Grain Fill',
        stageNameHindi: 'दूधिया दाना व भुट्टा भराव',
        daysAfterSowing: '70 – 80 DAS',
        description: 'Kernels fill with sweet starch sap, expanding cob size.',
        descriptionHindi: 'दानों में रस भरता है और भुट्टा ठोस व भारी बनता है।',
        criticalAction: 'Light irrigation. Protect cobs from Fall Armyworm (FAW) caterpillar.',
        criticalActionHindi: 'हल्की सिंचाई रखें। फॉल आर्मीवर्म कीट से भुट्टों की रक्षा करें।',
        icon: LucideIcons.wheat,
      ),
      const CropStageTimeline(
        stageName: 'Harvesting & Shelling',
        stageNameHindi: 'भुट्टे की तुड़ाई व कटाई',
        daysAfterSowing: '100 – 115 DAS',
        description: 'Husk turns papery brown and black layer forms at kernel tip.',
        descriptionHindi: 'भुट्टे का छिलका सूखकर सफेद-भूरा हो जाता है और दाने कठोर होते हैं।',
        criticalAction: 'Harvest cobs, sun dry thoroughly, and shell with mechanical sheller.',
        criticalActionHindi: 'भुट्टे तोड़ें, धूप में अच्छी तरह सुखाएं और थ्रेशर से दाने निकालें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Potato': [
      const CropStageTimeline(
        stageName: 'Sprouting & Emergence',
        stageNameHindi: 'आलू अंकुरण व जमाव',
        daysAfterSowing: '0 – 15 DAS',
        description: 'Eyes break dormancy and shoots break through ridges.',
        descriptionHindi: 'आलू की आंखों से कल्ले फूटते हैं और मेड़ों से बाहर निकलते हैं।',
        criticalAction: 'Plant healthy cut tubers treated with Mancozeb (2.5g/L water).',
        criticalActionHindi: 'मेंकोजेब (2.5 ग्राम/लीटर) से उपचारित बीज आलू की मेड़ों पर बुवाई।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Canopy & Tuber Initiation',
        stageNameHindi: 'वनस्पति फैलाव व आलू बैठना',
        daysAfterSowing: '25 – 40 DAS',
        description: 'Stolons hook and swell at tips to form tiny tubers.',
        descriptionHindi: 'जमीन के अंदर धागेनुमा शाखाओं (स्टोलन) के सिरों पर छोटे आलू बनने लगते हैं।',
        criticalAction: 'Earthing up (मिट्टी चढ़ाना) is critical so sunlight does not green the tubers.',
        criticalActionHindi: 'पौधों पर अच्छी तरह मिट्टी चढ़ाएं ताकि आलू धूप से हरे न हों।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Tuber Bulking & Sizing',
        stageNameHindi: 'आलू का मोटा होना (बल्किंग)',
        daysAfterSowing: '50 – 75 DAS',
        description: 'Starch rapidly accumulates; tubers double in weight.',
        descriptionHindi: 'कंदों का आकार तेजी से बढ़ता है और स्टार्च का संचय होता है।',
        criticalAction: 'Regular light furrow irrigation + Spray 0:0:50 (Potash) for size and peel shine.',
        criticalActionHindi: 'हल्की सिंचाई + 0:0:50 (पोटाश 1 किग्रा/एकड़) का छिड़काव चमकदार आलू हेतु।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Dehaulming (बेल काटना)',
        stageNameHindi: 'बेल काटना (डिहॉलमिंग)',
        daysAfterSowing: '80 – 90 DAS',
        description: 'Vines cut 10-15 days before digging to harden potato skin.',
        descriptionHindi: 'खुदाई से 12-15 दिन पहले हरी बेल काट दी जाती है जिससे छिलका सख्त हो।',
        criticalAction: 'Cut vines at ground level and stop irrigation completely.',
        criticalActionHindi: 'जमीन की सतह से बेल काट दें और सिंचाई पूरी तरह बंद कर दें।',
        icon: LucideIcons.scissors,
      ),
      const CropStageTimeline(
        stageName: 'Digging & Curing',
        stageNameHindi: 'खुदाई, सुखाई व भंडारण',
        daysAfterSowing: '95 – 110 DAS',
        description: 'Tubers dug from soil with firm peel ready for cold storage.',
        descriptionHindi: 'सख्त छिलके वाले आलू की खुदाई, छंटाई और शीतगृह (कोल्ड स्टोरेज) भंडारण।',
        criticalAction: 'Cure in dark shaded room for 8-10 days before cold storage bagging.',
        criticalActionHindi: 'छायादार स्थान पर 8-10 दिन सुखाकर (क्योरिंग) ग्रेडिंग करें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Tomato': [
      const CropStageTimeline(
        stageName: 'Nursery & Transplanting',
        stageNameHindi: 'नर्सरी व पौध रोपाई',
        daysAfterSowing: '0 – 30 DAS',
        description: 'Healthy seedlings with 4-5 leaves planted on raised beds.',
        descriptionHindi: 'नर्सरी से 25-30 दिन की स्वस्थ पौध मेड़ों/बेड पर लगाना।',
        criticalAction: 'Dip roots in Trichoderma solution. Mulch beds with silver-black polythene.',
        criticalActionHindi: 'पौध की जड़ों को ट्राइकोडर्मा घोल में डुबोकर रोपाई करें। मल्चिंग का उपयोग करें।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Staking & Vegetative Growth',
        stageNameHindi: 'सहारा देना (स्टेकिंग) व शाखाएं',
        daysAfterSowing: '35 – 50 DAS',
        description: 'Side branches grow vigorous. Plants need wooden stake support.',
        descriptionHindi: 'पौधे तेजी से फैलते हैं। फल जमीन पर न सड़े इसलिए बांस व तार से सहारा दें।',
        criticalAction: 'Tie vines to bamboo stakes with twine. Prune excess bottom suckers.',
        criticalActionHindi: 'बांस की खूंटियों से सहारा दें। निचली अतिरिक्त शाखाओं की छंटाई करें।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Flowering & Fruit Setting',
        stageNameHindi: 'फूल आना व नन्हे टमाटर बनना',
        daysAfterSowing: '55 – 70 DAS',
        description: 'Yellow flower clusters bloom followed by marble-sized green fruits.',
        descriptionHindi: 'पीले फूलों के गुच्छे आते हैं और छोटे हरे फल बनने लगते हैं।',
        criticalAction: 'Spray Calcium Nitrate + Boron (2g/L) to prevent Blossom End Rot (काले धब्बे).',
        criticalActionHindi: 'कैल्शियम नाइट्रेट + बोरॉन का छिड़काव करें ताकि टमाटर का निचला भाग काला न पड़े।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Color Break & First Picking',
        stageNameHindi: 'रंग बदलना व पहली तुड़ाई',
        daysAfterSowing: '80 – 95 DAS',
        description: 'Green fruits turn orange-red breakers stage.',
        descriptionHindi: 'टमाटर हरे से लाल होने लगते हैं और पहली तुड़ाई शुरू होती है।',
        criticalAction: 'Harvest at breaker/pink stage for long transport, red ripe for local mandi.',
        criticalActionHindi: 'दूर की मंडी हेतु गुलाबी रंग पर और स्थानीय बाजार हेतु पके लाल टमाटर तोड़ें।',
        icon: LucideIcons.check_check,
      ),
      const CropStageTimeline(
        stageName: 'Multiple Continuous Pickings',
        stageNameHindi: 'नियमित तुड़ाई व पोषण',
        daysAfterSowing: '100 – 140 DAS',
        description: 'Harvest continues every 3-4 days over next 45 days.',
        descriptionHindi: 'हर तीसरे-चौथे दिन फल की तुड़ाई और पौधे को संतुलित खाद-पानी।',
        criticalAction: 'Apply 19:19:19 via drip weekly. Grade fruits according to market size.',
        criticalActionHindi: 'ड्रिप से 19:19:19 घुलनशील खाद दें और ग्रेडिंग करके क्रेट में पैक करें।',
        icon: LucideIcons.sparkles,
      ),
    ],
    'Cotton': [
      const CropStageTimeline(
        stageName: 'Germination & Square Start',
        stageNameHindi: 'अंकुरण व प्राथमिक वृद्धि',
        daysAfterSowing: '0 – 35 DAS',
        description: 'Seed emergence and taproot penetration into deep soil.',
        descriptionHindi: 'काली/दोमट मिट्टी में अंकुरण व गहरी जड़ स्थापना।',
        criticalAction: 'Maintain plant spacing (90x60 cm). Thin extra plants within 15 DAS.',
        criticalActionHindi: '90x60 सेमी की दूरी रखें। 15 दिन के भीतर अतिरिक्त पौधे निकालें।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Squaring (कली बनना)',
        stageNameHindi: 'स्क्वेयरिंग (कलियां बनना)',
        daysAfterSowing: '35 – 55 DAS',
        description: 'Triangular flower buds (squares) appear on sympodial branches.',
        descriptionHindi: 'शाखाओं पर त्रिकोणीय कलियां (स्क्वायर) निकलती हैं।',
        criticalAction: 'Sucking pest watch (Jassids & Thrips). Spray Neem formulations.',
        criticalActionHindi: 'रस चूसक कीटों (थ्रिप्स, हरा तेला) की निगरानी व नीम कीटनाशक का छिड़काव।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Flowering & Boll Setting',
        stageNameHindi: 'फूल खिलना व गूलर बनना',
        daysAfterSowing: '60 – 85 DAS',
        description: 'White/cream flowers turn pink then form green cotton bolls.',
        descriptionHindi: 'सफेद फूल खिलकर गुलाबी होते हैं और गोल हरे गूलर (बॉल) बनते हैं।',
        criticalAction: 'Critical moisture window. Spray 13:0:45 (Potassium Nitrate 10g/L) for boll retention.',
        criticalActionHindi: 'फूल-गूलर झड़ने से रोकने हेतु 13:0:45 (10 ग्राम/लीटर) का छिड़काव करें।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Boll Bursting & Picking',
        stageNameHindi: 'गूलर फूटना व कपास तुड़ाई',
        daysAfterSowing: '120 – 150 DAS',
        description: 'Bolls burst open revealing fluffy white lint.',
        descriptionHindi: 'गूलर चटक जाते हैं और सफेद चमकदार रुई बाहर निकलती है।',
        criticalAction: 'Pick clean cotton in dry afternoon. Avoid leaves and trash contamination.',
        criticalActionHindi: 'दोपहर की धूप में सूखी व साफ कपास चुनें। सूखी पत्तियां न मिलने दें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Sugarcane': [
      const CropStageTimeline(
        stageName: 'Sett Germination & Sprouting',
        stageNameHindi: 'गन्ना जमाव व अंकुरण',
        daysAfterSowing: '0 – 35 DAS',
        description: 'Eyes on three-bud setts sprout beneath loose moist soil.',
        descriptionHindi: 'तीन आंख वाले गन्ने के टुकड़ों की आंखों से कल्ले फूटते हैं।',
        criticalAction: 'Dip setts in Carbendazim solution before furrow planting.',
        criticalActionHindi: 'कार्बेंडाजिम घोल में गंडेरियों को उपचारित करके कूड़ों में बोएं।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Tillering Phase (कल्ले फूटना)',
        stageNameHindi: 'कल्ले फूटना (टिलरिंग)',
        daysAfterSowing: '40 – 90 DAS',
        description: 'Mother shoot produces 6-8 vigorous tillers per clump.',
        descriptionHindi: 'प्रति पौधा 6 से 8 मजबूत कल्ले निकलते हैं।',
        criticalAction: 'Top dress Urea + Earthing up to prevent shoot borer attacks.',
        criticalActionHindi: 'यूरिया की खुराक दें और हल्की मिट्टी चढ़ाएं (कंसुआ कीट से बचाव)।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Grand Growth Period',
        stageNameHindi: 'तीव्र बढ़वार (लंबाई बढ़ना)',
        daysAfterSowing: '100 – 240 DAS',
        description: 'Internodes rapidly lengthen and cane girth thickens.',
        descriptionHindi: 'गन्ने की पोरियां तेजी से लंबी और मोटी होती हैं।',
        criticalAction: 'Copious irrigations every 10-12 days. Tie canes together (बंधाई) to stop lodging.',
        criticalActionHindi: '10-12 दिन में सिंचाई करें व तेज हवा में गिरने से बचाने हेतु गन्नों की बंधाई करें।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Maturity & Sugar Storage',
        stageNameHindi: 'परिपक्वता व चीनी संचय',
        daysAfterSowing: '270 – 330 DAS',
        description: 'Sucrose accumulates up to 18-20% Brix in stalk tissues.',
        descriptionHindi: 'गन्ने के रस में मिठास (सुक्रोज) बढ़ती है और पत्तियां सूखने लगती हैं।',
        criticalAction: 'Stop nitrogen applications. Test juice Brix with hand refractometer.',
        criticalActionHindi: 'यूरिया पूरी तरह बंद रखें। ब्रिक्स 18-20% होने पर मिल आपूर्ति हेतु कटाई करें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Soyabean': [
      const CropStageTimeline(
        stageName: 'Emergence & Vegetative',
        stageNameHindi: 'अंकुरण व प्राथमिक बढ़वार',
        daysAfterSowing: '0 – 25 DAS',
        description: 'Cotyledons unfold followed by healthy trifoliate leaves.',
        descriptionHindi: 'काली मिट्टी में बीज अंकुरण व तीन पत्तियों वाली शाखाओं का विकास।',
        criticalAction: 'Rhizobium seed inoculation is vital. Pre-emergence weed control.',
        criticalActionHindi: 'राइजोबियम कल्चर से बीजोपचार अनिवार्य। 48 घंटे में खरपतवार नाशक।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Flowering & Pod Initiation',
        stageNameHindi: 'बैंगनी-सफेद फूल व फलियां',
        daysAfterSowing: '35 – 50 DAS',
        description: 'Abundant small blooms set on nodes and tiny pods form.',
        descriptionHindi: 'गांठों पर छोटे फूल खिलते हैं और चपटी हरी फलियां बनती हैं।',
        criticalAction: 'Critical moisture stage. Protect from Girdle Beetle and Semilooper caterpillar.',
        criticalActionHindi: 'पानी की कमी न होने दें। चक्र भृंग (गर्डल बीटल) व इल्ली पर नजर रखें।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Pod Filling (दाना भराव)',
        stageNameHindi: 'फलियों में दाना भराव',
        daysAfterSowing: '55 – 75 DAS',
        description: 'Seeds swell rapidly inside pods, accumulating oil and protein.',
        descriptionHindi: 'दानों में तेल और प्रोटीन का संचय होता है; फलियां मोटी होती हैं।',
        criticalAction: 'Foliar spray of 0:52:34 (1 kg/acre) for bold, oil-rich yellow seeds.',
        criticalActionHindi: '0:52:34 का छिड़काव चमकदार और भारी दानों के लिए करें।',
        icon: LucideIcons.wheat,
      ),
      const CropStageTimeline(
        stageName: 'Maturity & Harvesting',
        stageNameHindi: 'पत्तियां झड़ना व कटाई',
        daysAfterSowing: '90 – 105 DAS',
        description: 'Leaves drop naturally; pods turn brown and rattle when shaken.',
        descriptionHindi: 'सारी पत्तियां झड़ जाती हैं और सूखी फलियां खड़कने लगती हैं।',
        criticalAction: 'Harvest at 13-14% moisture to prevent pod shattering losses.',
        criticalActionHindi: 'फलियां चटकने से पहले कटाई करें। थ्रेशर की गति कम रखें (बीज टूटे नहीं)।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Onion': [
      const CropStageTimeline(
        stageName: 'Nursery & Transplanting',
        stageNameHindi: 'नर्सरी व पौध रोपाई',
        daysAfterSowing: '0 – 45 DAS',
        description: 'Pencil-thick seedlings transplanted on flat or raised beds.',
        descriptionHindi: 'नर्सरी से 40-45 दिन की पेंसिल जैसी स्वस्थ पौध की 15x10 सेमी पर रोपाई।',
        criticalAction: 'Cut upper 1/3 leaf tips of seedlings before planting. Basal DAP + Sulfur.',
        criticalActionHindi: 'रोपाई से पहले पौध की ऊपरी 1/3 पत्ती काटें। सल्फर (20 किग्रा/एकड़) जरूर डालें।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Vegetative Growth & Foliage',
        stageNameHindi: 'पत्तियों की बढ़वार (कनोपी)',
        daysAfterSowing: '50 – 75 DAS',
        description: '8-10 lush tubular green leaves develop per plant.',
        descriptionHindi: 'पौधे पर 8-10 गहरी हरी पत्तियां बनती हैं जो कंद के आकार का आधार हैं।',
        criticalAction: 'Thrips control (नीली पत्तियां होने से बचाएं). First top dress of Urea.',
        criticalActionHindi: 'थ्रिप्स कीट से बचाव करें। यूरिया की पहली खुराक दें।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Bulb Swelling (गांठ फूलना)',
        stageNameHindi: 'प्याज की गांठ फूलना व आकार',
        daysAfterSowing: '80 – 110 DAS',
        description: 'Base expands vigorously into tight, layered round bulb.',
        descriptionHindi: 'पत्तियों का रस नीचे उतरता है और प्याज की गांठ मोटी होती है।',
        criticalAction: 'Frequent light irrigations. Spray Sulfate of Potash (0:0:50) for solid peel.',
        criticalActionHindi: 'हल्की नियमित सिंचाई रखें। 0:0:50 पोटाश का छिड़काव वजन व भंडारण क्षमता बढ़ाएगा।',
        icon: LucideIcons.droplets,
      ),
      const CropStageTimeline(
        stageName: 'Neck Fall & Harvest',
        stageNameHindi: 'गर्दन झुकना (नेक फॉल) व खुदाई',
        daysAfterSowing: '120 – 135 DAS',
        description: '50% tops collapse naturally, signaling bulb physiological maturity.',
        descriptionHindi: '50% पौधों की पत्तियां गर्दन से झुककर जमीन पर गिर जाती हैं।',
        criticalAction: 'Stop watering 15 days before digging. Dry bulbs in shade with foliage for 3 days.',
        criticalActionHindi: 'खुदाई से 15 दिन पहले पानी बंद करें। छाया में 3-4 दिन क्योरिंग करें।',
        icon: LucideIcons.check_check,
      ),
    ],
    'Bajra': [
      const CropStageTimeline(
        stageName: 'Germination & Emergence',
        stageNameHindi: 'अंकुरण व प्रारंभिक जमाव',
        daysAfterSowing: '0 – 10 DAS',
        description: 'Hardy seedlings emerge rapidly even in dry sandy soils.',
        descriptionHindi: 'कम पानी व रेतीली मिट्टी में भी 4-5 दिन में मजबूत अंकुरण।',
        criticalAction: 'Maintain optimal plant distance (45x15 cm). Weed within 20 DAS.',
        criticalActionHindi: '45x15 सेमी दूरी रखें। 20 दिन के भीतर पहली निराई-गुड़ाई करें।',
        icon: LucideIcons.sprout,
      ),
      const CropStageTimeline(
        stageName: 'Tillering & Stem Growth',
        stageNameHindi: 'कल्ले फूटना व तना बढ़ना',
        daysAfterSowing: '20 – 35 DAS',
        description: 'Multiple active tillers grow from basal nodes.',
        descriptionHindi: 'जड़ के पास से 4-5 मजबूत कल्ले निकलते हैं।',
        criticalAction: 'Top dress 25 kg Urea after first monsoon rain or irrigation.',
        criticalActionHindi: 'पहली बारिश या सिंचाई के बाद 25 किग्रा यूरिया प्रति एकड़ डालें।',
        icon: LucideIcons.leaf,
      ),
      const CropStageTimeline(
        stageName: 'Booting & Panicle Bloom',
        stageNameHindi: 'सिट्टा (बाली) निकलना व फूल',
        daysAfterSowing: '45 – 60 DAS',
        description: 'Cylindrical bristled panicle emerges loaded with pollen.',
        descriptionHindi: 'तना चीरकर लंबा सिट्टा बाहर आता है और परागण होता है।',
        criticalAction: 'Protect from Downy Mildew (हरित बाली रोग). Ensure soil moisture.',
        criticalActionHindi: 'जोगिया/हरित बाली रोग से रक्षा करें। सिट्टा निकलते समय नमी बनाए रखें।',
        icon: LucideIcons.flower_2,
      ),
      const CropStageTimeline(
        stageName: 'Maturity & Harvesting',
        stageNameHindi: 'दाना पकना व सिट्टे की कटाई',
        daysAfterSowing: '75 – 90 DAS',
        description: 'Earheads turn greyish brown with hard pearl-like grains.',
        descriptionHindi: 'सिट्टे सूखकर कड़े हो जाते हैं और दाने मोतियों जैसे चमकते हैं।',
        criticalAction: 'Cut earheads with sickle. Dry on threshing floor to 12% moisture.',
        criticalActionHindi: 'सिट्टों को दरांती से काटकर खलिहान में अच्छी तरह सुखाएं और गहाई करें।',
        icon: LucideIcons.check_check,
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

  static const Map<String, String> _cropHindiNames = {
    'Wheat': 'गेहूं',
    'Paddy': 'धान',
    'Mustard': 'सरसों',
    'Chickpea': 'चना',
    'Maize': 'मक्का',
    'Potato': 'आलू',
    'Tomato': 'टमाटर',
    'Cotton': 'कपास',
    'Sugarcane': 'गन्ना',
    'Soyabean': 'सोयाबीन',
    'Onion': 'प्याज',
    'Bajra': 'बाजरा',
  };

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual Crop Calendar Roadmap Hero Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 135,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15803D).withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/crop_calendar_hero.png',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.78),
                            Colors.black.withValues(alpha: 0.38),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lang.isHindi ? 'फसल विकास चक्र' : 'Crop Growth Timeline',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lang.isHindi
                                ? 'बुवाई से कटाई तक का रोडमैप'
                                : 'Sowing to Harvest Roadmap',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            lang.isHindi
                                ? 'अंकुरण • कल्ले फूटना • फूल • दाना भराव • कटाई'
                                : 'Sprouting • Tillering • Flowering • Milking • Harvest',
                            style: const TextStyle(
                              color: Color(0xFFDCFCE7),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Smooth Horizontal Crop Switcher Pills (12 Crops)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _cropTimelines.keys.map((cropKey) {
                  final hindi = _cropHindiNames[cropKey] ?? cropKey;
                  final label = lang.isHindi ? '$hindi ($cropKey)' : cropKey;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _buildCropPill(cropKey, label),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Sowing Date & Age Cockpit (Natural, Borderless Card)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 0.6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x04000000),
                    blurRadius: 8,
                    offset: Offset(0, 1),
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
                        lang.isHindi ? 'बुवाई की तिथि' : 'Sowing Date',
                        style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 14, color: AppColors.primary),
                          const SizedBox(width: 5),
                          Text(
                            '${_sowingDate.day}/${_sowingDate.month}/${_sowingDate.year}',
                            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 14,
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
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBBF7D0), width: 0.6),
                        ),
                        child: Text(
                          lang.isHindi ? 'आयु: $_currentDas दिन (DAS)' : 'Age: $_currentDas Days',
                          style: AppTypography.bodySmall().copyWith(
                            color: const Color(0xFF15803D),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: _pickSowingDate,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.6),
                          ),
                          child: Text(
                            lang.isHindi ? 'बदलें' : 'Change',
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Header Ribbon
            Row(
              children: [
                const Icon(LucideIcons.git_commit_vertical, size: 14, color: Color(0xFF15803D)),
                const SizedBox(width: 6),
                Text(
                  lang.isHindi
                      ? 'ICAR प्रामाणिक फसल विकास चक्र (Stages Timeline)'
                      : 'ICAR Package of Practices Timeline',
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF166534),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Connected Vertical Timeline Stages
            ...List.generate(stages.length, (idx) {
              final stage = stages[idx];
              final isLast = idx == stages.length - 1;
              return _buildTimelineItem(context, stage, isLast);
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCropPill(String cropKey, String label) {
    final isSelected = _selectedCrop == cropKey;
    return InkWell(
      onTap: () => setState(() => _selectedCrop = cropKey),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF15803D) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF15803D).withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall().copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 11.5,
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
          // Slender, Natural Left Timeline Spine & Node
          SizedBox(
            width: 22,
            child: Column(
              children: [
                // Minimal Node
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF15803D)
                        : (isPassed ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFF15803D)
                          : (isPassed ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1)),
                      width: isCurrent ? 1.8 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isPassed
                          ? LucideIcons.check
                          : (isCurrent ? LucideIcons.dot : stage.icon),
                      size: isPassed ? 11 : (isCurrent ? 16 : 10),
                      color: isCurrent
                          ? Colors.white
                          : (isPassed ? const Color(0xFF15803D) : const Color(0xFF94A3B8)),
                    ),
                  ),
                ),
                // Spine line (Slender 1px line)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.2,
                      color: isPassed ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right Stage Content Card (Natural, Compact, Borderless Feel)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                  width: isCurrent ? 1.0 : 0.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCurrent
                        ? const Color(0xFF15803D).withValues(alpha: 0.05)
                        : const Color(0x03000000),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
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
                            fontSize: 14,
                            color: isCurrent ? const Color(0xFF14532D) : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFF15803D)
                              : (isPassed ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF15803D)
                                : (isPassed ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0)),
                            width: 0.6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isCurrent)
                              const Padding(
                                padding: EdgeInsets.only(right: 3),
                                child: Icon(LucideIcons.radio, size: 9, color: Colors.white),
                              )
                            else if (isPassed)
                              const Padding(
                                padding: EdgeInsets.only(right: 3),
                                child: Icon(LucideIcons.check, size: 9, color: Color(0xFF15803D)),
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
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar_days, size: 11, color: Color(0xFF15803D)),
                      const SizedBox(width: 4),
                      Text(
                        '${targetStartDate.day}/${targetStartDate.month} – ${targetEndDate.day}/${targetEndDate.month}',
                        style: AppTypography.bodySmall().copyWith(
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.w600,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    desc,
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.35,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  // Natural Soft Biophilic ICAR Action Pill (No Heavy Slabs/Lines)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A), width: 0.6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.info, size: 13, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            action,
                            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                              fontSize: 11,
                              color: const Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                              height: 1.35,
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
