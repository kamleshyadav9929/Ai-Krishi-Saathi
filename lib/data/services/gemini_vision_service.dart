import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crop_disease_model.dart';
import '../../core/constants/app_constants.dart';

class GeminiVisionService {
  final String apiKey;

  GeminiVisionService({this.apiKey = AppConstants.geminiApiKey});

  // Candidate models in priority order for multimodal vision inference
  static const List<String> _visionModels = [
    'gemini-3-flash-preview',
    'gemini-3.8-flash',
    'gemini-flash-latest',
  ];

  /// Analyzes a crop or leaf image and returns structured diagnosis with strict domain guardrails
  Future<CropDiseaseModel> diagnoseLeafImage({
    required String imageBase64,
    required String mimeType,
  }) async {
    const prompt = '''
You are a senior plant pathologist and agricultural scientist at ICAR (Indian Council of Agricultural Research).
Inspect the provided image carefully and thoroughly.

==================== STEP 1: VALIDITY & OBJECT IDENTIFICATION ====================
Determine if this image shows a genuine agricultural crop, plant foliage, farm leaf, panicle, fruit, stem, or field seedling.

IF the image is NOT an agricultural plant or crop (e.g. mobile charger, adapter, cable, smartphone, water bottle, footwear, utensil, vehicle, furniture, clothes, indoor wall, human face, animal, or random household object):
Return strictly valid JSON:
{
  "isPlant": false,
  "detectedObject": "Exact name of detected object (e.g. 'Mobile Charger / Adapter', 'Water Bottle', 'Leather Shoe', 'Smartphone', etc.)",
  "cropType": "Non-Crop Object / अमान्य वस्तु",
  "diseaseName": "Non-Agricultural Item Detected",
  "diseaseNameHindi": "यह किसी फसल या पौधे की तस्वीर नहीं है",
  "confidence": 0.99,
  "symptoms": ["The uploaded photograph does not show any agricultural crop or plant leaf."],
  "symptomsHindi": ["अपलोड की गई फोटो किसी फसल या पौधे की नहीं है। यह गैर-कृषि वस्तु है।"],
  "organicTreatments": ["Please take a clear photo of an actual crop leaf, panicle, stem, or farm plant."],
  "organicTreatmentsHindi": ["कृपया फसल की पत्ती, तने अथवा बाली की साफ़ फोटो खींचकर पुनः प्रयास करें।"],
  "safetyWarning": "Crop Doctor requires clear imagery of farm crops or plants.",
  "safetyWarningHindi": "रोग जांच के लिए कृपया केवल वास्तविक फसल या पौधे की फोटो लें।"
}

==================== STEP 2: CROP & PATHOLOGY DIAGNOSIS ====================
If the image IS a plant or farm crop:
1. Accurately identify the specific crop (e.g., Pearl Millet / Bajra [बाजरा], Wheat [गेहूं], Paddy / Rice [धान], Mustard [सरसों], Maize [मक्का], Cotton [कपास], Tomato [टमाटर], Potato [आलू], Chili [मिर्च], Gram / Chana [चना], Onion [प्याज], Sugarcane [गन्ना], etc.).
2. Examine the health state:
   - If the crop/leaf is HEALTHY with no infection:
     Set "diseaseName": "Healthy Crop (No Disease Detected)", "diseaseNameHindi": "स्वस्थ फसल (कोई रोग नहीं मिला)", and provide good agronomic care tips.
   - If INFECTED, identify the exact disease/pest using official ICAR terminology:
     * For Bajra (Pearl Millet / बाजरा): Check for Downy Mildew / Green Ear Disease (हरित बाली रोग / जोगिया / Sclerospora graminicola), Ergot (अरगट / चेपा / Claviceps microcephala), Rust (गेरुआ / Puccinia substriata), Smut (कंगुआ), Blast (पत्ती का झुलसा), etc.
     * For Wheat (गेहूं): Yellow/Stripe Rust (पीला रतुआ), Brown Rust (भूरा रतुआ), Loose Smut, Karnal Bunt, Powdery Mildew, etc.
     * For Paddy (धान): Bacterial Leaf Blight, Blast, Brown Spot, Sheath Blight, etc.
     * For Mustard (सरसों): White Rust (सफेद रतुआ), Alternaria Blight, Downy Mildew, etc.
     * For other crops: Exact fungal, bacterial, viral, or pest damage.

Return strictly valid JSON in this format:
{
  "isPlant": true,
  "detectedObject": "Specific crop and plant part (e.g. 'Bajra Leaf / Panicle', 'Tomato Foliage', etc.)",
  "cropType": "Crop name in English and Hindi (e.g. 'Bajra / Pearl Millet (बाजरा)')",
  "diseaseName": "Specific disease name or 'Healthy Crop'",
  "diseaseNameHindi": "रोग का सटीक नाम हिंदी में या 'स्वस्थ फसल'",
  "confidence": 0.95,
  "symptoms": ["Detailed symptom 1 in English", "Detailed symptom 2 in English"],
  "symptomsHindi": ["लक्षण 1 हिंदी में विस्तार से", "लक्षण 2 हिंदी में"],
  "organicTreatments": ["ICAR approved treatment 1 (organic/chemical with exact dosages)", "Treatment 2"],
  "organicTreatmentsHindi": ["उपचार 1 हिंदी में (सटीक मात्रा एवं छिड़काव विधि)", "उपचार 2 हिंदी में"],
  "safetyWarning": "Crucial safety note or agronomic caution",
  "safetyWarningHindi": "महत्वपूर्ण सावधानी सलाह"
}

Output strictly valid JSON. Do not include markdown code block backticks.
''';

    // Try primary and fallback models
    for (final modelName in _visionModels) {
      try {
        final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {"text": prompt},
                  {
                    "inline_data": {
                      "mime_type": mimeType,
                      "data": imageBase64,
                    }
                  }
                ]
              }
            ],
            "generationConfig": {
              "response_mime_type": "application/json",
              "temperature": 0.1
            }
          }),
        ).timeout(const Duration(seconds: 14));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final textResponse =
              data['candidates']?[0]?['content']?['parts']?[0]?['text'];
          if (textResponse != null) {
            String cleanJson = textResponse.trim();
            if (cleanJson.startsWith('```json')) {
              cleanJson = cleanJson.substring(7);
            }
            if (cleanJson.startsWith('```')) {
              cleanJson = cleanJson.substring(3);
            }
            if (cleanJson.endsWith('```')) {
              cleanJson = cleanJson.substring(0, cleanJson.length - 3);
            }
            final parsed = jsonDecode(cleanJson.trim());
            return CropDiseaseModel.fromJson(parsed);
          }
        }
      } catch (_) {
        // Try next model if timeout or error occurs
        continue;
      }
    }

    // Honest fallback error model — NEVER hallucinate a fake disease on an unknown image or failed connection
    return CropDiseaseModel(
      isPlant: false,
      detectedObject: 'नेटवर्क / AI सर्वर अनुपलब्ध',
      diseaseName: 'Analysis Incomplete',
      diseaseNameHindi: 'AI सर्वर से संपर्क नहीं हो सका',
      cropType: 'कनेक्शन त्रुटि',
      confidence: 0.0,
      symptoms: [
        'Could not connect to Gemini Vision AI service. Please check your internet connection and try again.'
      ],
      symptomsHindi: [
        'इंटरनेट धीमा होने अथवा AI सर्वर पर लोड होने के कारण फोटो का विश्लेषण नहीं हो सका।',
        'कृपया अपने मोबाइल का डेटा या वाई-फाई जांचें और दोबारा फोटो खींचें।'
      ],
      organicTreatments: [
        'Ensure mobile internet is active with good 4G/5G signal.'
      ],
      organicTreatmentsHindi: [
        'कृपया बेहतर नेटवर्क क्षेत्र में जाकर दोबारा प्रयास करें।'
      ],
      safetyWarning: 'No diagnosis was generated because server was unreachable. Please retry.',
      safetyWarningHindi: 'कोई गलत सलाह न मिले इसलिए रोग की जांच नहीं की गई। कृपया इंटरनेट चालू होने पर दोबारा फोटो लें।',
      scannedAt: DateTime.now(),
    );
  }
}
