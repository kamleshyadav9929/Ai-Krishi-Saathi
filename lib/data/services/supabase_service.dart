import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/crop_disease_model.dart';
import '../models/farm_record_model.dart';
import '../../core/constants/app_constants.dart';

class SupabaseService {
  static bool _isInitialized = false;

  static bool get isConfigured => _isInitialized;

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

  /// Synchronizes a farm expense record to cloud
  Future<bool> saveFarmExpense(FarmExpenseItem expense) async {
    if (!_isInitialized) return true;
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('farm_expenses').insert(expense.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fetches saved farm expenses from cloud
  Future<List<FarmExpenseItem>> fetchFarmExpenses() async {
    if (!_isInitialized) return [];
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('farm_expenses')
          .select()
          .order('date', ascending: false)
          .limit(50);
      return (response as List<dynamic>)
          .map((item) => FarmExpenseItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Synchronizes farmer profile data
  Future<bool> updateFarmerProfile({
    required String name,
    required String phone,
    required String state,
    required String district,
    required double landAcres,
  }) async {
    if (!_isInitialized) return true;
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('farmer_profiles').upsert({
        'phone': phone,
        'name': name,
        'state': state,
        'district': district,
        'land_acres': landAcres,
        'updated_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
