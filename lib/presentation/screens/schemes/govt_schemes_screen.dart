import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/govt_scheme_model.dart';
import '../../../data/services/govt_schemes_service.dart';
import '../../widgets/custom_app_bar.dart';

class GovtSchemesScreen extends StatefulWidget {
  const GovtSchemesScreen({super.key});

  @override
  State<GovtSchemesScreen> createState() => _GovtSchemesScreenState();
}

class _GovtSchemesScreenState extends State<GovtSchemesScreen> {
  final GovtSchemesService _service = GovtSchemesService();
  String _selectedCategory = 'सभी योजनाएं';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final categories = _service.getCategories(isHindi: lang.isHindi);
    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

    final schemes = _service.filterSchemes(
      category: _selectedCategory,
      searchQuery: _searchQuery,
    );

    return Scaffold(
      appBar: CustomAppBar(
        titleKey: lang.isHindi ? 'सरकारी योजनाएं व सब्सिडी' : 'Govt Schemes & Subsidies',
        showLanguageToggle: false,
      ),
      body: Column(
        children: [
          // Visual Hero Banner (Lush Farmer & Govt Schemes Illustration)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15803D).withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/govt_schemes_hero.png',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.76),
                            Colors.black.withValues(alpha: 0.38),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lang.isHindi ? 'प्रत्यक्ष लाभ अंतरण (DBT)' : 'Direct Benefit Transfer',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lang.isHindi
                                ? 'पीएम-किसान, सोलर पंप\nव कृषि यंत्र सब्सिडी'
                                : 'PM-Kisan, Solar Pump\n& Farm Subsidies',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.isHindi
                                ? 'पात्रता जांचें और सीधे पोर्टल से आवेदन करें'
                                : 'Check eligibility & apply directly via official portals',
                            style: const TextStyle(
                              color: Color(0xFFDCFCE7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3-Step Scheme Application Visual Guide
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(LucideIcons.circle_check, size: 13, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            lang.isHindi ? '1. पात्रता' : '1. Eligibility',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('•', style: TextStyle(color: Color(0xFF22C55E))),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(LucideIcons.file_text, size: 13, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            lang.isHindi ? '2. कागज़ात' : '2. Documents',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('•', style: TextStyle(color: Color(0xFF22C55E))),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(LucideIcons.external_link, size: 13, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            lang.isHindi ? '3. आवेदन' : '3. Apply',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search & Filter Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: lang.isHindi
                        ? 'योजना खोजें (जैसे: सोलर पंप, बीमा, किसान क्रेडिट)...'
                        : 'Search schemes (e.g. Solar pump, insurance, KCC)...',
                    prefixIcon: const Icon(LucideIcons.search, size: 20, color: AppColors.primary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 10),

                // Category Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            HapticHelper.lightTap();
                            setState(() => _selectedCategory = cat);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF15803D) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF15803D).withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              cat,
                              style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Schemes List
          Expanded(
            child: schemes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.search_x, size: 40, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            lang.isHindi
                                ? 'कोई योजना नहीं मिली। कृपया अन्य शब्द लिखकर खोजें।'
                                : 'No schemes matched your search criteria.',
                            style: AppTypography.bodyMedium(isHindi: lang.isHindi).copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    physics: const BouncingScrollPhysics(),
                    itemCount: schemes.length,
                    itemBuilder: (context, index) {
                      return _buildSchemeCard(context, schemes[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, GovtSchemeModel scheme) {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final title = lang.isHindi ? scheme.titleHindi : scheme.title;
    final benefit = lang.isHindi ? scheme.benefitHindi : scheme.benefit;
    final eligibility = lang.isHindi ? scheme.eligibilityHindi : scheme.eligibility;
    final docs = lang.isHindi ? scheme.requiredDocumentsHindi : scheme.requiredDocuments;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
          // Category Badge & Verified Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                ),
                child: Text(
                  lang.isHindi ? scheme.categoryHindi : scheme.category,
                  style: AppTypography.bodySmall().copyWith(
                    color: const Color(0xFF15803D),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.shield_check, size: 13, color: Color(0xFF15803D)),
                    SizedBox(width: 4),
                    Text(
                      'Govt Verified',
                      style: TextStyle(
                        color: Color(0xFF15803D),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Scheme Title
          Text(
            title,
            style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          // Financial Benefit Highlight Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                left: BorderSide(color: Color(0xFFF59E0B), width: 3.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.sparkles, size: 16, color: Color(0xFFD97706)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    benefit,
                    style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                      color: const Color(0xFF92400E),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Eligibility
          Text(
            lang.isHindi ? 'पात्रता (Eligibility):' : 'Eligibility:',
            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            eligibility,
            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),

          // Required Documents
          Text(
            lang.isHindi ? 'आवश्यक दस्तावेज (Required Documents):' : 'Required Documents:',
            style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          ...docs.map(
            (doc) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(LucideIcons.check, size: 13, color: Color(0xFF15803D)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      doc,
                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Official Portal Action Pill Button
          Row(
            children: [
              Expanded(
                child: Text(
                  scheme.portalUrl,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  HapticHelper.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang.isHindi
                            ? 'आधिकारिक पोर्टल लिंक: ${scheme.portalUrl}'
                            : 'Official Portal: ${scheme.portalUrl}',
                      ),
                      backgroundColor: const Color(0xFF15803D),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.external_link, size: 13, color: Color(0xFF15803D)),
                      const SizedBox(width: 5),
                      Text(
                        lang.isHindi ? 'सरकारी पोर्टल' : 'Official Portal',
                        style: AppTypography.bodySmall().copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
