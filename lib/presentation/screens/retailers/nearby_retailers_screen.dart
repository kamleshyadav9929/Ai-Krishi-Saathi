import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class RetailerItem {
  final String id;
  final String name;
  final String ownerName;
  final String address;
  final String distance;
  final String phone;
  final String licenseNumber;
  final bool isBayerAuthorized;
  final List<String> inventory;

  const RetailerItem({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.distance,
    required this.phone,
    required this.licenseNumber,
    required this.isBayerAuthorized,
    required this.inventory,
  });
}

class NearbyRetailersScreen extends StatefulWidget {
  const NearbyRetailersScreen({super.key});

  @override
  State<NearbyRetailersScreen> createState() => _NearbyRetailersScreenState();
}

class _NearbyRetailersScreenState extends State<NearbyRetailersScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<RetailerItem> _retailers = const [
    RetailerItem(
      id: 'r1',
      name: 'Kisan Krishi Seva Kendra (किसान कृषि सेवा केंद्र)',
      ownerName: 'Shri Rameshwar Singh',
      address: 'Main Road, Near Anaj Mandi, Patna Rural',
      distance: '1.4 km',
      phone: '+91 98765 43210',
      licenseNumber: 'BR-PAT-AGR-2024-8841',
      isBayerAuthorized: true,
      inventory: ['Bayer Confidor', 'Bayer Nativo', 'IFFCO Nano Urea', 'Wheat PBW-502'],
    ),
    RetailerItem(
      id: 'r2',
      name: 'Bayer Crop Protection Center (बायर अधिकृत डीलर)',
      ownerName: 'Manoj Kumar Agrotech',
      address: 'Shop No. 12, Krishi Upaj Mandi Samiti, Patna',
      distance: '2.8 km',
      phone: '+91 94310 11223',
      licenseNumber: 'BR-PAT-BAYER-1092',
      isBayerAuthorized: true,
      inventory: ['Bayer Regent', 'Bayer Decis', 'Bayer Ambition', 'Sprayers & Knapsacks'],
    ),
    RetailerItem(
      id: 'r3',
      name: 'IFFCO Kisan Samridhi Kendra (इफको किसान केंद्र)',
      ownerName: 'IFFCO Cooperative Society',
      address: 'Near Block Development Office, Danapur, Patna',
      distance: '4.1 km',
      phone: '1800 103 1967',
      licenseNumber: 'BR-COOP-IFFCO-551',
      isBayerAuthorized: false,
      inventory: ['IFFCO Nano DAP', 'IFFCO Urea', 'Bio-Fertilizers', 'Zinc Sulphate'],
    ),
    RetailerItem(
      id: 'r4',
      name: 'Maa Durga Khad & Beej Bhandar',
      ownerName: 'Vinod Prasad Gupta',
      address: 'Station Road, Phulwari Sharif, Patna',
      distance: '5.6 km',
      phone: '+91 91234 56789',
      licenseNumber: 'BR-PAT-AGR-2023-4019',
      isBayerAuthorized: true,
      inventory: ['Certified Mustard Seeds', 'Bayer Confidor', 'NPK 12:32:16', 'Pesticides'],
    ),
  ];

  List<RetailerItem> get _filteredRetailers {
    return _retailers.where((r) {
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Bayer' && r.isBayerAuthorized) ||
          (_selectedFilter == 'IFFCO' && r.name.contains('IFFCO'));
      final matchesQuery = _searchQuery.isEmpty ||
          r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.ownerName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();
  }

  void _showRetailerDetails(RetailerItem r, bool isHindi) {
    HapticHelper.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.store, color: Color(0xFF15803D), size: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.name,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'संचालक: ${r.ownerName}',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.map_pin, size: 16, color: Color(0xFF15803D)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            r.address,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Text(
                            r.distance,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    Text(
                      'लाइसेंस नंबर: ${r.licenseNumber}',
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isHindi ? 'उपलब्ध स्टॉक (Verified Stock):' : 'Available Inventory:',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: r.inventory.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                          ),
                        );
                      }).toList(),
                    ),
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
                            content: Text(isHindi ? 'दुकानदार से कॉल कनेक्ट की जा रही है: ${r.phone}' : 'Calling ${r.phone}'),
                            backgroundColor: const Color(0xFF15803D),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.phone_call, size: 18),
                      label: Text(isHindi ? 'कॉल करें' : 'Call Dealer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF15803D),
                        side: const BorderSide(color: Color(0xFFBBF7D0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                            content: Text(isHindi ? 'गूगल मैप्स नेविगेशन शुरू हो रहा है...' : 'Opening Navigation Map...'),
                            backgroundColor: const Color(0xFF15803D),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.navigation, size: 18),
                      label: Text(isHindi ? 'रास्ता देखें' : 'Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    final isHindi = lang.isHindi;

    final filters = [
      {'key': 'All', 'label': isHindi ? 'सभी' : 'All'},
      {'key': 'Bayer', 'label': isHindi ? 'बायर अधिकृत' : 'Bayer Authorized'},
      {'key': 'IFFCO', 'label': isHindi ? 'इफको केंद्र' : 'IFFCO Centers'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: CustomAppBar(
        titleKey: isHindi ? 'nearbyRetailers' : 'nearbyRetailers',
        subtitle: '${loc.locationTitle}, ${loc.currentState}',
      ),
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
                  hintText: isHindi ? 'नजदीकी खाद-बीज दुकान या डीलर खोजें...' : 'Search agro retailers or dealers...',
                  hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filters.length,
              itemBuilder: (ctx, idx) {
                final f = filters[idx];
                final isSelected = _selectedFilter == f['key'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      f['label']!,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      HapticHelper.lightTap();
                      setState(() => _selectedFilter = f['key']!);
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Retailers List
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              itemCount: _filteredRetailers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, idx) {
                final r = _filteredRetailers[idx];
                return BouncyTap(
                  onTap: () => _showRetailerDetails(r, isHindi),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(LucideIcons.store, color: Color(0xFF15803D), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    r.address,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFBBF7D0)),
                              ),
                              child: Text(
                                r.distance,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (r.isBayerAuthorized)
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFBFDBFE)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.badge_check, size: 12, color: Color(0xFF2563EB)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Bayer Authorized',
                                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                                    ),
                                  ],
                                ),
                              ),
                            const Spacer(),
                            const Icon(LucideIcons.chevron_right, size: 18, color: Color(0xFF94A3B8)),
                          ],
                        ),
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
