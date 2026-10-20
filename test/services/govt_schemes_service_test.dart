import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/services/govt_schemes_service.dart';

void main() {
  group('GovtSchemesService Tests', () {
    late GovtSchemesService service;

    setUp(() {
      service = GovtSchemesService();
    });

    test('getAllSchemes returns all authentic government agriculture schemes', () {
      final schemes = service.getAllSchemes();

      expect(schemes.length, greaterThanOrEqualTo(8));
      expect(schemes.any((s) => s.id == 'pm-kisan'), isTrue);
      expect(schemes.any((s) => s.id == 'pm-kusum'), isTrue);
      expect(schemes.any((s) => s.id == 'pmfby'), isTrue);
      expect(schemes.any((s) => s.id == 'kcc'), isTrue);
      expect(schemes.any((s) => s.id == 'smam'), isTrue);
    });

    test('All schemes contain valid official government portal links and requirements', () {
      final schemes = service.getAllSchemes();

      for (final s in schemes) {
        expect(s.portalUrl.startsWith('https://'), isTrue);
        expect(s.benefit.isNotEmpty, isTrue);
        expect(s.benefitHindi.isNotEmpty, isTrue);
        expect(s.requiredDocuments.isNotEmpty, isTrue);
        expect(s.requiredDocumentsHindi.isNotEmpty, isTrue);
      }
    });

    test('filterSchemes filters accurately by search keywords', () {
      final solarResults = service.filterSchemes(searchQuery: 'सोलर');
      expect(solarResults.isNotEmpty, isTrue);
      expect(solarResults.any((s) => s.id == 'pm-kusum'), isTrue);

      final kccResults = service.filterSchemes(searchQuery: 'क्रेडिट');
      expect(kccResults.isNotEmpty, isTrue);
      expect(kccResults.any((s) => s.id == 'kcc'), isTrue);
    });
  });
}
