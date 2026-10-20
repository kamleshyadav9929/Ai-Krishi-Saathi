import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/crop_profile_model.dart';
import '../../../data/services/crop_profile_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../voice_assistant/voice_assistant_sheet.dart';

class CropProfileScreen extends StatefulWidget {
  const CropProfileScreen({super.key});

  @override
  State<CropProfileScreen> createState() => _CropProfileScreenState();
}

class _CropProfileScreenState extends State<CropProfileScreen> {
  final CropProfileService _service = CropProfileService();
  List<CropProfileModel> _profiles = [];
  CropProfileModel? _activeProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() => _isLoading = true);
    final list = await _service.loadProfiles();
    final activeId = await _service.getActiveProfileId();

    CropProfileModel? selected;
    if (list.isNotEmpty) {
      selected = list.firstWhere((p) => p.id == activeId, orElse: () => list.first);
    }

    if (!mounted) return;
    setState(() {
      _profiles = list;
      _activeProfile = selected;
      _isLoading = false;
    });
  }

  Future<void> _showAddProfileDialog(BuildContext context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    final cropController = TextEditingController(text: 'गेहूं (Wheat)');
    final varietyController = TextEditingController(text: 'HD 2967');
    final plotController = TextEditingController(text: lang.isHindi ? 'नहर वाला खेत' : 'North Field');
    final acreController = TextEditingController(text: '2.0');
    final soilController = TextEditingController(text: lang.isHindi ? 'दोमट मिट्टी' : 'Alluvial Loam');
    final waterController = TextEditingController(text: lang.isHindi ? 'नलकूप / ट्यूबवेल' : 'Tubewell');
    DateTime sowingDate = DateTime.now().subtract(const Duration(days: 20));

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.isHindi ? 'नयी फसल प्रोफ़ाइल जोड़ें' : 'Create Crop Profile',
                        style: AppTypography.headingSmall(isHindi: lang.isHindi),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(LucideIcons.x, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: cropController,
                    decoration: InputDecoration(
                      labelText: lang.isHindi ? 'फसल का नाम (Crop Name)' : 'Crop Name',
                      prefixIcon: const Icon(LucideIcons.sprout, size: 18, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: varietyController,
                          decoration: InputDecoration(
                            labelText: lang.isHindi ? 'किस्म / वैरायटी (Variety)' : 'Variety',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: acreController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: lang.isHindi ? 'रकबा (एकड़)' : 'Area (Acres)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: plotController,
                    decoration: InputDecoration(
                      labelText: lang.isHindi ? 'खेत का नाम / पहचान (Plot Name)' : 'Plot Name / Field ID',
                      prefixIcon: const Icon(LucideIcons.map_pin, size: 18, color: AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sowing Date Picker Tile
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: sowingDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 200)),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() => sowingDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                lang.isHindi ? 'बुवाई की तिथि:' : 'Sowing Date:',
                                style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${sowingDate.day}/${sowingDate.month}/${sowingDate.year}',
                            style: AppTypography.bodyMedium().copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: soilController,
                          decoration: InputDecoration(
                            labelText: lang.isHindi ? 'मिट्टी (Soil)' : 'Soil Type',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: waterController,
                          decoration: InputDecoration(
                            labelText: lang.isHindi ? 'सिंचाई साधन' : 'Water Source',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final cropName = cropController.text.trim();
                        if (cropName.isEmpty) return;

                        final newProfile = CropProfileModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          cropName: cropName,
                          cropNameHindi: cropName,
                          variety: varietyController.text.trim(),
                          plotName: plotController.text.trim(),
                          acres: double.tryParse(acreController.text.trim()) ?? 1.0,
                          sowingDate: sowingDate,
                          soilType: soilController.text.trim(),
                          irrigationSource: waterController.text.trim(),
                          activities: [
                            CropActivityLog(
                              id: 'sow-${DateTime.now().millisecondsSinceEpoch}',
                              date: sowingDate,
                              type: ActivityType.sowing,
                              title: 'बीज बुवाई व प्राथमिक जुताई',
                              description: 'प्रमाणित बीज ${varietyController.text} की बुवाई की गई। आधार खाद डाली गई।',
                              cost: 3500,
                            ),
                          ],
                        );

                        await _service.addOrUpdateProfile(newProfile);
                        await _service.setActiveProfileId(newProfile.id);
                        if (ctx.mounted) Navigator.pop(ctx);
                        _loadProfiles();
                      },
                      icon: const Icon(LucideIcons.check, size: 18),
                      label: Text(lang.isHindi ? 'फसल प्रोफ़ाइल सहेजें' : 'Save Crop Profile'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddActivityDialog(BuildContext context, CropProfileModel profile) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    ActivityType selectedType = ActivityType.irrigation;
    final titleController = TextEditingController(text: lang.isHindi ? 'पहली सिंचाई (CRI Stage)' : '1st Irrigation');
    final descController = TextEditingController(
      text: lang.isHindi ? 'खेत में पानी लगाया और 25 kg यूरिया प्रति एकड़ डाला।' : 'Irrigated field and applied urea top-dress.',
    );
    final costController = TextEditingController(text: '800');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.isHindi ? 'फसल डायरी में कार्य दर्ज करें' : 'Log Farm Activity',
                        style: AppTypography.headingSmall(isHindi: lang.isHindi),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(LucideIcons.x, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<ActivityType>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: lang.isHindi ? 'कार्य का प्रकार' : 'Activity Type',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ActivityType.values.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          selectedType = val;
                          if (val == ActivityType.fertilizer) {
                            titleController.text = lang.isHindi ? 'यूरिया / DAP खाद छिड़काव' : 'Fertilizer Top Dress';
                          } else if (val == ActivityType.spray) {
                            titleController.text = lang.isHindi ? 'कीटनाशक / दवा स्प्रे' : 'Pesticide Spray';
                          } else if (val == ActivityType.weeding) {
                            titleController.text = lang.isHindi ? 'निराई-गुड़ाई व खरपतवार' : 'Weeding & Hoeing';
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: lang.isHindi ? 'शीर्षक (Title)' : 'Title',
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: lang.isHindi ? 'विवरण (Description)' : 'Description',
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: costController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lang.isHindi ? 'लागत (₹ Cost)' : 'Cost (₹)',
                      prefixText: '₹ ',
                    ),
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final title = titleController.text.trim();
                        if (title.isEmpty) return;

                        final activity = CropActivityLog(
                          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
                          date: DateTime.now(),
                          type: selectedType,
                          title: title,
                          description: descController.text.trim(),
                          cost: double.tryParse(costController.text.trim()) ?? 0.0,
                        );

                        await _service.addActivity(profile.id, activity);
                        if (ctx.mounted) Navigator.pop(ctx);
                        _loadProfiles();
                      },
                      icon: const Icon(LucideIcons.check, size: 18),
                      label: Text(lang.isHindi ? 'डायरी में जोड़ें' : 'Log Activity'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        titleKey: lang.isHindi ? 'मेरी फसल प्रोफ़ाइल' : 'My Crop Profile',
        showLanguageToggle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _profiles.isEmpty
              ? _buildEmptyState(context)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Switcher row if multiple profiles
                      if (_profiles.length > 1) ...[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _profiles.map((p) {
                              final isSelected = p.id == _activeProfile?.id;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text('${p.cropNameHindi} (${p.plotName})'),
                                  selected: isSelected,
                                  selectedColor: AppColors.primary,
                                  backgroundColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _activeProfile = p);
                                      _service.setActiveProfileId(p.id);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Main Active Crop Profile Card
                      if (_activeProfile != null) ...[
                        _buildProfileHeroCard(context, _activeProfile!),
                        const SizedBox(height: 16),

                        // Action Buttons: Ask AI about this crop & Add Activity
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticHelper.mediumImpact();
                                  VoiceAssistantSheet.show(
                                    context,
                                    customContext: _service.buildAIContext(_activeProfile!),
                                    initialQuery: lang.isHindi
                                        ? 'मेरी ${_activeProfile!.cropNameHindi} की फसल के लिए आज क्या सलाह है?'
                                        : 'What is the advice for my ${_activeProfile!.cropName} today?',
                                  );
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF15803D),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF15803D).withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(LucideIcons.sparkles, size: 16, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        lang.isHindi ? 'फसल AI से पूछें' : 'Ask Crop AI',
                                        style: AppTypography.bodySmall().copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () => _showAddActivityDialog(context, _activeProfile!),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(LucideIcons.circle_plus, size: 16, color: Color(0xFF15803D)),
                                      const SizedBox(width: 8),
                                      Text(
                                        lang.isHindi ? 'कार्य दर्ज करें' : 'Log Activity',
                                        style: AppTypography.bodySmall().copyWith(
                                          color: const Color(0xFF15803D),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Field Diary / Activities Timeline
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.isHindi ? 'फसल डायरी (Field Activity Log)' : 'Field Activity Diary',
                              style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                              ),
                              child: Text(
                                lang.isHindi
                                    ? 'कुल खर्च: ₹${_activeProfile!.totalInvestment.toInt()}'
                                    : 'Cost: ₹${_activeProfile!.totalInvestment.toInt()}',
                                style: AppTypography.bodySmall().copyWith(
                                  color: const Color(0xFF15803D),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (_activeProfile!.activities.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                lang.isHindi
                                    ? 'अभी कोई कार्य दर्ज नहीं है। ऊपर "कार्य दर्ज करें" पर टैप करें।'
                                    : 'No farm operations logged yet. Tap "Log Activity" above.',
                                style: AppTypography.bodySmall(isHindi: lang.isHindi),
                              ),
                            ),
                          )
                        else
                          ..._activeProfile!.activities.map(
                            (act) => _buildActivityCard(context, act),
                          ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProfileDialog(context),
        backgroundColor: const Color(0xFF15803D),
        tooltip: lang.isHindi ? 'नयी फसल प्रोफ़ाइल जोड़ें' : 'Add Crop Profile',
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.sprout, size: 48, color: Color(0xFF15803D)),
            ),
            const SizedBox(height: 20),
            Text(
              lang.isHindi ? 'कोई फसल प्रोफ़ाइल नहीं है' : 'No Crop Profiles Yet',
              style: AppTypography.headingMedium(isHindi: lang.isHindi),
            ),
            const SizedBox(height: 8),
            Text(
              lang.isHindi
                  ? 'अपनी फसल का नाम, खेत, बुवाई तारीख और किस्म दर्ज करें। AI आपकी फसल के अनुसार हर दिन सटीक सलाह देगा।'
                  : 'Add your crop, field area, variety and sowing date to get personalized AI agronomy recommendations.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddProfileDialog(context),
              icon: const Icon(LucideIcons.plus, size: 20),
              label: Text(lang.isHindi ? 'पहली फसल प्रोफ़ाइल बनाएं' : 'Create First Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeroCard(BuildContext context, CropProfileModel profile) {
    final lang = Provider.of<LanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                    ),
                    child: const Icon(LucideIcons.sprout, size: 22, color: Color(0xFF15803D)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.cropNameHindi,
                        style: AppTypography.headingMedium(isHindi: lang.isHindi).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'किस्म: ${profile.variety} • ${profile.acres} एकड़',
                        style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF15803D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${profile.currentDas} DAS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  label: lang.isHindi ? 'खेत का नाम' : 'Plot',
                  value: profile.plotName,
                  icon: LucideIcons.map_pin,
                ),
                _buildInfoColumn(
                  label: lang.isHindi ? 'बुवाई तिथि' : 'Sown On',
                  value: '${profile.sowingDate.day}/${profile.sowingDate.month}',
                  icon: LucideIcons.calendar,
                ),
                _buildInfoColumn(
                  label: lang.isHindi ? 'सिंचाई साधन' : 'Water',
                  value: profile.irrigationSource,
                  icon: LucideIcons.droplets,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: const Color(0xFF15803D)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildActivityCard(BuildContext context, CropActivityLog activity) {
    IconData icon;
    Color iconColor;

    switch (activity.type) {
      case ActivityType.sowing:
        icon = LucideIcons.sprout;
        iconColor = const Color(0xFF15803D);
        break;
      case ActivityType.irrigation:
        icon = LucideIcons.droplets;
        iconColor = const Color(0xFF0284C7);
        break;
      case ActivityType.fertilizer:
        icon = LucideIcons.flask_conical;
        iconColor = const Color(0xFFD97706);
        break;
      case ActivityType.spray:
        icon = LucideIcons.shield_alert;
        iconColor = const Color(0xFFDC2626);
        break;
      case ActivityType.weeding:
        icon = LucideIcons.scissors;
        iconColor = const Color(0xFF7C3AED);
        break;
      case ActivityType.harvest:
        icon = LucideIcons.circle_check;
        iconColor = const Color(0xFF15803D);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    if (activity.cost > 0)
                      Text(
                        '₹${activity.cost.toInt()}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activity.date.day}/${activity.date.month}/${activity.date.year} • ${activity.typeHindi}',
                  style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
