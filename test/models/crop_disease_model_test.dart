import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/models/crop_disease_model.dart';

void main() {
  group('CropDiseaseModel & Non-Plant Guardrail Tests', () {
    test('Correctly deserializes non-plant object (e.g. Milton thermos flask / bottle)', () {
      const jsonString = '''
      {
        "isPlant": false,
        "detectedObject": "Milton Thermos Flask / Water Bottle",
        "cropType": "None / Non-Plant",
        "diseaseName": "Non-Plant Object",
        "diseaseNameHindi": "यह किसी फसल या पौधे की तस्वीर नहीं है",
        "confidence": 0.99,
        "symptoms": ["Metallic cylindrical surface", "Insulated lid"],
        "symptomsHindi": ["स्टील की सतह", "थर्मस ढक्कन"],
        "organicTreatments": [],
        "organicTreatmentsHindi": [],
        "safetyWarning": "This is an inanimate household item. Please photograph an agricultural crop or leaf.",
        "safetyWarningHindi": "यह घरेलू वस्तु है। कृपया केवल खेत की फसल, पौधे या पत्ते की फोटो खींचें।"
      }
      ''';

      final model = CropDiseaseModel.fromJson(json.decode(jsonString));

      expect(model.isPlant, isFalse);
      expect(model.detectedObject, equals('Milton Thermos Flask / Water Bottle'));
      expect(model.cropType, equals('None / Non-Plant'));
      expect(model.diseaseNameHindi, contains('यह किसी फसल या पौधे की तस्वीर नहीं है'));
      expect(model.safetyWarningHindi, contains('घरेलू वस्तु'));
    });

    test('Correctly deserializes authentic plant pathology diagnosis', () {
      const jsonString = '''
      {
        "isPlant": true,
        "cropType": "Tomato (Solanum lycopersicum)",
        "diseaseName": "Early Blight (Alternaria solani)",
        "diseaseNameHindi": "अगेती झुलसा (Early Blight)",
        "confidence": 0.94,
        "symptoms": [
          "Dark brown concentric ring spots on lower leaves",
          "Yellow chlorotic halo surrounding lesions"
        ],
        "symptomsHindi": [
          "निचले पत्तों पर भूरे छल्लेदार धब्बे",
          "धब्बों के चारों ओर पीला घेरा"
        ],
        "organicTreatments": [
          "Neem oil spray @ 5ml/L",
          "Trichoderma viride bio-fungicide"
        ],
        "organicTreatmentsHindi": [
          "नीम का तेल (5 मिली प्रति लीटर) का छिड़काव",
          "ट्राइकोडर्मा विरिडी जैव कवकनाशी"
        ],
        "safetyWarning": "Avoid sprinkler irrigation to prevent leaf wetness.",
        "safetyWarningHindi": "पत्तों को गीला होने से बचाने के लिए ड्रिप सिंचाई अपनाएं।"
      }
      ''';

      final model = CropDiseaseModel.fromJson(json.decode(jsonString));

      expect(model.isPlant, isTrue);
      expect(model.cropType, contains('Tomato'));
      expect(model.diseaseName, contains('Early Blight'));
      expect(model.confidence, equals(0.94));
      expect(model.organicTreatments.length, equals(2));
      expect(model.organicTreatmentsHindi.length, equals(2));
      expect(model.safetyWarning, isNotEmpty);
    });

    test('toJson and fromJson preserves all fields including isPlant and detectedObject', () {
      final now = DateTime.now();
      final model = CropDiseaseModel(
        diseaseName: 'Yellow Rust',
        diseaseNameHindi: 'पीला रतुआ',
        cropType: 'Wheat (गेहूं)',
        confidence: 0.92,
        symptoms: ['Yellow stripes on leaves'],
        symptomsHindi: ['पत्तियों पर पीली धारियां'],
        organicTreatments: ['Bio-fungicide Trichoderma'],
        organicTreatmentsHindi: ['ट्राइकोडर्मा का छिड़काव'],
        safetyWarning: 'Wash hands after applying treatment.',
        safetyWarningHindi: 'दवा छिड़कने के बाद हाथ अच्छी तरह धोएं।',
        scannedAt: now,
        isPlant: true,
        detectedObject: 'Wheat Leaf',
      );

      final jsonMap = model.toJson();
      final restored = CropDiseaseModel.fromJson(jsonMap);

      expect(restored.isPlant, isTrue);
      expect(restored.detectedObject, equals('Wheat Leaf'));
      expect(restored.diseaseName, equals('Yellow Rust'));
      expect(restored.diseaseNameHindi, equals('पीला रतुआ'));
      expect(restored.cropType, equals('Wheat (गेहूं)'));
      expect(restored.confidence, equals(0.92));
    });
  });
}
