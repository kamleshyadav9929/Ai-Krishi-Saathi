import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationData {
  final double latitude;
  final double longitude;
  final String district;
  final String state;
  final String? subLocality;
  final String? postalCode;
  final bool isGpsDetected;

  const UserLocationData({
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.state,
    this.subLocality,
    this.postalCode,
    this.isGpsDetected = true,
  });

  String get displayName {
    if (subLocality != null && subLocality!.isNotEmpty && subLocality != district) {
      return '$subLocality, $district';
    }
    return '$district, $state';
  }
}

class LocationService {
  /// Normalize Indian State names from reverse-geocoded values
  static String normalizeStateName(String rawState) {
    final cleaned = rawState.trim();
    final lower = cleaned.toLowerCase();

    if (lower.contains('bihar')) return 'Bihar';
    if (lower.contains('jharkhand')) return 'Jharkhand';
    if (lower.contains('uttar pradesh') || lower == 'up') return 'Uttar Pradesh';
    if (lower.contains('madhya pradesh') || lower == 'mp') return 'Madhya Pradesh';
    if (lower.contains('rajasthan')) return 'Rajasthan';
    if (lower.contains('maharashtra')) return 'Maharashtra';
    if (lower.contains('punjab')) return 'Punjab';
    if (lower.contains('haryana')) return 'Haryana';
    if (lower.contains('gujarat')) return 'Gujarat';
    if (lower.contains('west bengal') || lower == 'wb') return 'West Bengal';
    if (lower.contains('odisha') || lower.contains('orissa')) return 'Odisha';
    if (lower.contains('karnataka')) return 'Karnataka';
    if (lower.contains('tamil nadu') || lower == 'tn') return 'Tamil Nadu';
    if (lower.contains('telangana')) return 'Telangana';
    if (lower.contains('andhra pradesh') || lower == 'ap') return 'Andhra Pradesh';
    if (lower.contains('kerala')) return 'Kerala';
    if (lower.contains('assam')) return 'Assam';
    if (lower.contains('chhattisgarh')) return 'Chhattisgarh';
    if (lower.contains('uttarakhand')) return 'Uttarakhand';
    if (lower.contains('himachal pradesh') || lower == 'hp') return 'Himachal Pradesh';
    if (lower.contains('jammu') || lower.contains('kashmir')) return 'Jammu and Kashmir';
    if (lower.contains('delhi')) return 'Delhi';
    if (lower.contains('goa')) return 'Goa';
    if (lower.contains('tripura')) return 'Tripura';
    if (lower.contains('meghalaya')) return 'Meghalaya';
    if (lower.contains('manipur')) return 'Manipur';
    if (lower.contains('nagaland')) return 'Nagaland';
    if (lower.contains('mizoram')) return 'Mizoram';
    if (lower.contains('sikkim')) return 'Sikkim';
    if (lower.contains('arunachal')) return 'Arunachal Pradesh';
    if (lower.contains('chandigarh')) return 'Chandigarh';
    if (lower.contains('puducherry') || lower.contains('pondicherry')) return 'Puducherry';

    return cleaned.isNotEmpty ? cleaned : 'Bihar';
  }

  /// Clean district names (strip 'District', 'division', etc.)
  static String cleanDistrictName(String rawDistrict) {
    var cleaned = rawDistrict
        .replaceAll(RegExp(r'\b(District|division|mandal|tehsil)\b', caseSensitive: false), '')
        .trim();
    if (cleaned.isEmpty) return 'Patna';
    return cleaned;
  }

  /// Checks whether GPS services and permissions are granted
  Future<bool> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Fetches real GPS coordinates and reverse-geocodes to Indian District and State
  Future<UserLocationData?> determinePosition() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        debugPrint('[LocationService] Permission not granted or GPS disabled.');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );

      // Reverse geocode to get District, State and Locality
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final rawState = place.administrativeArea ?? '';
        final rawDistrict = place.subAdministrativeArea?.isNotEmpty == true
            ? place.subAdministrativeArea!
            : (place.locality?.isNotEmpty == true ? place.locality! : 'Patna');

        final cleanState = normalizeStateName(rawState);
        final cleanDist = cleanDistrictName(rawDistrict);
        final subLoc = place.subLocality ?? place.locality;

        return UserLocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          district: cleanDist,
          state: cleanState,
          subLocality: subLoc,
          postalCode: place.postalCode,
          isGpsDetected: true,
        );
      } else {
        return UserLocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          district: 'Patna',
          state: 'Bihar',
          isGpsDetected: true,
        );
      }
    } catch (e) {
      debugPrint('[LocationService] Error determining position: $e');
      return null;
    }
  }
}
