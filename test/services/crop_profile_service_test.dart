import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_krishi_saathi/data/models/crop_profile_model.dart';
import 'package:ai_krishi_saathi/data/services/crop_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CropProfileModel Unit Tests', () {
    test('Correctly computes DAS (Days After Sowing) and total investment', () {
      final sowingDate = DateTime.now().subtract(const Duration(days: 25));
      final profile = CropProfileModel(
        id: 'crop_wheat_01',
        cropName: 'Wheat',
        cropNameHindi: 'गेहूं',
        variety: 'HD-2967',
        plotName: 'उत्तर वाला खेत',
        acres: 2.5,
        sowingDate: sowingDate,
        soilType: 'Loamy',
        irrigationSource: 'Tubewell',
        notes: 'DAP डाला गया था बुवाई के समय',
        activities: [
          CropActivityLog(
            id: 'act_01',
            date: sowingDate,
            type: ActivityType.sowing,
            title: 'बुवाई (Sowing)',
            description: '2.5 एकड़ बीज',
            cost: 3500.0,
          ),
          CropActivityLog(
            id: 'act_02',
            date: sowingDate.add(const Duration(days: 21)),
            type: ActivityType.irrigation,
            title: 'CRI सिंचाई (1st Irrigation)',
            description: 'पहली सिंचाई 21 दिन पर',
            cost: 800.0,
          ),
        ],
      );

      expect(profile.currentDas, inInclusiveRange(24, 26));
      expect(profile.totalInvestment, equals(4300.0));
      expect(profile.activities.length, equals(2));
    });

    test('Serializes to Json and deserializes from Json with complete integrity', () {
      final sowingDate = DateTime(2026, 10, 1);
      final original = CropProfileModel(
        id: 'test_mustard',
        cropName: 'Mustard',
        cropNameHindi: 'सरसों',
        variety: 'Pusa Bold',
        plotName: 'दक्षिण खेत',
        acres: 1.5,
        sowingDate: sowingDate,
        soilType: 'Sandy Loam',
        irrigationSource: 'Canal',
        notes: 'सल्फर युक्त खाद',
        activities: [
          CropActivityLog(
            id: 'log_01',
            date: sowingDate,
            type: ActivityType.fertilizer,
            title: 'एसएसपी खाद (SSP Fertilizer)',
            description: '2 बैग सिंगल सुपर फास्फेट',
            cost: 1200.0,
          ),
        ],
      );

      final jsonMap = original.toJson();
      final restored = CropProfileModel.fromJson(jsonMap);

      expect(restored.id, equals(original.id));
      expect(restored.cropName, equals('Mustard'));
      expect(restored.cropNameHindi, equals('सरसों'));
      expect(restored.variety, equals('Pusa Bold'));
      expect(restored.acres, equals(1.5));
      expect(restored.activities.length, equals(1));
      expect(restored.activities.first.cost, equals(1200.0));
      expect(restored.activities.first.title, equals('एसएसपी खाद (SSP Fertilizer)'));
    });
  });

  group('CropProfileService Persistence & Agronomic Context Tests', () {
    late CropProfileService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = CropProfileService();
    });

    test('Creates, retrieves, logs activities, and calculates total investment accurately', () async {
      final sowingDate = DateTime.now().subtract(const Duration(days: 18));
      final newCrop = CropProfileModel(
        id: 'crop_gram_01',
        cropName: 'Gram / Chickpea',
        cropNameHindi: 'चना',
        variety: 'JG-11',
        plotName: 'बड़ा चक',
        acres: 3.0,
        sowingDate: sowingDate,
        soilType: 'Black Soil',
        irrigationSource: 'Borewell',
        activities: [],
      );

      await service.addOrUpdateProfile(newCrop);
      final list = await service.loadProfiles();
      expect(list.length, equals(1));
      expect(list.first.cropName, equals('Gram / Chickpea'));

      // Log a spray activity
      final activity = CropActivityLog(
        id: 'act_spray_01',
        date: DateTime.now(),
        type: ActivityType.spray,
        title: 'कीट रोकथाम स्प्रे (Pest Control)',
        description: 'नीम तेल 5ml प्रति लीटर',
        cost: 650.0,
      );

      await service.addActivity('crop_gram_01', activity);
      final updatedList = await service.loadProfiles();
      final updatedProfile = updatedList.first;

      expect(updatedProfile.activities.length, equals(1));
      expect(updatedProfile.totalInvestment, equals(650.0));
      expect(updatedProfile.activities.first.title, equals('कीट रोकथाम स्प्रे (Pest Control)'));
    });

    test('buildAIContext accurately structures ICAR agronomy parameters for Gemini API', () {
      final sowingDate = DateTime.now().subtract(const Duration(days: 22));
      final profile = CropProfileModel(
        id: 'crop_wheat_active',
        cropName: 'Wheat',
        cropNameHindi: 'गेहूं',
        variety: 'DBW-187 (Karan Vandana)',
        plotName: 'चक नंबर 4',
        acres: 4.0,
        sowingDate: sowingDate,
        soilType: 'Alluvial',
        irrigationSource: 'Canal',
        activities: [
          CropActivityLog(
            id: 'log_01',
            date: sowingDate,
            type: ActivityType.sowing,
            title: 'बुवाई',
            description: 'प्रमाणित बीज',
            cost: 4000.0,
          ),
        ],
      );

      final aiContext = service.buildAIContext(profile);
      expect(aiContext, contains('गेहूं'));
      expect(aiContext, contains('DBW-187 (Karan Vandana)'));
      expect(aiContext, contains('4.0 एकड़'));
      expect(aiContext, contains('22 दिन / DAS'));
      expect(aiContext, contains('सिंचाई का साधन'));
    });
  });
}
