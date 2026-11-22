class AppConstants {
  static const String appName = 'AI Krishi Saathi';
  static const String appVersion = '1.0.0 (Prototype)';
  static const String developer = 'Kamlesh Yadav';
  static const String institution = 'Birla Institute of Technology (BIT), Mesra — Patna Campus';
  static const String programme = 'B.Tech — Computer Science and Engineering';

  // API Endpoints & Defaults
  static const String geminiModel = 'gemini-3-flash-preview';
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY',
  );
  static const String geminiApiKeyPlaceholder = 'YOUR_GEMINI_API_KEY';
  static const String supabaseUrl = 'https://kajibfzadfzfxborexsn.supabase.co';
  static const String supabaseUrlPlaceholder = 'https://xyzcompany.supabase.co';
  static const String supabasePublishableKey = 'sb_publishable_MI0Pqo0xIiAVwnYrt7AeBA_T_FUkogT';
  static const String supabaseAnonKey = 'sb_publishable_MI0Pqo0xIiAVwnYrt7AeBA_T_FUkogT';
  static const String supabaseAnonKeyPlaceholder = 'YOUR_SUPABASE_ANON_KEY';

  // Disclaimer text
  static const String legalDisclaimer =
      'AI Krishi Saathi is an academic prototype developed for Indian farmers. '
      'Recommendations are provided as decision support and should not replace '
      'consultation with agricultural extension officers or certified KVK specialists.';
}
