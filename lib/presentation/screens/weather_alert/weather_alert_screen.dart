import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/crop_profile_model.dart';
import '../../../data/models/weather_alert_model.dart';
import '../../../data/services/crop_profile_service.dart';
import '../../../data/services/weather_alert_service.dart';
import '../../widgets/custom_app_bar.dart';

class WeatherAlertScreen extends StatefulWidget {
  const WeatherAlertScreen({super.key});

  @override
  State<WeatherAlertScreen> createState() => _WeatherAlertScreenState();
}

class _WeatherAlertScreenState extends State<WeatherAlertScreen> with SingleTickerProviderStateMixin {
  final WeatherAlertService _alertService = WeatherAlertService();
  final CropProfileService _cropProfileService = CropProfileService();
  final FlutterTts _tts = FlutterTts();

  late TabController _tabController;
  List<CropProfileModel> _farmerCrops = [];
  String? _currentlySpeakingId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initTts();
    _loadFarmerCrops();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setSpeechRate(0.48);
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() {
        if (mounted) {
          setState(() => _currentlySpeakingId = null);
        }
      });
      _tts.setErrorHandler((msg) {
        if (mounted) {
          setState(() => _currentlySpeakingId = null);
        }
      });
    } catch (_) {}
  }

  Future<void> _loadFarmerCrops() async {
    final crops = await _cropProfileService.loadProfiles();
    if (mounted) {
      setState(() {
        _farmerCrops = crops;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleSpeak(WeatherAlertModel alert, bool isHindi) async {
    HapticHelper.lightImpact();
    if (_currentlySpeakingId == alert.id) {
      await _tts.stop();
      setState(() => _currentlySpeakingId = null);
      return;
    }

    await _tts.stop();
    setState(() => _currentlySpeakingId = alert.id);

    try {
      await _tts.setLanguage(isHindi ? 'hi-IN' : 'en-IN');
      final script = isHindi ? alert.audioAdvisoryHindi : alert.audioAdvisoryEnglish;
      await _tts.speak(script);
    } catch (_) {
      if (mounted) {
        setState(() => _currentlySpeakingId = null);
      }
    }
  }

  void _shareAlert(WeatherAlertModel alert, bool isHindi) {
    HapticHelper.lightImpact();
    final buffer = StringBuffer();
    buffer.writeln(isHindi ? '🚨 *एआई कृषि साथी — मौसम व कीट पूर्व-चेतावनी*' : '🚨 *AI Krishi Saathi — Weather Alert*');
    buffer.writeln('');
    buffer.writeln(isHindi ? '*${alert.titleHindi}*' : '*${alert.titleEnglish}*');
    buffer.writeln(isHindi ? 'स्तर: ${alert.severityLabelHindi}' : 'Severity: ${alert.severityLabelEnglish}');
    buffer.writeln('');
    buffer.writeln(isHindi ? 'विवरण: ${alert.conditionSummaryHindi}' : 'Summary: ${alert.conditionSummaryEnglish}');
    buffer.writeln('');
    buffer.writeln(isHindi ? '👉 *क्या करें:*' : '👉 *Recommended Action:*');
    final dos = isHindi ? alert.dosHindi : alert.dosEnglish;
    for (final d in dos) {
      buffer.writeln('• $d');
    }
    buffer.writeln('');
    buffer.writeln(isHindi ? '⚠️ *क्या न करें:*' : '⚠️ *Critical Precautions:*');
    final donts = isHindi ? alert.dontsHindi : alert.dontsEnglish;
    for (final d in donts) {
      buffer.writeln('• $d');
    }
    buffer.writeln('');
    buffer.writeln(isHindi ? 'स्रोत: ICAR Agromet Advisory & IMD Open-Meteo' : 'Source: ICAR Agromet & IMD');

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHindi
              ? 'चेतावनी संदेश कॉपी हो गया! अब साथी किसानों के साथ साझा करें।'
              : 'Alert copied! You can now share it with fellow farmers.',
          style: AppTypography.bodySmall(isHindi: isHindi).copyWith(color: Colors.white, height: 1.4),
        ),
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    final isHindi = lang.isHindi;
    final weather = loc.currentWeather;

    final allAlerts = weather != null
        ? _alertService.generateAlerts(weather, farmerCrops: _farmerCrops)
        : <WeatherAlertModel>[];

    final weatherAlerts = allAlerts.where((a) => a.category == AlertCategory.weather).toList();
    final pestAlerts = allAlerts.where((a) => a.category == AlertCategory.pestDisease).toList();

    final criticalCount = allAlerts.where((a) => a.severity == AlertSeverity.critical).length;
    final warningCount = allAlerts.where((a) => a.severity == AlertSeverity.warning).length;

    return Scaffold(
      appBar: CustomAppBar(
        titleKey: 'weatherAlertsTitle',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refresh_cw, size: 20),
            tooltip: isHindi ? 'ताजा चेतावनी लोड करें' : 'Refresh Alerts',
            onPressed: () async {
              HapticHelper.lightImpact();
              await loc.detectCurrentLocation();
              await _loadFarmerCrops();
            },
          ),
        ],
      ),
      body: _isLoading || loc.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Top Status & Risk Summary Strip
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: criticalCount > 0
                                  ? const Color(0xFFFEF2F2)
                                  : (warningCount > 0 ? const Color(0xFFFFFBEB) : const Color(0xFFF0FDF4)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: criticalCount > 0
                                    ? const Color(0xFFFCA5A5)
                                    : (warningCount > 0 ? const Color(0xFFFCD34D) : const Color(0xFF86EFAC)),
                                width: 1.2,
                              ),
                            ),
                            child: Icon(
                              criticalCount > 0
                                  ? LucideIcons.shield_alert
                                  : (warningCount > 0 ? LucideIcons.triangle_alert : LucideIcons.shield_check),
                              color: criticalCount > 0
                                  ? const Color(0xFFDC2626)
                                  : (warningCount > 0 ? const Color(0xFFD97706) : const Color(0xFF15803D)),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.locationTitle,
                                  style: AppTypography.headingSmall(isHindi: isHindi).copyWith(fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  criticalCount > 0
                                      ? (isHindi
                                          ? '$criticalCount गंभीर चेतावनी सक्रिय हैं! तुरंत सतर्क हों।'
                                          : '$criticalCount Critical Alerts active! Take precautions.')
                                      : (warningCount > 0
                                          ? (isHindi
                                              ? '$warningCount सतर्कता अलर्ट जारी — सुरक्षात्मक उपाय अपनाएं।'
                                              : '$warningCount Warnings active — check recommended actions.')
                                          : (isHindi
                                              ? 'मौसम सामान्य व कृषि कार्यों हेतु पूरी तरह अनुकूल है।'
                                              : 'Weather conditions are favorable for all farm activities.')),
                                  style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                                    color: criticalCount > 0
                                        ? const Color(0xFFDC2626)
                                        : (warningCount > 0 ? const Color(0xFFD97706) : AppColors.primaryDark),
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Tabs for Filtering Categories
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: AppTypography.bodySmall(isHindi: isHindi).copyWith(fontWeight: FontWeight.w700),
                          unselectedLabelStyle: AppTypography.bodySmall(isHindi: isHindi),
                          tabs: [
                            Tab(text: '${lang.tr('filterAll')} (${allAlerts.length})'),
                            Tab(text: '${lang.tr('filterWeather')} (${weatherAlerts.length})'),
                            Tab(text: '${lang.tr('filterPest')} (${pestAlerts.length})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, thickness: 1, color: AppColors.border),

                // Alert Cards List View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAlertsList(allAlerts, isHindi),
                      _buildAlertsList(weatherAlerts, isHindi),
                      _buildAlertsList(pestAlerts, isHindi),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAlertsList(List<WeatherAlertModel> alerts, bool isHindi) {
    if (alerts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.circle_check, size: 48, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                isHindi ? 'कोई सक्रिय चेतावनी नहीं है' : 'No Active Alerts in this Category',
                style: AppTypography.headingSmall(isHindi: isHindi),
              ),
              const SizedBox(height: 6),
              Text(
                isHindi ? 'मौसम सामान्य व कृषि के अनुकूल बना हुआ है।' : 'All conditions are within safe agronomic parameters.',
                style: AppTypography.bodySmall(isHindi: isHindi).copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        final isRelevant = _alertService.isRelevantToFarmer(alert, _farmerCrops);
        final isSpeaking = _currentlySpeakingId == alert.id;

        return _buildAlertCard(alert, isRelevant, isSpeaking, isHindi)
            .animate()
            .fadeIn(duration: 250.ms, delay: (index * 60).ms)
            .slideY(begin: 0.04, end: 0);
      },
    );
  }

  Widget _buildAlertCard(WeatherAlertModel alert, bool isRelevant, bool isSpeaking, bool isHindi) {
    final title = isHindi ? alert.titleHindi : alert.titleEnglish;
    final summary = isHindi ? alert.conditionSummaryHindi : alert.conditionSummaryEnglish;
    final crops = isHindi ? alert.affectedCropsHindi : alert.affectedCropsEnglish;
    final dos = isHindi ? alert.dosHindi : alert.dosEnglish;
    final donts = isHindi ? alert.dontsHindi : alert.dontsEnglish;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert.severity == AlertSeverity.critical
              ? const Color(0xFFFCA5A5)
              : (alert.severity == AlertSeverity.warning
                  ? const Color(0xFFFCD34D)
                  : (alert.severity == AlertSeverity.safe ? const Color(0xFF86EFAC) : AppColors.border)),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Severity Tag, Category & Farmer Crop Match Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: alert.severityBgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(alert.icon, color: alert.severityColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: alert.severityColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: alert.severityColor.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Text(
                          isHindi ? alert.severityLabelHindi : alert.severityLabelEnglish,
                          style: AppTypography.bodySmall().copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: alert.severityColor,
                          ),
                        ),
                      ),
                      if (isRelevant) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.3), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.sprout, size: 12, color: AppColors.primaryDark),
                              const SizedBox(width: 4),
                              Text(
                                isHindi ? 'आपकी फसल' : 'Your Crop',
                                style: AppTypography.bodySmall().copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  alert.category == AlertCategory.weather
                      ? (isHindi ? 'मौसम' : 'Weather')
                      : (isHindi ? 'कीट व रोग' : 'Pest/Disease'),
                  style: AppTypography.bodySmall().copyWith(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Title & Condition Summary
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headingSmall(isHindi: isHindi).copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary,
                  style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Affected Crops Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Text(
                      isHindi ? 'प्रभावित फसलें:' : 'Affected:',
                      style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    ...crops.map(
                      (c) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Text(
                          c,
                          style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // "क्या करें" (Dos) Section
                if (dos.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.circle_check, size: 16, color: Color(0xFF15803D)),
                            const SizedBox(width: 6),
                            Text(
                              isHindi ? 'क्या करें (अनुशंसित उपाय):' : 'What to Do (Recommended Actions):',
                              style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF15803D),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...dos.map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                                      fontSize: 12.5,
                                      color: const Color(0xFF14532D),
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // "क्या न करें" (Don'ts) Section
                if (donts.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFECACA), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.circle_x, size: 16, color: Color(0xFFDC2626)),
                            const SizedBox(width: 6),
                            Text(
                              isHindi ? 'क्या न करें (महत्वपूर्ण सावधानी):' : 'What NOT to Do (Avoid):',
                              style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFDC2626),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...donts.map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                                      fontSize: 12.5,
                                      color: const Color(0xFF7F1D1D),
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Action Bar: Audio TTS & Share
                Row(
                  children: [
                    // TTS Audio Playback Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          backgroundColor: isSpeaking ? AppColors.primaryContainer : Colors.white,
                          side: BorderSide(
                            color: isSpeaking ? AppColors.primary : AppColors.border,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _toggleSpeak(alert, isHindi),
                        icon: Icon(
                          isSpeaking ? LucideIcons.volume_x : LucideIcons.volume_2,
                          size: 18,
                          color: isSpeaking ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                        label: Text(
                          isSpeaking
                              ? (isHindi ? 'ऑडियो रोकें' : 'Stop Audio')
                              : (isHindi ? 'अलर्ट सुनें' : 'Listen Alert'),
                          style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSpeaking ? AppColors.primaryDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Farmer Share Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        backgroundColor: const Color(0xFFF0FDF4),
                        side: const BorderSide(color: Color(0xFF86EFAC), width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _shareAlert(alert, isHindi),
                      icon: const Icon(LucideIcons.share_2, size: 18, color: Color(0xFF15803D)),
                      label: Text(
                        isHindi ? 'शेयर' : 'Share',
                        style: AppTypography.bodySmall(isHindi: isHindi).copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
