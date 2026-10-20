import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/crop_disease_model.dart';
import '../../core/constants/app_constants.dart';

class SupabaseService {
  static bool _isInitialized = false;

  static Future<void> initialize({
    String url = AppConstants.supabaseUrl,
    String anonKey = AppConstants.supabaseAnonKey,
  }) async {
    if (_isInitialized) return;
    if (url == AppConstants.supabaseUrlPlaceholder ||
        anonKey.isEmpty ||
        anonKey == AppConstants.supabaseAnonKeyPlaceholder) {
      // In offline/prototype mode without credentials, keep service ready in local mode
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: anonKey,
      );
      _isInitialized = true;
    } catch (_) {
      // Keep running locally
    }
  }

  /// Saves a leaf scan record to Supabase database
  Future<bool> saveScanRecord(CropDiseaseModel scan) async {
    if (!_isInitialized) return true; // Local prototype simulation
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('crop_diagnoses').insert(scan.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
}
