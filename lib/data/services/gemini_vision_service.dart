import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crop_disease_model.dart';
import '../../core/constants/app_constants.dart';

class GeminiVisionService {
  final String apiKey;

  GeminiVisionService({this.apiKey = AppConstants.geminiApiKey});

  /// Analyzes a crop or leaf image and returns structured diagnosis with strict domain guardrails
  Future<CropDiseaseModel> diagnoseLeafImage({
    required String imageBase64,
    required String mimeType,
  }) async {
    const prompt = '''
You are an expert Indian agricultural scientist and plant pathologist.
Carefully inspect this image.

STEP 1: Check whether this image is a genuine agricultural plant, crop, leaf, flower, or farm produce.
If this image is a NON-AGRICULTURAL object (such as a water bottle, thermos flask, utensil, vehicle, clothes, footwear, electronic gadget, furniture, human face, animal, room interior, or random product):
Return strictly valid JSON:
{
  "isPlant": false,
  "detectedObject": "Specific name of what is in the image (e.g. 'Milton Thermos Flask / Water Bottle', 'Shoe', 'Smartphone', etc.)",
  "cropType": "Not a Plant / अमान्य वस्तु",
  "diseaseName": "Non-Crop Object Detected",
  "diseaseNameHindi": "यह किसी फसल या पौधे की तस्वीर नहीं है",
  "confidence": 0.99,
  "symptoms": ["The uploaded photo shows a commercial/non-agricultural object and not a farm crop or plant leaf."],
  "symptomsHindi": ["कृपया किसी संक्रमित पत्ती, पौधे या फसल की साफ़ फोटो खींचकर दोबारा अपलोड करें।"],
  "organicTreatments": ["Please retake photo focusing on plant leaves, stems, or fruits."],
  "organicTreatmentsHindi": ["रोग पहचान के लिए केवल पौधे की पत्ती, फल या तने की साफ़ फोटो खींचें।"],
  "safetyWarning": "Agricultural diagnosis requires clear imagery of plants, leaves, or crops.",
  "safetyWarningHindi": "अमान्य फोटो: कृपया केवल पौधे, पत्ती अथवा फसल की स्पष्ट फोटो लें।"
}

STEP 2: If it IS a genuine plant or crop:
Examine whether it is healthy or infected. Return:
{
  "isPlant": true,
  "detectedObject": "Crop name and plant part (e.g. 'Tomato Leaf', 'Wheat Ear / Stem', etc.)",
  "diseaseName": "English name of disease or 'Healthy Crop'",
  "diseaseNameHindi": "रोग या कीट का हिंदी नाम या 'स्वस्थ फसल'",
  "cropType": "Identified Crop name",
  "confidence": 0.94,
  "symptoms": ["Symptom 1 in English", "Symptom 2"],
  "symptomsHindi": ["लक्षण 1 हिंदी में", "लक्षण 2"],
  "organicTreatments": ["Treatment 1", "Treatment 2"],
  "organicTreatmentsHindi": ["उपचार 1 हिंदी में", "उपचार 2"],
  "safetyWarning": "Caution advice: avoid dangerous pesticide overdosing",
  "safetyWarningHindi": "सावधानी सलाह: अनियंत्रित कीटनाशक का अत्यधिक छिड़काव न करें"
}
Output strictly valid JSON.
''';

    try {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/${AppConstants.geminiModel}:generateContent?key=$apiKey');

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
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final textResponse =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (textResponse != null) {
          final parsed = jsonDecode(textResponse);
          return CropDiseaseModel.fromJson(parsed);
        }
      }
    } catch (_) {}

    // Honest fallback error model — NEVER hallucinate a disease on an unknown image
    return CropDiseaseModel(
      isPlant: false,
      detectedObject: 'AI सर्वर त्रुटि',
      diseaseName: 'Analysis Incomplete',
      diseaseNameHindi: 'AI विश्लेषण पूरा नहीं हो सका',
      cropType: 'कनेक्शन त्रुटि',
      confidence: 0.0,
      symptoms: ['Could not connect to AI diagnosis service. Please check your internet connection.'],
      symptomsHindi: ['AI सर्वर से संपर्क नहीं हो सका। कृपया इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।'],
      organicTreatments: ['Check mobile internet or try in better network area.'],
      organicTreatmentsHindi: ['कृपया इंटरनेट चालू होने पर दोबारा फोटो लें।'],
      safetyWarning: 'Network communication error.',
      safetyWarningHindi: 'इंटरनेट अथवा सर्वर समस्या के कारण परिणाम उपलब्ध नहीं है।',
      scannedAt: DateTime.now(),
    );
  }
}
