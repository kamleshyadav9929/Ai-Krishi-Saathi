import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/models/govt_scheme_model.dart';
import 'package:ai_krishi_saathi/data/services/govt_schemes_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('GovtSchemeModel serializes and deserializes accurately with live crawl fields', () {
      final sample = GovtSchemeModel(
        id: 'pm-kisan',
        title: 'PM-Kisan Samman Nidhi',
        titleHindi: 'प्रधानमंत्री किसान सम्मान निधि',
        category: 'Income Support',
        categoryHindi: 'आय सहायता',
        benefit: '₹6000 per year',
        benefitHindi: '₹6000 प्रति वर्ष',
        eligibility: 'Landholding farmers',
        eligibilityHindi: 'भूमिधारक किसान',
        requiredDocuments: ['Aadhaar', 'Khasra'],
        requiredDocumentsHindi: ['आधार', 'खसरा'],
        portalUrl: 'https://pmkisan.gov.in',
        nodalMinistry: 'Ministry of Agriculture',
        helpline: '155261',
        latestAnnouncement: '23rd installment released',
        isLiveUpdated: true,
      );

      final jsonMap = sample.toJson();
      expect(jsonMap['id'], 'pm-kisan');
      expect(jsonMap['helpline'], '155261');
      expect(jsonMap['isLiveUpdated'], isTrue);

      final revived = GovtSchemeModel.fromJson(jsonMap);
      expect(revived.id, sample.id);
      expect(revived.title, sample.title);
      expect(revived.helpline, sample.helpline);
      expect(revived.latestAnnouncement, sample.latestAnnouncement);
      expect(revived.isLiveUpdated, isTrue);
    });

    test('Crawled artifact assets/data/latest_govt_schemes.json exists and is valid', () {
      final file = File('assets/data/latest_govt_schemes.json');
      expect(file.existsSync(), isTrue, reason: 'Crawler output file must exist');

      final content = file.readAsStringSync();
      final decoded = json.decode(content) as Map<String, dynamic>;

      expect(decoded.containsKey('schemes'), isTrue);
      expect(decoded.containsKey('liveAnnouncements'), isTrue);
      expect(decoded.containsKey('lastCrawled'), isTrue);

      final schemesList = decoded['schemes'] as List;
      expect(schemesList.length, greaterThanOrEqualTo(8));

      // Test parsing every single scheme with the model
      for (final item in schemesList) {
        final model = GovtSchemeModel.fromJson(Map<String, dynamic>.from(item as Map));
        expect(model.id.isNotEmpty, isTrue);
        expect(model.portalUrl.startsWith('https://'), isTrue);
        expect(model.title.isNotEmpty, isTrue);
        expect(model.titleHindi.isNotEmpty, isTrue);
      }
    });
  });
}
