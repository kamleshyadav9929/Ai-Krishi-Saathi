import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class AgriProductItem {
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

  const AgriProductItem({
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
}

class AgriProductsScreen extends StatefulWidget {
  const AgriProductsScreen({super.key});

  @override
  State<AgriProductsScreen> createState() => _AgriProductsScreenState();
}

class _AgriProductsScreenState extends State<AgriProductsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<AgriProductItem> _products = const [
    AgriProductItem(
      id: 'p1',
      name: 'Bayer Confidor 200 SL',
      brand: 'Bayer CropScience',
      chemicalName: 'Imidacloprid 17.8% SL',
      category: 'Insecticide',
      categoryHindi: 'कीटनाशक',
      targetPests: 'माहू (Aphids), सफेद मक्खी, हरा तेला (Jassids), थ्रिप्स',
      targetCrops: 'गेहूं, सरसों, कपास, धान, मिर्च, टमाटर',
      dosagePer15LTank: '5 - 7.5 मिली',
      dosagePerAcre: '50 - 75 मिली / 150 लीटर पानी',
      phiDays: '21 दिन',
      badgeColor: Color(0xFF15803D),
    ),
    AgriProductItem(
      id: 'p2',
      name: 'Bayer Nativo 75 WG',
      brand: 'Bayer CropScience',
      chemicalName: 'Tebuconazole 50% + Trifloxystrobin 25% WG',
      category: 'Fungicide',
      categoryHindi: 'फफूंदनाशक',
      targetPests: 'पीला रतुआ (Yellow Rust), शीथ ब्लाइट, झुलसा रोग (Blight)',
      targetCrops: 'गेहूं, धान, टमाटर, मिर्च, आम',
      dosagePer15LTank: '12 - 15 ग्राम',
      dosagePerAcre: '120 - 150 ग्राम / 150 लीटर पानी',
      phiDays: '15 दिन',
      badgeColor: Color(0xFF0284C7),
    ),
    AgriProductItem(
      id: 'p3',
      name: 'Bayer Regent 0.3 GR',
      brand: 'Bayer CropScience',
      chemicalName: 'Fipronil 0.3% GR (Granules)',
      category: 'Insecticide',
      categoryHindi: 'दानेदार कीटनाशक',
      targetPests: 'तना छेदक (Stem Borer), दीमक, पत्ती लपेटक',
      targetCrops: 'धान, गन्ना, गेहूं, मक्का',
      dosagePer15LTank: 'खेत में भुरकाव (Broadcasting)',
      dosagePerAcre: '7.5 - 10 किलोग्राम प्रति एकड़',
      phiDays: '32 दिन',
      badgeColor: Color(0xFFD97706),
    ),
    AgriProductItem(
      id: 'p4',
      name: 'Bayer Decis 2.8 EC',
      brand: 'Bayer CropScience',
      chemicalName: 'Deltamethrin 2.8% EC',
      category: 'Insecticide',
      categoryHindi: 'कीटनाशक',
      targetPests: 'इल्ली (Bollworm, Caterpillars), फल छेदक कीट',
      targetCrops: 'कपास, चना, सरसों, बैंगन, भिंडी',
      dosagePer15LTank: '15 - 20 मिली',
      dosagePerAcre: '150 - 200 मिली / 150 लीटर पानी',
      phiDays: '14 दिन',
      badgeColor: Color(0xFFDC2626),
    ),
    AgriProductItem(
      id: 'p5',
      name: 'IFFCO Nano Urea Plus (Liquid)',
      brand: 'IFFCO',
      chemicalName: 'Nano Nitrogen (4.0% w/v liquid)',
      category: 'Fertilizer',
      categoryHindi: 'तरल नैनो उर्वरक',
      targetPests: 'पौधों में नाइट्रोजन की कमी, कल्ले व हरियाली विकास',
      targetCrops: 'सभी खाद्यान्न, दलहन व तिलहन फसलें',
      dosagePer15LTank: '30 - 40 मिली',
      dosagePerAcre: '500 मिली (1 बोतल) / एकड़',
      phiDays: 'सुरक्षित (0 दिन)',
      badgeColor: Color(0xFF059669),
    ),
    AgriProductItem(
      id: 'p6',
      name: 'Bayer Ambition (Bio-Stimulant)',
      brand: 'Bayer CropScience',
      chemicalName: 'Amino Acids + Fulvic Acid + Microelements',
      category: 'Growth Booster',
      categoryHindi: 'फसल वृद्धि वर्धक',
      targetPests: 'फूल-फल झड़ने से बचाव, तनाव सहनशीलता, पैदावार वृद्धि',
      targetCrops: 'सब्जियां, फल, गेहूं, धान, दलहन',
      dosagePer15LTank: '30 - 35 मिली',
      dosagePerAcre: '300 - 350 मिली / 150 लीटर पानी',
      phiDays: 'सुरक्षित (जैविक)',
      badgeColor: Color(0xFF7C3AED),
    ),
  ];

  List<AgriProductItem> get _filteredProducts {
    return _products.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.chemicalName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.targetCrops.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.targetPests.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _showProductDetail(AgriProductItem p, bool isHindi) {
    HapticHelper.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: p.badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(LucideIcons.package_check, color: p.badgeColor, size: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          p.chemicalName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(isHindi ? 'श्रेणी' : 'Category', isHindi ? p.categoryHindi : p.category),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    _buildInfoRow(isHindi ? 'लक्षित कीट/रोग' : 'Target Pests', p.targetPests),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    _buildInfoRow(isHindi ? 'अनुशंसित फसलें' : 'Target Crops', p.targetCrops),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    _buildInfoRow(isHindi ? '15L स्प्रे पंप डोज' : '15L Tank Dose', p.dosagePer15LTank, isHighlight: true),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    _buildInfoRow(isHindi ? 'प्रति एकड़ मात्रा' : 'Per Acre Dose', p.dosagePerAcre),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    _buildInfoRow(isHindi ? 'सुरक्षा तुड़ाई अंतर (PHI)' : 'Safety Waiting (PHI)', p.phiDays),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
              color: isHighlight ? const Color(0xFF15803D) : const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isHindi = lang.isHindi;

    final categories = [
      {'key': 'All', 'label': isHindi ? 'सभी' : 'All'},
      {'key': 'Insecticide', 'label': isHindi ? 'कीटनाशक' : 'Insecticide'},
      {'key': 'Fungicide', 'label': isHindi ? 'फफूंदनाशक' : 'Fungicide'},
      {'key': 'Fertilizer', 'label': isHindi ? 'उर्वरक व खाद' : 'Fertilizer'},
      {'key': 'Growth Booster', 'label': isHindi ? 'वृद्धि वर्धक' : 'Boosters'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: CustomAppBar(titleKey: isHindi ? 'bayerProducts' : 'bayerProducts'),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: isHindi ? 'उत्पाद, दवा या कीट का नाम खोजें...' : 'Search chemical, product or pest...',
                  hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Categories Horizontal Bar
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (ctx, idx) {
                final cat = categories[idx];
                final isSelected = _selectedCategory == cat['key'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      cat['label']!,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      HapticHelper.lightTap();
                      setState(() => _selectedCategory = cat['key']!);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF15803D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Products List
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              itemCount: _filteredProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, idx) {
                final product = _filteredProducts[idx];
                return BouncyTap(
                  onTap: () => _showProductDetail(product, isHindi),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: product.badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Icon(LucideIcons.flask_conical, color: product.badgeColor, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.chemicalName,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isHindi ? product.categoryHindi : product.category,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF15803D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '15L डोज: ${product.dosagePer15LTank}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevron_right, size: 18, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
