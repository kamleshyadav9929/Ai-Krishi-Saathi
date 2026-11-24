import 'package:flutter/material.dart';

class AgriProductModel {
  final String id;
  final String name;
  final String brand;
  final String chemicalName;
  final String category;
  final String categoryHindi;
  final String targetPests;
  final String targetCrops;
  final String dosagePer15LTank;
  final String dosagePerAcre;
  final String phiDays;
  final Color badgeColor;

  const AgriProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.chemicalName,
    required this.category,
    required this.categoryHindi,
    required this.targetPests,
    required this.targetCrops,
    required this.dosagePer15LTank,
    required this.dosagePerAcre,
    required this.phiDays,
    required this.badgeColor,
  });

  factory AgriProductModel.fromJson(Map<String, dynamic> json) {
    return AgriProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      chemicalName: json['chemicalName'] as String? ?? '',
      category: json['category'] as String? ?? 'All',
      categoryHindi: json['categoryHindi'] as String? ?? '',
      targetPests: json['targetPests'] as String? ?? '',
      targetCrops: json['targetCrops'] as String? ?? '',
      dosagePer15LTank: json['dosagePer15LTank'] as String? ?? '',
      dosagePerAcre: json['dosagePerAcre'] as String? ?? '',
      phiDays: json['phiDays'] as String? ?? '',
      badgeColor: Color(int.parse(json['badgeColorHex'] as String? ?? '0xFF15803D')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'chemicalName': chemicalName,
      'category': category,
      'categoryHindi': categoryHindi,
      'targetPests': targetPests,
      'targetCrops': targetCrops,
      'dosagePer15LTank': dosagePer15LTank,
      'dosagePerAcre': dosagePerAcre,
      'phiDays': phiDays,
      'badgeColorHex': '0x${badgeColor.toARGB32().toRadixString(16).toUpperCase()}',
    };
  }
}
