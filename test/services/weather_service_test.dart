import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/services/weather_service.dart';

void main() {
  group('WeatherService Tests', () {
    late WeatherService service;

    setUp(() {
      service = WeatherService();
    });

    test('fetchCurrentWeather returns dynamic 7-day forecast with valid day names', () async {
      final weather = await service.fetchCurrentWeather(
        latitude: 28.6139,
        longitude: 77.2090,
        district: 'New Delhi',
      );

      expect(weather.location, contains('New Delhi'));
      expect(weather.temperature, greaterThan(-20));
      expect(weather.humidity, inInclusiveRange(0, 100));
      expect(weather.weeklyForecast.length, equals(7));

      final validDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (final day in weather.weeklyForecast) {
        expect(validDays.contains(day.dayName), isTrue);
        expect(day.dayNameHindi.isNotEmpty, isTrue);
        expect(day.maxTemp, greaterThanOrEqualTo(day.minTemp));
      }
    });

    test('fetchCurrentWeather includes actionable agro advisory in English and Hindi', () async {
      final weather = await service.fetchCurrentWeather(
        latitude: 25.3176,
        longitude: 82.9739,
        district: 'Varanasi',
      );

      expect(weather.advisory.isNotEmpty, isTrue);
      expect(weather.advisoryHindi.isNotEmpty, isTrue);
    });
  });
}
