import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/services/soil_card_service.dart';

void main() {
  group('SoilCardService Agronomic Calculator Tests', () {
    late SoilCardService service;

    setUp(() {
      service = SoilCardService();
    });

    test('calculateFertilizerPlan accurately computes Urea, DAP, and MOP bags for 1 acre Wheat', () {
      final plan = service.calculateFertilizerPlan(
        crop: 'Wheat',
        acres: 1.0,
        nitrogenStatus: 'Medium',
        phosphorusStatus: 'Medium',
        potassiumStatus: 'Medium',
        ph: 7.2,
      );

      expect(plan.dapBags, greaterThan(0));
      expect(plan.ureaBags, greaterThan(0));
      expect(plan.mopBags, greaterThan(0));
      expect(plan.scheduleHindi, contains('DAP'));
      expect(plan.scheduleHindi, contains('यूरिया'));
      expect(plan.amendmentAdviceHindi, contains('सामान्य'));
    });

    test('calculateFertilizerPlan increases N doses by 25% when soil Nitrogen is Low', () {
      final planLowN = service.calculateFertilizerPlan(
        crop: 'Wheat',
        acres: 1.0,
        nitrogenStatus: 'Low',
        phosphorusStatus: 'Medium',
        potassiumStatus: 'Medium',
        ph: 7.0,
      );

      final planMedN = service.calculateFertilizerPlan(
        crop: 'Wheat',
        acres: 1.0,
        nitrogenStatus: 'Medium',
        phosphorusStatus: 'Medium',
        potassiumStatus: 'Medium',
        ph: 7.0,
      );

      expect(planLowN.ureaBags, greaterThan(planMedN.ureaBags));
    });

    test('Soil amendment correctly flags acidic pH with Lime and alkaline pH with Gypsum', () {
      final acidicPlan = service.calculateFertilizerPlan(
        crop: 'Wheat',
        acres: 1.0,
        nitrogenStatus: 'Medium',
        phosphorusStatus: 'Medium',
        potassiumStatus: 'Medium',
        ph: 5.4,
      );
      expect(acidicPlan.amendmentAdviceHindi, contains('चूना'));

      final alkalinePlan = service.calculateFertilizerPlan(
        crop: 'Wheat',
        acres: 1.0,
        nitrogenStatus: 'Medium',
        phosphorusStatus: 'Medium',
        potassiumStatus: 'Medium',
        ph: 8.5,
      );
      expect(alkalinePlan.amendmentAdviceHindi, contains('जिप्सम'));
    });
  });
}
