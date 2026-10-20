class SowingGuideModel {
  final String cropName;
  final String cropNameHindi;
  final String season;
  final String seasonHindi;
  final String soilType;
  final String soilTypeHindi;
  final String sowingWindow;
  final String sowingWindowHindi;
  final String duration;
  final String durationHindi;
  final String waterNeed;
  final String waterNeedHindi;
  final List<String> bestPractices;
  final List<String> bestPracticesHindi;

  SowingGuideModel({
    required this.cropName,
    required this.cropNameHindi,
    required this.season,
    required this.seasonHindi,
    required this.soilType,
    required this.soilTypeHindi,
    required this.sowingWindow,
    required this.sowingWindowHindi,
    required this.duration,
    required this.durationHindi,
    required this.waterNeed,
    required this.waterNeedHindi,
    required this.bestPractices,
    required this.bestPracticesHindi,
  });
}
