enum ActivityType {
  sowing,
  irrigation,
  fertilizer,
  spray,
  weeding,
  harvest,
}

class CropActivityLog {
  final String id;
  final DateTime date;
  final ActivityType type;
  final String title;
  final String description;
  final double cost;

  CropActivityLog({
    required this.id,
    required this.date,
    required this.type,
    required this.title,
    required this.description,
    this.cost = 0.0,
  });

  String get typeHindi {
    switch (type) {
      case ActivityType.sowing:
        return 'बुवाई (Sowing)';
      case ActivityType.irrigation:
        return 'सिंचाई (Irrigation)';
      case ActivityType.fertilizer:
        return 'खाद / उर्वरक (Fertilizer)';
      case ActivityType.spray:
        return 'कीटनाशक / दवा स्प्रे (Spray)';
      case ActivityType.weeding:
        return 'निराई-गुड़ाई (Weeding)';
      case ActivityType.harvest:
        return 'कटाई (Harvesting)';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'type': type.name,
        'title': title,
        'description': description,
        'cost': cost,
      };

  factory CropActivityLog.fromJson(Map<String, dynamic> json) => CropActivityLog(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        type: ActivityType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => ActivityType.irrigation,
        ),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      );
}

class CropProfileModel {
  final String id;
  final String cropName;
  final String cropNameHindi;
  final String variety;
  final String plotName;
  final double acres;
  final DateTime sowingDate;
  final String soilType;
  final String irrigationSource;
  final String? notes;
  final List<CropActivityLog> activities;

  CropProfileModel({
    required this.id,
    required this.cropName,
    required this.cropNameHindi,
    required this.variety,
    required this.plotName,
    required this.acres,
    required this.sowingDate,
    required this.soilType,
    required this.irrigationSource,
    this.notes,
    List<CropActivityLog>? activities,
  }) : activities = activities ?? [];

  int get currentDas => DateTime.now().difference(sowingDate).inDays;

  double get totalInvestment => activities.fold(0.0, (sum, item) => sum + item.cost);

  Map<String, dynamic> toJson() => {
        'id': id,
        'cropName': cropName,
        'cropNameHindi': cropNameHindi,
        'variety': variety,
        'plotName': plotName,
        'acres': acres,
        'sowingDate': sowingDate.toIso8601String(),
        'soilType': soilType,
        'irrigationSource': irrigationSource,
        'notes': notes,
        'activities': activities.map((a) => a.toJson()).toList(),
      };

  factory CropProfileModel.fromJson(Map<String, dynamic> json) => CropProfileModel(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        cropName: json['cropName'] ?? 'Wheat',
        cropNameHindi: json['cropNameHindi'] ?? 'गेहूं',
        variety: json['variety'] ?? 'General Variety',
        plotName: json['plotName'] ?? 'Main Field',
        acres: (json['acres'] as num?)?.toDouble() ?? 1.0,
        sowingDate: DateTime.tryParse(json['sowingDate'] ?? '') ?? DateTime.now(),
        soilType: json['soilType'] ?? 'Alluvial Loam (दोमट)',
        irrigationSource: json['irrigationSource'] ?? 'Tubewell',
        notes: json['notes'],
        activities: (json['activities'] as List<dynamic>?)
                ?.map((a) => CropActivityLog.fromJson(a as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
