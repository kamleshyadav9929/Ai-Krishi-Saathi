import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/services/sowing_service.dart';

void main() {
  group('SowingService ML Gaussian Naive Bayes Tests', () {
    late SowingService service;

    setUp(() {
      service = SowingService();
    });

    test('predictOptimalCrop identifies Rice under warm, humid, high-rainfall conditions', () {
      // Rice features: N=80, P=48, K=40, temp=24°C, humidity=82%, pH=6.4, rainfall=230mm
      final result = service.predictOptimalCrop(
        nitrogen: 80,
        phosphorus: 48,
        potassium: 40,
        temperature: 24,
        humidity: 82,
        ph: 6.4,
        rainfall: 230,
      );

      expect(result.predictedCrop.toLowerCase(), equals('rice'));
      expect(result.predictedCropHindi, contains('धान'));
      expect(result.confidence, greaterThan(0.8));
    });

    test('predictOptimalCrop identifies Wheat under cool, moderate-rainfall conditions', () {
      // Wheat features: N=120, P=58, K=38, temp=18°C, humidity=57%, pH=6.7, rainfall=75mm
      final result = service.predictOptimalCrop(
        nitrogen: 120,
        phosphorus: 58,
        potassium: 38,
        temperature: 18,
        humidity: 57,
        ph: 6.7,
        rainfall: 75,
      );

      expect(result.predictedCrop.toLowerCase(), equals('wheat'));
      expect(result.predictedCropHindi, contains('गेहूं'));
      expect(result.confidence, greaterThan(0.8));
    });

    test('predictOptimalCrop identifies Chickpea under low humidity, moderate temp conditions', () {
      // Chickpea features: N=34, P=68, K=80, temp=19.5°C, humidity=16.5%, pH=7.3, rainfall=80mm
      final result = service.predictOptimalCrop(
        nitrogen: 34,
        phosphorus: 68,
        potassium: 80,
        temperature: 19.5,
        humidity: 16.5,
        ph: 7.3,
        rainfall: 80,
      );

      expect(result.predictedCrop.toLowerCase(), equals('chickpea'));
      expect(result.predictedCropHindi, contains('चना'));
      expect(result.confidence, greaterThan(0.8));
    });

    test('getAllCrops returns comprehensive list of supported crops', () {
      final crops = service.getAllCrops();
      expect(crops.length, greaterThanOrEqualTo(10));
      expect(crops.any((c) => c.cropName.toLowerCase().contains('wheat')), isTrue);
      expect(crops.any((c) => c.cropName.toLowerCase().contains('paddy') || c.cropName.toLowerCase().contains('rice')), isTrue);
      expect(crops.any((c) => c.cropName.toLowerCase().contains('cotton')), isTrue);
      expect(crops.any((c) => c.cropName.toLowerCase().contains('mustard')), isTrue);
    });

    test('SowingGuideModel returns authentic ICAR agronomic guidance', () {
      final crops = service.getAllCrops();
      final wheat = crops.firstWhere((c) => c.cropName.toLowerCase().contains('wheat'));

      expect(wheat.cropName, contains('Wheat'));
      expect(wheat.season, contains('Rabi'));
      expect(wheat.bestPractices.isNotEmpty, isTrue);
      expect(wheat.bestPracticesHindi.isNotEmpty, isTrue);
    });
  });
}
