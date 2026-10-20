class WeatherModel {
  final String location;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int rainProbability;
  final String condition;
  final String conditionHindi;
  final String advisory;
  final String advisoryHindi;
  final List<DailyForecast> weeklyForecast;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.condition,
    required this.conditionHindi,
    required this.advisory,
    required this.advisoryHindi,
    required this.weeklyForecast,
  });
}

class DailyForecast {
  final String dayName;
  final String dayNameHindi;
  final double maxTemp;
  final double minTemp;
  final int rainChance;
  final String condition;

  DailyForecast({
    required this.dayName,
    required this.dayNameHindi,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
    required this.condition,
  });
}
