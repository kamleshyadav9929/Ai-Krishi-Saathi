import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crop_profile_model.dart';

class CropProfileService {
  static const String _storageKey = 'saved_farmer_crop_profiles';
  static const String _activeProfileIdKey = 'active_farmer_crop_profile_id';

  Future<List<CropProfileModel>> loadProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final List list = jsonDecode(data);
        return list.map((e) => CropProfileModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> saveProfiles(List<CropProfileModel> profiles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(profiles.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (_) {}
  }

  Future<void> addOrUpdateProfile(CropProfileModel profile) async {
    final list = await loadProfiles();
    final index = list.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      list[index] = profile;
    } else {
      list.add(profile);
    }
    await saveProfiles(list);
  }

  Future<void> addActivity(String profileId, CropActivityLog activity) async {
    final list = await loadProfiles();
    final index = list.indexWhere((p) => p.id == profileId);
    if (index >= 0) {
      final existing = list[index];
      final updatedActivities = List<CropActivityLog>.from(existing.activities)..insert(0, activity);
      final updatedProfile = CropProfileModel(
        id: existing.id,
        cropName: existing.cropName,
        cropNameHindi: existing.cropNameHindi,
        variety: existing.variety,
        plotName: existing.plotName,
        acres: existing.acres,
        sowingDate: existing.sowingDate,
        soilType: existing.soilType,
        irrigationSource: existing.irrigationSource,
        notes: existing.notes,
        activities: updatedActivities,
      );
      list[index] = updatedProfile;
      await saveProfiles(list);
    }
  }

  Future<void> deleteProfile(String profileId) async {
    final list = await loadProfiles();
    list.removeWhere((p) => p.id == profileId);
    await saveProfiles(list);
  }

  Future<String?> getActiveProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeProfileIdKey);
  }

  Future<void> setActiveProfileId(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeProfileIdKey, profileId);
  }

  /// Formats the active crop profile into an agronomic context for Gemini AI
  String buildAIContext(CropProfileModel profile) {
    final buffer = StringBuffer();
    buffer.writeln('किसान की वर्तमान फसल प्रोफ़ाइल (Farmer Crop Profile Context):');
    buffer.writeln('- फसल (Crop): ${profile.cropNameHindi} / ${profile.cropName} (किस्म/Variety: ${profile.variety})');
    buffer.writeln('- खेत का नाम (Plot): ${profile.plotName} (${profile.acres} एकड़ / Acres)');
    buffer.writeln('- बुवाई की तिथि (Sowing Date): ${profile.sowingDate.day}/${profile.sowingDate.month}/${profile.sowingDate.year} (आज फसल की आयु: ${profile.currentDas} दिन / DAS)');
    buffer.writeln('- मिट्टी का प्रकार (Soil): ${profile.soilType}, सिंचाई का साधन (Water): ${profile.irrigationSource}');

    if (profile.activities.isNotEmpty) {
      buffer.writeln('- खेत में किए गए हालिया कार्य (Recent Farm Activities):');
      for (final a in profile.activities.take(3)) {
        buffer.writeln('  * [${a.date.day}/${a.date.month}] ${a.typeHindi}: ${a.title} - ${a.description}');
      }
    }

    return buffer.toString();
  }
}
