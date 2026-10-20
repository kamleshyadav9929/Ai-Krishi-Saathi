class CropDiseaseModel {
  final String diseaseName;
  final String diseaseNameHindi;
  final String cropType;
  final double confidence; // e.g., 0.94
  final List<String> symptoms;
  final List<String> symptomsHindi;
  final List<String> organicTreatments;
  final List<String> organicTreatmentsHindi;
  final String safetyWarning;
  final String safetyWarningHindi;
  final DateTime scannedAt;
  final String? imagePath;
  final bool isPlant;
  final String? detectedObject;

  CropDiseaseModel({
    required this.diseaseName,
    required this.diseaseNameHindi,
    required this.cropType,
    required this.confidence,
    required this.symptoms,
    required this.symptomsHindi,
    required this.organicTreatments,
    required this.organicTreatmentsHindi,
    required this.safetyWarning,
    required this.safetyWarningHindi,
    required this.scannedAt,
    this.imagePath,
    this.isPlant = true,
    this.detectedObject,
  });

  Map<String, dynamic> toJson() => {
        'diseaseName': diseaseName,
        'diseaseNameHindi': diseaseNameHindi,
        'cropType': cropType,
        'confidence': confidence,
        'symptoms': symptoms,
        'symptomsHindi': symptomsHindi,
        'organicTreatments': organicTreatments,
        'organicTreatmentsHindi': organicTreatmentsHindi,
        'safetyWarning': safetyWarning,
        'safetyWarningHindi': safetyWarningHindi,
        'scannedAt': scannedAt.toIso8601String(),
        'imagePath': imagePath,
        'isPlant': isPlant,
        'detectedObject': detectedObject,
      };

  factory CropDiseaseModel.fromJson(Map<String, dynamic> json) =>
      CropDiseaseModel(
        diseaseName: json['diseaseName'] ?? 'Unknown Issue',
        diseaseNameHindi: json['diseaseNameHindi'] ?? 'अज्ञात रोग / कीट',
        cropType: json['cropType'] ?? 'General Crop',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.85,
        symptoms: List<String>.from(json['symptoms'] ?? []),
        symptomsHindi: List<String>.from(json['symptomsHindi'] ?? []),
        organicTreatments: List<String>.from(json['organicTreatments'] ?? []),
        organicTreatmentsHindi:
            List<String>.from(json['organicTreatmentsHindi'] ?? []),
        safetyWarning: json['safetyWarning'] ?? '',
        safetyWarningHindi: json['safetyWarningHindi'] ?? '',
        scannedAt: json['scannedAt'] != null
            ? DateTime.parse(json['scannedAt'])
            : DateTime.now(),
        imagePath: json['imagePath'],
        isPlant: json['isPlant'] is bool ? json['isPlant'] : true,
        detectedObject: json['detectedObject'],
      );
}
