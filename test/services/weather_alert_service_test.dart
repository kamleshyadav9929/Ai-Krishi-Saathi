import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:ai_krishi_saathi/data/models/crop_profile_model.dart';
import 'package:ai_krishi_saathi/data/models/weather_alert_model.dart';
import 'package:ai_krishi_saathi/data/models/weather_model.dart';
import 'package:ai_krishi_saathi/data/services/weather_alert_service.dart';

void main() {
  late WeatherAlertService service;

  setUp(() {
    service = WeatherAlertService();
  });

  group('WeatherAlertService Unit Tests', () {
    test('Detects Heavy Rain & Waterlogging Alert with strict chemical spray restrictions', () {
      final rainyWeather = WeatherModel(
        location: 'Patna, Bihar',
        temperature: 24.0,
        humidity: 85,
        windSpeed: 18.0,
        rainProbability: 75,
        condition: 'Rain Shower',
        conditionHindi: 'वर्षा / बौछार',
        advisory: 'Rain expected',
        advisoryHindi: 'बारिश का अनुमान',
        weeklyForecast: [
          DailyForecast(
            dayName: 'Mon',
            dayNameHindi: 'सोमवार',
            maxTemp: 26,
            minTemp: 19,
            rainChance: 80,
            condition: 'Rain Shower',
          ),
        ],
      );

      final alerts = service.generateAlerts(rainyWeather);
      expect(alerts.isNotEmpty, isTrue);

      final rainAlert = alerts.firstWhere((a) => a.id.contains('rain'));
      expect(rainAlert.severity, equals(AlertSeverity.critical));
      expect(rainAlert.category, equals(AlertCategory.weather));
      expect(rainAlert.titleHindi, contains('बारिश'));
      expect(rainAlert.dosHindi.any((d) => d.contains('जल निकासी')), isTrue);
      expect(rainAlert.dontsHindi.any((d) => d.contains('यूरिया') || d.contains('उर्वरक')), isTrue);
      expect(rainAlert.dontsHindi.any((d) => d.contains('कीटनाशक')), isTrue);
    });

    test('Detects Frost & Cold Wave Alert and recommends evening thermal irrigation', () {
      final freezingWeather = WeatherModel(
        location: 'Bhiwani, Haryana',
        temperature: 4.5,
        humidity: 60,
        windSpeed: 6.0,
        rainProbability: 5,
        condition: 'Clear Sky',
        conditionHindi: 'साफ आसमान',
        advisory: 'Cold wave',
        advisoryHindi: 'शीतलहर',
        weeklyForecast: [
          DailyForecast(
            dayName: 'Tue',
            dayNameHindi: 'मंगलवार',
            maxTemp: 16,
            minTemp: 3.0,
            rainChance: 5,
            condition: 'Clear Sky',
          ),
        ],
      );

      final alerts = service.generateAlerts(freezingWeather);
      expect(alerts.isNotEmpty, isTrue);

      final frostAlert = alerts.firstWhere((a) => a.id.contains('frost'));
      expect(frostAlert.severity, equals(AlertSeverity.critical));
      expect(frostAlert.titleHindi, contains('पाला'));
      expect(frostAlert.dosHindi.any((d) => d.contains('हल्की सिंचाई')), isTrue);
      expect(frostAlert.dosHindi.any((d) => d.contains('सल्फर')), isTrue);
    });

    test('Detects Heat Wave stress and recommends potassium nitrate & frequent watering', () {
      final scorchingWeather = WeatherModel(
        location: 'Kota, Rajasthan',
        temperature: 41.5,
        humidity: 25,
        windSpeed: 22.0,
        rainProbability: 0,
        condition: 'Clear Sky',
        conditionHindi: 'साफ आसमान',
        advisory: 'Heat wave',
        advisoryHindi: 'लू',
        weeklyForecast: [
          DailyForecast(
            dayName: 'Wed',
            dayNameHindi: 'बुधवार',
            maxTemp: 42.0,
            minTemp: 27.0,
            rainChance: 0,
            condition: 'Clear Sky',
          ),
        ],
      );

      final alerts = service.generateAlerts(scorchingWeather);
      final heatAlert = alerts.firstWhere((a) => a.id.contains('heat'));
      expect(heatAlert.severity, equals(AlertSeverity.critical));
      expect(heatAlert.titleHindi, contains('लू'));
      expect(heatAlert.dosHindi.any((d) => d.contains('पोटेशियम नाइट्रेट')), isTrue);
    });

    test('Detects Potato & Tomato Late Blight (झुलसा) under high humidity & cool temperatures', () {
      final blightWeather = WeatherModel(
        location: 'Samastipur, Bihar',
        temperature: 16.5,
        humidity: 92,
        windSpeed: 5.0,
        rainProbability: 20,
        condition: 'Overcast',
        conditionHindi: 'बादल छाए रहेंगे',
        advisory: 'Overcast and humid',
        advisoryHindi: 'नमी अधिक है',
        weeklyForecast: [
          DailyForecast(
            dayName: 'Thu',
            dayNameHindi: 'गुरुवार',
            maxTemp: 21,
            minTemp: 14,
            rainChance: 25,
            condition: 'Overcast',
          ),
        ],
      );

      final alerts = service.generateAlerts(blightWeather);
      final blightAlert = alerts.firstWhere((a) => a.id.contains('blight'));
      expect(blightAlert.category, equals(AlertCategory.pestDisease));
      expect(blightAlert.titleHindi, contains('झुलसा'));
      expect(blightAlert.dosHindi.any((d) => d.contains('मैंकोजेब')), isTrue);
      expect(blightAlert.affectedCropsHindi, contains('आलू'));
    });

    test('Detects Mustard Aphid (माहू / चेपा) under overcast skies and moderate cool temperature', () {
      final aphidWeather = WeatherModel(
        location: 'Alwar, Rajasthan',
        temperature: 17.0,
        humidity: 72,
        windSpeed: 8.0,
        rainProbability: 15,
        condition: 'Overcast',
        conditionHindi: 'बादल छाए रहेंगे',
        advisory: 'Overcast',
        advisoryHindi: 'बादल छाए हैं',
        weeklyForecast: [],
      );

      final alerts = service.generateAlerts(aphidWeather);
      final aphidAlert = alerts.firstWhere((a) => a.id.contains('aphid'));
      expect(aphidAlert.category, equals(AlertCategory.pestDisease));
      expect(aphidAlert.titleHindi, contains('माहू'));
      expect(aphidAlert.dosHindi.any((d) => d.contains('नीम का तेल') || d.contains('ट्रैप')), isTrue);
      expect(aphidAlert.affectedCropsHindi, contains('सरसों'));
    });

    test('Returns Safe Agricultural Window when meteorological conditions are benign', () {
      final pleasantWeather = WeatherModel(
        location: 'Indore, MP',
        temperature: 26.0,
        humidity: 48,
        windSpeed: 9.0,
        rainProbability: 5,
        condition: 'Clear Sky',
        conditionHindi: 'साफ आसमान',
        advisory: 'Ideal weather',
        advisoryHindi: 'मौसम अनुकूल है',
        weeklyForecast: [
          DailyForecast(
            dayName: 'Fri',
            dayNameHindi: 'शुक्रवार',
            maxTemp: 28,
            minTemp: 18,
            rainChance: 10,
            condition: 'Clear Sky',
          ),
        ],
      );

      final alerts = service.generateAlerts(pleasantWeather);
      expect(alerts.isNotEmpty, isTrue);
      expect(alerts.first.severity, equals(AlertSeverity.safe));
      expect(alerts.first.titleHindi, contains('मौसम अनुकूल'));
      expect(alerts.first.dosHindi.any((d) => d.contains('बुवाई') || d.contains('छिड़काव')), isTrue);
    });

    test('isRelevantToFarmer correctly matches alert with registered Crop Profiles', () {
      final alert = WeatherAlertModel(
        id: 'test_alert',
        titleHindi: 'आलू झुलसा चेतावनी',
        titleEnglish: 'Potato Blight Alert',
        severity: AlertSeverity.warning,
        category: AlertCategory.pestDisease,
        conditionSummaryHindi: 'झुलसा रोग का खतरा',
        conditionSummaryEnglish: 'Blight risk',
        affectedCropsHindi: ['आलू', 'टमाटर'],
        affectedCropsEnglish: ['Potato', 'Tomato'],
        dosHindi: ['छिड़काव करें'],
        dosEnglish: ['Spray'],
        dontsHindi: ['पानी न जमा होने दें'],
        dontsEnglish: ['Avoid waterlogging'],
        audioAdvisoryHindi: 'सावधानी बरतें',
        audioAdvisoryEnglish: 'Take care',
        icon: LucideIcons.bug,
      );

      final farmerWithPotato = [
        CropProfileModel(
          id: 'p1',
          cropName: 'Potato',
          cropNameHindi: 'आलू',
          variety: 'Kufri Jyoti',
          plotName: 'East Field',
          acres: 2.5,
          sowingDate: DateTime.now().subtract(const Duration(days: 30)),
          soilType: 'Sandy Loam',
          irrigationSource: 'Tubewell',
        ),
      ];

      final farmerWithCotton = [
        CropProfileModel(
          id: 'p2',
          cropName: 'Cotton',
          cropNameHindi: 'कपास',
          variety: 'BT Cotton',
          plotName: 'South Field',
          acres: 5.0,
          sowingDate: DateTime.now().subtract(const Duration(days: 50)),
          soilType: 'Black Soil',
          irrigationSource: 'Canal',
        ),
      ];

      expect(service.isRelevantToFarmer(alert, farmerWithPotato), isTrue);
      expect(service.isRelevantToFarmer(alert, farmerWithCotton), isFalse);
    });
  });
}
