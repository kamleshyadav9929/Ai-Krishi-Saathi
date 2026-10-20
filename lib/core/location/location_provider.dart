import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/location_service.dart';
import '../../data/services/weather_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  bool _isLoading = false;
  bool _isGpsDetected = false;
  String _currentDistrict = 'Patna';
  String _currentState = 'Bihar';
  String? _subLocality;
  double? _latitude;
  double? _longitude;
  WeatherModel? _currentWeather;
  String? _statusMessage;

  bool get isLoading => _isLoading;
  bool get isGpsDetected => _isGpsDetected;
  String get currentDistrict => _currentDistrict;
  String get currentState => _currentState;
  String? get subLocality => _subLocality;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  WeatherModel? get currentWeather => _currentWeather;
  String? get statusMessage => _statusMessage;

  String get locationTitle {
    if (_subLocality != null && _subLocality!.isNotEmpty && _subLocality != _currentDistrict) {
      return '$_subLocality, $_currentDistrict';
    }
    return '$_currentDistrict, $_currentState';
  }

  /// Initialize: Load saved preference, then trigger auto GPS detection
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _currentDistrict = prefs.getString('user_district') ?? 'Patna';
      _currentState = prefs.getString('user_state') ?? 'Bihar';
      _subLocality = prefs.getString('user_sublocality');
      _latitude = prefs.getDouble('user_lat');
      _longitude = prefs.getDouble('user_lon');
      _isGpsDetected = prefs.getBool('user_is_gps') ?? false;

      // Load initial weather for cached location
      _currentWeather = await _weatherService.fetchCurrentWeather(
        district: _currentDistrict,
        latitude: _latitude,
        longitude: _longitude,
        locationDisplayName: locationTitle,
      );
    } catch (_) {}

    _isLoading = false;
    notifyListeners();

    // Auto-detect live GPS location in background
    await detectCurrentLocation();
  }

  /// Explicitly detect live GPS location and update weather & mandi references
  Future<bool> detectCurrentLocation() async {
    _isLoading = true;
    _statusMessage = 'GPS लोकेशन खोजी जा रही है...';
    notifyListeners();

    try {
      final locData = await _locationService.determinePosition();

      if (locData != null) {
        _latitude = locData.latitude;
        _longitude = locData.longitude;
        _currentDistrict = locData.district;
        _currentState = locData.state;
        _subLocality = locData.subLocality;
        _isGpsDetected = true;
        _statusMessage = 'लोकेशन सफलतापूर्वक मिल गई!';

        // Save to SharedPreferences for offline persistence
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_district', _currentDistrict);
        await prefs.setString('user_state', _currentState);
        if (_subLocality != null) {
          await prefs.setString('user_sublocality', _subLocality!);
        }
        await prefs.setDouble('user_lat', _latitude!);
        await prefs.setDouble('user_lon', _longitude!);
        await prefs.setBool('user_is_gps', true);

        // Fetch live micro-weather for these exact GPS coordinates
        _currentWeather = await _weatherService.fetchCurrentWeather(
          district: _currentDistrict,
          latitude: _latitude,
          longitude: _longitude,
          locationDisplayName: locationTitle,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _statusMessage = 'GPS अनुमति नहीं मिली या सिग्नल कमजोर है';
      }
    } catch (e) {
      _statusMessage = 'लोकेशन प्राप्त करने में समस्या';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Manually set State & District if farmer wants to inspect another region
  Future<void> setManualLocation({
    required String state,
    required String district,
  }) async {
    _currentState = state;
    _currentDistrict = district;
    _subLocality = null;
    _isGpsDetected = false;
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_district', district);
    await prefs.setString('user_state', state);
    await prefs.remove('user_sublocality');
    await prefs.setBool('user_is_gps', false);

    _currentWeather = await _weatherService.fetchCurrentWeather(
      district: district,
      locationDisplayName: '$district, $state',
    );

    _isLoading = false;
    notifyListeners();
  }
}
