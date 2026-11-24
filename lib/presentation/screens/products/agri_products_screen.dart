import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/agri_product_model.dart';
import '../../../data/services/agri_product_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class AgriProductsScreen extends StatefulWidget {
  const AgriProductsScreen({super.key});

  @override
  State<AgriProductsScreen> createState() => _AgriProductsScreenState();
}

class _AgriProductsScreenState extends State<AgriProductsScreen> {
  final AgriProductService _productService = AgriProductService();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<AgriProductModel> get _filteredProducts {
    return _productService.searchProducts(_searchQuery, category: _selectedCategory);
  }

  void _showProductDetail(AgriProductModel p, bool isHindi) {
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
                          '${p.brand} • ${p.chemicalName}',
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
                    _buildInfoRow(isHindi ? 'निर्माता / ब्रांड' : 'Brand', p.brand, isHighlight: true),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticHelper.lightTap();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isHindi ? 'नजदीकी केंद्र पर उपलब्धता जांची जा रही है' : 'Checking local stock availability...'),
                            backgroundColor: const Color(0xFF15803D),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.store, size: 18),
                      label: Text(isHindi ? 'नजदीकी डीलर खोजें' : 'Find Dealer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF15803D),
                        side: const BorderSide(color: Color(0xFF15803D)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticHelper.lightTap();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isHindi ? 'उपयोग विधि व सुरक्षा पुस्तिका सहेजी गई' : 'Dosage safety guidelines saved'),
                            backgroundColor: const Color(0xFF15803D),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.bookmark_check, size: 18, color: Colors.white),
                      label: Text(isHindi ? 'सलाह सहेजें' : 'Save Advice', style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
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
          width: 130,
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
      {'key': 'Fertilizer', 'label': isHindi ? 'उर्वरक व खाद' : 'Fertilizers'},
      {'key': 'Bio-Fertilizer', 'label': isHindi ? 'जैविक खाद' : 'Bio-Fertilizers'},
      {'key': 'Fungicide', 'label': isHindi ? 'फफूंदनाशक' : 'Fungicides'},
      {'key': 'Insecticide', 'label': isHindi ? 'कीटनाशक' : 'Insecticides'},
      {'key': 'Certified Seeds', 'label': isHindi ? 'प्रमाणित बीज' : 'Certified Seeds'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: const CustomAppBar(titleKey: 'agriProducts'),
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
                  hintText: isHindi ? 'उत्पाद, ब्रांड या कीट का नाम खोजें...' : 'Search chemical, brand or pest...',
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
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Product List
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.package_search, size: 48, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          isHindi ? 'कोई उत्पाद नहीं मिला' : 'No products found',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (ctx, idx) {
                      final p = _filteredProducts[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BouncyTap(
                          onTap: () => _showProductDetail(p, isHindi),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: p.badgeColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isHindi ? p.categoryHindi : p.category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: p.badgeColor,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p.brand,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(LucideIcons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.chemicalName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isHindi ? '15L पंप डोज' : '15L Pump Dose',
                                              style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              p.dosagePer15LTank,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF15803D),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isHindi ? 'लक्षित फसलें' : 'Target Crops',
                                              style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              p.targetCrops,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
