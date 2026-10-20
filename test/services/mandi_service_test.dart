import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/services/mandi_service.dart';

void main() {
  group('MandiService & All-India Agmarknet Dataset Tests', () {
    late MandiService service;

    setUp(() {
      service = MandiService();
    });

    test('getAvailableStates returns all 36 States and Union Territories of India', () {
      final states = service.getAvailableStates();

      expect(states.length, equals(36));
      expect(states.contains('Uttar Pradesh'), isTrue);
      expect(states.contains('Madhya Pradesh'), isTrue);
      expect(states.contains('Punjab'), isTrue);
      expect(states.contains('Maharashtra'), isTrue);
      expect(states.contains('Rajasthan'), isTrue);
      expect(states.contains('Bihar'), isTrue);
      expect(states.contains('Gujarat'), isTrue);
      expect(states.contains('Kerala'), isTrue);
      expect(states.contains('Assam'), isTrue);
      expect(states.contains('Jammu and Kashmir'), isTrue);
      expect(states.contains('Delhi (NCT)'), isTrue);
      expect(states.contains('Ladakh'), isTrue);
      expect(states.contains('Andaman and Nicobar Islands'), isTrue);
    });

    test('getDistrictsForState returns complete authentic districts for Indian states', () {
      final upDistricts = service.getDistrictsForState('Uttar Pradesh');
      expect(upDistricts.length, equals(75));
      expect(upDistricts.contains('Varanasi'), isTrue);
      expect(upDistricts.contains('Ballia'), isTrue);
      expect(upDistricts.contains('Ayodhya'), isTrue);
      expect(upDistricts.contains('Gorakhpur'), isTrue);
      expect(upDistricts.contains('Prayagraj'), isTrue);

      final biharDistricts = service.getDistrictsForState('Bihar');
      expect(biharDistricts.length, equals(38));
      expect(biharDistricts.contains('Patna'), isTrue);
      expect(biharDistricts.contains('Samastipur'), isTrue);
      expect(biharDistricts.contains('Gaya'), isTrue);
      expect(biharDistricts.contains('Muzaffarpur'), isTrue);

      final rajDistricts = service.getDistrictsForState('Rajasthan');
      expect(rajDistricts.length, equals(50));
      expect(rajDistricts.contains('Kota'), isTrue);
      expect(rajDistricts.contains('Barmer'), isTrue);
      expect(rajDistricts.contains('Jodhpur'), isTrue);

      final mhDistricts = service.getDistrictsForState('Maharashtra');
      expect(mhDistricts.length, equals(36));
      expect(mhDistricts.contains('Nashik'), isTrue);
      expect(mhDistricts.contains('Solapur'), isTrue);

      final mpDistricts = service.getDistrictsForState('Madhya Pradesh');
      expect(mpDistricts.length, equals(55));
      expect(mpDistricts.contains('Indore'), isTrue);
      expect(mpDistricts.contains('Ujjain'), isTrue);
      expect(mpDistricts.contains('Chhindwara'), isTrue);
    });

    test('fetchPrices returns authentic Agmarknet records for ANY location in India', () async {
      // Test Ballia in Uttar Pradesh
      final balliaRecords = await service.fetchPrices(
        state: 'Uttar Pradesh',
        district: 'Ballia',
      );
      expect(balliaRecords.isNotEmpty, isTrue);
      expect(balliaRecords.first.state, equals('Uttar Pradesh'));
      expect(balliaRecords.first.district, equals('Ballia'));
      expect(balliaRecords.first.modalPrice, greaterThan(0));
      expect(balliaRecords.first.source, contains('Agmarknet'));

      // Test Samastipur in Bihar
      final samastipurRecords = await service.fetchPrices(
        state: 'Bihar',
        district: 'Samastipur',
      );
      expect(samastipurRecords.isNotEmpty, isTrue);
      expect(samastipurRecords.first.district, equals('Samastipur'));
      expect(samastipurRecords.every((r) => r.commodity.isNotEmpty && r.modalPrice > 0), isTrue);

      // Test Wayanad in Kerala
      final wayanadRecords = await service.fetchPrices(
        state: 'Kerala',
        district: 'Wayanad',
      );
      expect(wayanadRecords.isNotEmpty, isTrue);
      expect(wayanadRecords.first.district, equals('Wayanad'));
    });

    test('fetchPrices filters by commodity name or Hindi name', () async {
      final wheatRecords = await service.fetchPrices(
        commodityQuery: 'गेहूं',
      );

      expect(wheatRecords.isNotEmpty, isTrue);
      for (final r in wheatRecords) {
        final matches = r.commodity.toLowerCase().contains('wheat') ||
            r.commodityHindi.contains('गेहूं');
        expect(matches, isTrue);
      }
    });

    test('getPriceTrend generates 7-day realistic price points based on modal price', () {
      final trend = service.getPriceTrend('Wheat');

      expect(trend.length, equals(7));
      for (final val in trend) {
        expect(val, greaterThan(0));
      }
    });
  });
}
