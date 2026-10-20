import 'package:flutter_lucide/flutter_lucide.dart';
import '../models/crop_profile_model.dart';
import '../models/weather_alert_model.dart';
import '../models/weather_model.dart';

class WeatherAlertService {
  /// Generates dynamic, ICAR Agromet & IMD-aligned early warnings based on real weather data
  List<WeatherAlertModel> generateAlerts(
    WeatherModel weather, {
    List<CropProfileModel>? farmerCrops,
  }) {
    final List<WeatherAlertModel> alerts = [];
    final now = DateTime.now();

    final rainProb = weather.rainProbability;
    final temp = weather.temperature;
    final humidity = weather.humidity;
    final wind = weather.windSpeed;
    final condLower = weather.condition.toLowerCase();

    // Check forecast maximums/minimums
    final maxForecastRain = weather.weeklyForecast.isNotEmpty
        ? weather.weeklyForecast.map((f) => f.rainChance).reduce((a, b) => a > b ? a : b)
        : rainProb;
    final minForecastTemp = weather.weeklyForecast.isNotEmpty
        ? weather.weeklyForecast.map((f) => f.minTemp).reduce((a, b) => a < b ? a : b)
        : temp;
    final maxForecastTemp = weather.weeklyForecast.isNotEmpty
        ? weather.weeklyForecast.map((f) => f.maxTemp).reduce((a, b) => a > b ? a : b)
        : temp;

    final hasHailInForecast = weather.weeklyForecast.any(
      (f) => f.condition.toLowerCase().contains('hail') || f.condition.toLowerCase().contains('thunder'),
    );
    final isSquallRisk = wind >= 28.0 && rainProb >= 40;

    // 1. Hailstorm / Severe Thunderstorm (Highest Risk)
    if (condLower.contains('hail') || condLower.contains('thunder') || hasHailInForecast || isSquallRisk) {
      alerts.add(
        WeatherAlertModel(
          id: 'alert_hail_${now.millisecondsSinceEpoch}',
          titleHindi: 'ओलावृष्टि व आंधी-तूफान रेड अलर्ट',
          titleEnglish: 'Hailstorm & Severe Thunderstorm Alert',
          severity: AlertSeverity.critical,
          category: AlertCategory.weather,
          conditionSummaryHindi: 'गरज-चमक के साथ ओलावृष्टि और तेज आंधी चलने की उच्च संभावना है।',
          conditionSummaryEnglish: 'High probability of localized hailstorm and convective squalls.',
          affectedCropsHindi: ['सभी खड़ी फसलें', 'आम/लीची के बगीचे', 'सब्जियों की नर्सरी'],
          affectedCropsEnglish: ['All Standing Crops', 'Fruit Orchards', 'Vegetable Nurseries'],
          dosHindi: [
            'कटी हुई फसल व थ्रेसिंग किए हुए अनाज को तुरंत सुरक्षित पक्के शेड या गोदाम में रखें',
            'सब्जी की पौधशाला (नर्सरी) को एग्री-नेट या तिरपाल से ढककर सुरक्षित करें',
            'मवेशियों को खुले पेड़ों के नीचे न बांधकर पक्के बाड़े में रखें',
          ],
          dosEnglish: [
            'Move harvested produce and threshed grains to covered storage immediately',
            'Cover nursery beds with shade netting or protective plastic sheets',
            'Keep farm animals in sturdy shelters away from trees or metallic poles',
          ],
          dontsHindi: [
            'बिजली चमकने के समय खुले खेत में लोहे के औजार लेकर न खड़े हों',
            'ऊंचे पेड़ों के नीचे शरण बिल्कुल न लें',
          ],
          dontsEnglish: [
            'Do not remain in open fields holding metal implements during lightning',
            'Never take shelter under tall solitary trees',
          ],
          audioAdvisoryHindi:
              'ओलावृष्टि व आंधी की गंभीर चेतावनी! कटी हुई फसल व अनाज को तुरंत सुरक्षित स्थान पर रखें और नर्सरी को ढकें।',
          audioAdvisoryEnglish:
              'Hailstorm warning! Move harvested crops to indoor shelter and cover open nurseries immediately.',
          icon: LucideIcons.cloud_lightning,
          issuedAt: now,
        ),
      );
    }

    // 2. Heavy Rain / Waterlogging Warning
    if (rainProb >= 50 || maxForecastRain >= 60 || condLower.contains('rain') || condLower.contains('shower')) {
      final isCriticalRain = rainProb >= 75 || maxForecastRain >= 80;
      alerts.add(
        WeatherAlertModel(
          id: 'alert_rain_${now.millisecondsSinceEpoch}',
          titleHindi: isCriticalRain ? 'भारी बारिश व जलभराव चेतावनी' : 'वर्षा व नमी सतर्कता अलर्ट',
          titleEnglish: isCriticalRain ? 'Heavy Rainfall & Waterlogging Alert' : 'Rain & Moisture Advisory',
          severity: isCriticalRain ? AlertSeverity.critical : AlertSeverity.warning,
          category: AlertCategory.weather,
          conditionSummaryHindi: 'अगले 24-48 घंटों में $rainProb% से $maxForecastRain% तक वर्षा की संभावना है।',
          conditionSummaryEnglish: 'Forecast indicates $rainProb% to $maxForecastRain% probability of rain.',
          affectedCropsHindi: ['गेहूं', 'सरसों', 'आलू', 'चना', 'सब्जियां'],
          affectedCropsEnglish: ['Wheat', 'Mustard', 'Potato', 'Gram', 'Vegetables'],
          dosHindi: [
            'खेतों की मेड़ों पर जल निकासी (Drainage channels) की नालियां तुरंत खोलें',
            'सब्जियों व आलू के खेत में जल जमाव न होने दें ताकि जड़ सड़न से बचाव हो',
            'कटाई की गई उपज को तिरपाल से सुरक्षित ढकें',
          ],
          dosEnglish: [
            'Ensure drainage channels are unclogged to avoid standing water',
            'Prevent waterlogging in potato and vegetable plots to stop root rot',
            'Secure harvested produce with waterproof tarpaulins',
          ],
          dontsHindi: [
            'यूरिया या अन्य किसी भी उर्वरक का टॉप-ड्रेसिंग छिड़काव तुरंत रोकें',
            'कीटनाशक व फफूंदनाशक का स्प्रे न करें (दवा बारिश में धुल जाएगी)',
            'खेत में सिंचाई बिल्कुल बंद रखें',
          ],
          dontsEnglish: [
            'Postpone urea top-dressing and soluble fertilizer applications',
            'Do not spray pesticides or fungicides as rain will wash away chemicals',
            'Halt all routine field irrigations',
          ],
          audioAdvisoryHindi:
              'बारिश का अलर्ट! आपके क्षेत्र में $rainProb प्रतिशत बारिश की संभावना है। यूरिया व कीटनाशक का छिड़काव तुरंत रोकें और खेत में जल निकासी खुली रखें।',
          audioAdvisoryEnglish:
              'Rain alert! Postpone fertilizer top dressing and pesticide sprays. Keep drainage channels open.',
          icon: LucideIcons.cloud_rain,
          issuedAt: now,
        ),
      );
    }

    // 3. Frost / Cold Wave Alert (पाले की चेतावनी)
    if (minForecastTemp <= 6.0 || temp <= 6.0) {
      final isSevereFrost = minForecastTemp <= 3.5;
      alerts.add(
        WeatherAlertModel(
          id: 'alert_frost_${now.millisecondsSinceEpoch}',
          titleHindi: isSevereFrost ? 'गंभीर शीतलहर व पाला रेड अलर्ट' : 'शीतलहर व पाला सतर्कता अलर्ट',
          titleEnglish: isSevereFrost ? 'Severe Frost & Cold Wave Red Alert' : 'Frost Warning Alert',
          severity: isSevereFrost ? AlertSeverity.critical : AlertSeverity.warning,
          category: AlertCategory.weather,
          conditionSummaryHindi:
              'न्यूनतम तापमान ${minForecastTemp.toStringAsFixed(1)}°C तक गिरने से पाला पड़ने की गंभीर आशंका है।',
          conditionSummaryEnglish:
              'Minimum temperature expected to dip to ${minForecastTemp.toStringAsFixed(1)}°C with high frost risk.',
          affectedCropsHindi: ['सरसों', 'आलू', 'चना', 'मटर', 'टमाटर'],
          affectedCropsEnglish: ['Mustard', 'Potato', 'Gram', 'Peas', 'Tomato'],
          dosHindi: [
            'शाम के समय खेत में हल्की सिंचाई करें ताकि मिट्टी का तापमान स्थिर रहे',
            'खेत की उत्तर-पश्चिम दिशा में शाम को सूखा कूड़ा-करकट जलाकर धुआं करें',
            'सल्फर 80% WDG (2 ग्राम प्रति लीटर पानी) का छिड़काव करें जो पाले से सुरक्षा देता है',
          ],
          dosEnglish: [
            'Apply light evening irrigation to maintain soil thermal buffering',
            'Create gentle smoke smudge along field borders upwind in evening',
            'Spray soluble Sulfur 80% WDG at 2g per liter for thermal cold resistance',
          ],
          dontsHindi: [
            'पाले की संभावना के समय खेत को सूखा न छोड़ें',
            'अत्यधिक रासायनिक नाइट्रोजन का प्रयोग न करें',
          ],
          dontsEnglish: [
            'Do not leave vulnerable fields completely dry during cold wave nights',
            'Avoid heavy synthetic nitrogen fertilizer applications',
          ],
          audioAdvisoryHindi:
              'पाले की चेतावनी! तापमान ${minForecastTemp.toStringAsFixed(1)} डिग्री तक गिरने का अनुमान है। शाम को हल्की सिंचाई करें ताकि सरसों व आलू की फसल सुरक्षित रहे।',
          audioAdvisoryEnglish:
              'Frost warning! Apply light evening irrigation to protect mustard and potato from cold damage.',
          icon: LucideIcons.snowflake,
          issuedAt: now,
        ),
      );
    }

    // 4. Heat Wave / Terminal Heat Stress (लू व अत्यधिक गर्मी)
    if (temp >= 38.0 || maxForecastTemp >= 38.0) {
      final isExtremeHeat = temp >= 41.0 || maxForecastTemp >= 41.0;
      alerts.add(
        WeatherAlertModel(
          id: 'alert_heat_${now.millisecondsSinceEpoch}',
          titleHindi: isExtremeHeat ? 'अत्यधिक लू (Heat Wave) रेड अलर्ट' : 'लू व शुष्क हवा सतर्कता',
          titleEnglish: isExtremeHeat ? 'Severe Heat Wave Alert' : 'Heat Stress Advisory',
          severity: isExtremeHeat ? AlertSeverity.critical : AlertSeverity.warning,
          category: AlertCategory.weather,
          conditionSummaryHindi:
              'अधिकतम तापमान ${maxForecastTemp.toStringAsFixed(1)}°C तक पहुंचने से फसलों में नमी का तेजी से ह्रास होगा।',
          conditionSummaryEnglish:
              'Max temperature reaching ${maxForecastTemp.toStringAsFixed(1)}°C with desiccating dry winds.',
          affectedCropsHindi: ['गेहूं (दाना भराव)', 'जायद मक्का', 'मूंग/उड़द', 'सब्जियां'],
          affectedCropsEnglish: ['Wheat (Grain Filling)', 'Zaid Maize', 'Moong', 'Summer Vegetables'],
          dosHindi: [
            'खेतों में हल्की व बार-बार सिंचाई करें ताकि दाना सिकुड़ने से बचे',
            'फसल पर 2% पोटेशियम नाइट्रेट (13-0-45) का छिड़काव करें ताकि पौधों में ताप सहनशीलता बढ़े',
            'सब्जियों में मल्चिंग (पुआल की परत) बिछाएं ताकि नमी सुरक्षित रहे',
          ],
          dosEnglish: [
            'Provide frequent light irrigations to avoid grain shriveling in wheat',
            'Foliar spray of 2% Potassium Nitrate (13-0-45) to enhance thermal stress resistance',
            'Apply straw mulching in vegetable beds to conserve vital root moisture',
          ],
          dontsHindi: [
            'तेज पछुआ हवा के समय दिन में सिंचाई न करें (फसल गिर सकती है)',
            'दोपहर की तीखी धूप में कीटनाशक छिड़काव से बचें',
          ],
          dontsEnglish: [
            'Avoid flood irrigation during gusty winds to prevent crop lodging',
            'Never spray chemical solutions under scorching midday sun',
          ],
          audioAdvisoryHindi:
              'लू व गर्मी का अलर्ट! तापमान ${maxForecastTemp.toStringAsFixed(1)} डिग्री से अधिक है। गेहूं व जायद फसलों में हल्की सिंचाई कर नमी बनाए रखें।',
          audioAdvisoryEnglish:
              'Heat wave alert! Keep soil moist with frequent light irrigation to prevent grain shriveling.',
          icon: LucideIcons.flame,
          issuedAt: now,
        ),
      );
    }

    // 5. Pest & Disease Alert: Late Blight in Potato & Tomato (पिछेती झुलसा)
    // Favorable conditions: RH >= 80%, Temp between 10°C and 22°C, cloudy/foggy
    if (humidity >= 80 && temp >= 10.0 && temp <= 22.0) {
      alerts.add(
        WeatherAlertModel(
          id: 'alert_blight_${now.millisecondsSinceEpoch}',
          titleHindi: 'आलू-टमाटर पिछेती झुलसा (Late Blight) फंगस अलर्ट',
          titleEnglish: 'Late Blight Fungal Forewarning (Potato/Tomato)',
          severity: AlertSeverity.warning,
          category: AlertCategory.pestDisease,
          conditionSummaryHindi:
              'उच्च आर्द्रता ($humidity%) और ठंड (${temp.toStringAsFixed(1)}°C) फाइटोफ्थोरा फंगस के लिए अत्यंत अनुकूल है।',
          conditionSummaryEnglish:
              'High relative humidity ($humidity%) and cool temperature (${temp.toStringAsFixed(1)}°C) favor Phytophthora infestans.',
          affectedCropsHindi: ['आलू', 'टमाटर'],
          affectedCropsEnglish: ['Potato', 'Tomato'],
          dosHindi: [
            'रोग के लक्षण दिखने से पहले मैंकोजेब (Mancozeb 75% WP) 2.5 ग्राम प्रति लीटर पानी में घोलकर सुरक्षात्मक स्प्रे करें',
            'यदि पत्तों पर काले-भूरे पानीदार धब्बे दिखें, तो साइमोक्सानिल + मैंकोजेब (3 ग्राम/लीटर) या मेटालैक्सिल-एम का छिड़काव करें',
            'खेत का प्रतिदिन सुबह निरीक्षण करें',
          ],
          dosEnglish: [
            'Apply prophylactic spray of Mancozeb 75% WP at 2.5g per liter water',
            'If water-soaked lesions appear on leaves, switch to Cymoxanil + Mancozeb at 3g/L',
            'Conduct daily morning field scouting of lower leaves',
          ],
          dontsHindi: [
            'खेत में पानी जमा न होने दें और न ही रात में भारी सिंचाई करें',
            'गीले पौधों के बीच कार्य न करें ताकि फफूंद के बीजाणु न फैलें',
          ],
          dontsEnglish: [
            'Avoid overnight standing water and excessive evening flood irrigation',
            'Do not walk through wet foliage to avoid spreading fungal spores',
          ],
          audioAdvisoryHindi:
              'सावधानी! नम और ठंडे मौसम के कारण आलू और टमाटर में झुलसा रोग का खतरा है। तुरंत मैंकोजेब का सुरक्षात्मक छिड़काव करें।',
          audioAdvisoryEnglish:
              'Disease alert! Favorable weather for late blight in potato and tomato. Apply preventive Mancozeb spray.',
          icon: LucideIcons.bug,
          issuedAt: now,
        ),
      );
    }

    // 6. Pest & Disease Alert: Mustard Aphid (माहू / चेपा)
    // Favorable conditions: Temp 10°C to 21°C, cloudy skies, moderate humidity >= 65%
    if (temp >= 10.0 && temp <= 22.0 && humidity >= 65 && (condLower.contains('cloud') || condLower.contains('overcast'))) {
      alerts.add(
        WeatherAlertModel(
          id: 'alert_aphid_${now.millisecondsSinceEpoch}',
          titleHindi: 'सरसों में माहू (चेपा / Aphid) कीट चेतावनी',
          titleEnglish: 'Mustard Aphid Infestation Risk',
          severity: AlertSeverity.warning,
          category: AlertCategory.pestDisease,
          conditionSummaryHindi: 'बादल छाए रहने और मध्यम तापमान के कारण सरसों की टहनियों पर माहू कीट तेजी से पनप सकते हैं।',
          conditionSummaryEnglish: 'Overcast skies and moderate temperatures create high risk for Lipaphis erysimi aphids.',
          affectedCropsHindi: ['सरसों', 'तोरिया', 'राई'],
          affectedCropsEnglish: ['Mustard', 'Toria', 'Rapeseed'],
          dosHindi: [
            'खेत में 4 से 6 पीले चिपचिपे ट्रैप (Yellow Sticky Traps) प्रति एकड़ लगाएं',
            'प्रारंभिक प्रकोप दिखने पर 5% नीम का तेल (Neem Oil 1500 ppm) 5 मिली प्रति लीटर पानी में मिलाकर छिड़कें',
            'आर्थिक क्षति स्तर (ETL - प्रति पौधे 25-30 कीट) पार होने पर इमिडाक्लोप्रिड 17.8% SL (0.5 मिली/लीटर) का छिड़काव दोपहर बाद करें',
          ],
          dosEnglish: [
            'Install 4-6 Yellow Sticky Traps per acre across field boundaries',
            'Spray 5% Neem seed kernel extract or Neem oil 1500 ppm (5ml/L) at first notice',
            'If above economic threshold (25-30 aphids/shoot), spray Imidacloprid 17.8% SL (0.5ml/L) in afternoon',
          ],
          dontsHindi: [
            'सुबह के समय तेज रासायनिक कीटनाशक न छिड़कें ताकि मित्र कीट (मधुमक्खी) सुरक्षित रहें',
            'अत्यधिक यूरिया खाद न दें जिससे पौधे नरम होकर कीटों को आमंत्रित करें',
          ],
          dontsEnglish: [
            'Never spray toxic insecticides during morning hours to protect pollinator honeybees',
            'Avoid excessive nitrogen fertilizer which causes succulent tender vegetative growth',
          ],
          audioAdvisoryHindi:
              'सरसों में माहू कीट का अलर्ट! बादल छाए रहने से चेपा बढ़ सकता है। खेत में पीले ट्रैप लगाएं और नीम तेल का छिड़काव करें।',
          audioAdvisoryEnglish:
              'Mustard aphid warning! Overcast weather favors pest multiplication. Install yellow sticky traps and spray neem oil.',
          icon: LucideIcons.bug,
          issuedAt: now,
        ),
      );
    }

    // 7. Pest & Disease Alert: Wheat Yellow Rust (पीला रतुआ)
    // Favorable conditions: Cool moist weather (8°C - 17°C, RH >= 75%)
    if (temp >= 8.0 && temp <= 18.0 && humidity >= 75) {
      alerts.add(
        WeatherAlertModel(
          id: 'alert_yellow_rust_${now.millisecondsSinceEpoch}',
          titleHindi: 'गेहूं में पीला रतुआ (Yellow Rust) फंगल चेतावनी',
          titleEnglish: 'Wheat Stripe / Yellow Rust Precaution',
          severity: AlertSeverity.info,
          category: AlertCategory.pestDisease,
          conditionSummaryHindi: 'ठंडी हवा व सुबह की भारी ओस के कारण गेहूं की पत्तियों पर पीला रतुआ फंगस लग सकती है।',
          conditionSummaryEnglish: 'Cool moist nights and morning dew create conducive conditions for Puccinia striiformis.',
          affectedCropsHindi: ['गेहूं'],
          affectedCropsEnglish: ['Wheat'],
          dosHindi: [
            'खेत में सुबह घूमकर पत्तियों पर पीले पाउडर की धारियों की नियमित जांच करें',
            'लक्षण दिखते ही प्रोपिकोनाजोल 25% EC (Tilt) 1 मिली प्रति लीटर पानी की दर से छिड़कें',
          ],
          dosEnglish: [
            'Scout wheat fields regularly for yellow stripe powdery pustules on leaves',
            'On spotting initial symptoms, spray Propiconazole 25% EC at 1ml per liter water',
          ],
          dontsHindi: [
            'रोगग्रस्त पत्तियों को छूने के बाद हाथ या कपड़े बिना साफ किए स्वस्थ खेत में न जाएं',
          ],
          dontsEnglish: [
            'Avoid moving through healthy fields after inspecting infected plots without sanitizing boots',
          ],
          audioAdvisoryHindi:
              'गेहूं किसान ध्यान दें! सुबह की ओस व ठंड के कारण पीला रतुआ की आशंका है। पत्तियों की नियमित जांच करें।',
          audioAdvisoryEnglish:
              'Wheat farmers alert! Morning dew and cool air increase yellow rust risk. Inspect your fields regularly.',
          icon: LucideIcons.shield_alert,
          issuedAt: now,
        ),
      );
    }

    // 8. If NO critical or warning alerts, provide a Safe Agricultural Window (मौसम अनुकूल)
    if (alerts.isEmpty || alerts.every((a) => a.severity == AlertSeverity.info)) {
      alerts.insert(
        0,
        WeatherAlertModel(
          id: 'alert_safe_${now.millisecondsSinceEpoch}',
          titleHindi: 'मौसम अनुकूल: कृषि कार्यों हेतु उत्तम समय',
          titleEnglish: 'Favorable Weather Window for Farm Operations',
          severity: AlertSeverity.safe,
          category: AlertCategory.weather,
          conditionSummaryHindi:
              'आसमान साफ है, तापमान ${temp.toStringAsFixed(1)}°C व बारिश की संभावना केवल $rainProb% है। कोई प्राकृतिक आपदा की आशंका नहीं है।',
          conditionSummaryEnglish:
              'Clear conditions with temperature ${temp.toStringAsFixed(1)}°C and rain chance only $rainProb%. Safe agronomic window.',
          affectedCropsHindi: ['सभी फसलें'],
          affectedCropsEnglish: ['All Crops'],
          dosHindi: [
            'रबी/खरीफ फसलों की बुवाई, खेत की तैयारी और मेड़बंदी के कार्य संपन्न करें',
            'सूक्ष्म पोषक तत्वों (जिंक, बोरॉन) और आवश्यक कीटनाशकों का छिड़काव सुरक्षित रूप से पूरा करें',
            'नियमित सिंचाई का चक्र पूरा करें',
          ],
          dosEnglish: [
            'Ideal window for sowing operations, land tillage and bund preparation',
            'Safely apply micronutrient sprays (Zinc, Boron) and scheduled crop protection',
            'Proceed with scheduled irrigation turns',
          ],
          dontsHindi: [
            'सिंचाई में पानी का अपव्यय न करें',
          ],
          dontsEnglish: [
            'Avoid excessive flood irrigation to conserve water table',
          ],
          audioAdvisoryHindi:
              'मौसम पूरी तरह अनुकूल है। बारिश या पाले की कोई आशंका नहीं है। बुवाई, खाद व छिड़काव के सभी कार्य निश्चिंत होकर संपन्न करें।',
          audioAdvisoryEnglish:
              'Weather is favorable with low rain risk. Safe window for intercultural operations, sowing and fertilizer application.',
          icon: LucideIcons.sprout,
          issuedAt: now,
        ),
      );
    }

    // Priority Sort: Critical -> Warning -> Info -> Safe
    alerts.sort((a, b) {
      final order = {
        AlertSeverity.critical: 0,
        AlertSeverity.warning: 1,
        AlertSeverity.info: 2,
        AlertSeverity.safe: 3,
      };

      // Prioritize alerts affecting farmer's crops if provided
      if (farmerCrops != null && farmerCrops.isNotEmpty) {
        final aMatches = isRelevantToFarmer(a, farmerCrops);
        final bMatches = isRelevantToFarmer(b, farmerCrops);
        if (aMatches && !bMatches) return -1;
        if (!aMatches && bMatches) return 1;
      }

      return (order[a.severity] ?? 4).compareTo(order[b.severity] ?? 4);
    });

    return alerts;
  }

  /// Checks if an alert specifically targets any crop registered in farmer's Crop Profile
  bool isRelevantToFarmer(WeatherAlertModel alert, List<CropProfileModel> farmerCrops) {
    if (farmerCrops.isEmpty) return false;
    for (final crop in farmerCrops) {
      final nameEn = crop.cropName.toLowerCase();
      final nameHi = crop.cropNameHindi.toLowerCase();

      final matchesEn = alert.affectedCropsEnglish.any((c) => c.toLowerCase().contains(nameEn) || nameEn.contains(c.toLowerCase()));
      final matchesHi = alert.affectedCropsHindi.any((c) => c.toLowerCase().contains(nameHi) || nameHi.contains(c.toLowerCase()));

      if (matchesEn || matchesHi) return true;
    }
    return false;
  }
}
