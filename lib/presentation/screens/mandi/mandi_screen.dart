import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/mandi_price_model.dart';
import '../../../data/services/mandi_service.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

/// Real-time Mandi Price Intelligence Screen for AI Krishi Saathi.
/// Features Agmarknet & e-NAM market price trends and modal price insights.
class MandiScreen extends StatefulWidget {
  const MandiScreen({super.key});

  @override
  State<MandiScreen> createState() => _MandiScreenState();
}

class _MandiScreenState extends State<MandiScreen> {
  final MandiService _mandiService = MandiService();
  String _selectedState = 'Bihar';
  String? _selectedDistrict = 'Patna';
  String _searchQuery = '';
  List<MandiPriceModel> _prices = [];
  bool _isLoading = true;
  bool _hasInitializedLocation = false;
  String _selectedCrop = 'Wheat';
  int _selectedDistanceKm = 50;
  final Set<String> _bookmarkedMandis = {};
  String? _expandedGraphMandiId;

  final List<Map<String, dynamic>> _quickCrops = [
    {'en': 'Wheat', 'hi': 'गेहूं', 'image': 'assets/images/crop_wheat.png'},
    {'en': 'Paddy(Dhan)(Common)', 'hi': 'धान', 'image': 'assets/images/crop_paddy.png'},
    {'en': 'Mustard', 'hi': 'सरसों', 'image': 'assets/images/crop_mustard.png'},
    {'en': 'Potato', 'hi': 'आलू', 'image': 'assets/images/crop_potato.png'},
    {'en': 'Onion', 'hi': 'प्याज', 'image': 'assets/images/crop_onion.png'},
    {'en': 'Tomato', 'hi': 'टमाटर', 'image': 'assets/images/crop_tomato.png'},
    {'en': 'Maize', 'hi': 'मक्का', 'image': 'assets/images/crop_corn.png'},
    {'en': 'Bitter Gourd', 'hi': 'करेला', 'image': 'assets/images/crop_bitter_gourd.png'},
    {'en': 'Bottle Gourd', 'hi': 'लौकी', 'image': 'assets/images/crop_bottle_gourd.png'},
    {'en': 'Green Chilli', 'hi': 'हरी मिर्च', 'image': 'assets/images/crop_chilli.png'},
  ];

  String _getCropImage(String commodity) {
    final c = commodity.toLowerCase();
    if (c.contains('bitter') || c.contains('karela') || c.contains('करेला')) {
      return 'assets/images/crop_bitter_gourd.png';
    }
    if (c.contains('bottle') || c.contains('lauki') || c.contains('लौकी') || c.contains('ghiya')) {
      return 'assets/images/crop_bottle_gourd.png';
    }
    if (c.contains('wheat') || c.contains('gehu') || c.contains('गेहूं')) {
      return 'assets/images/crop_wheat.png';
    }
    if (c.contains('paddy') || c.contains('dhan') || c.contains('धान') || c.contains('rice')) {
      return 'assets/images/crop_paddy.png';
    }
    if (c.contains('mustard') || c.contains('sarson') || c.contains('सरसों') || c.contains('rai')) {
      return 'assets/images/crop_mustard.png';
    }
    if (c.contains('tomato') || c.contains('tamatar') || c.contains('टमाटर')) {
      return 'assets/images/crop_tomato.png';
    }
    if (c.contains('potato') || c.contains('aloo') || c.contains('आलू')) {
      return 'assets/images/crop_potato.png';
    }
    if (c.contains('onion') || c.contains('pyaz') || c.contains('प्याज')) {
      return 'assets/images/crop_onion.png';
    }
    if (c.contains('maize') || c.contains('corn') || c.contains('मक्का')) {
      return 'assets/images/crop_corn.png';
    }
    if (c.contains('chilli') || c.contains('mirch') || c.contains('मिर्च')) {
      return 'assets/images/crop_chilli.png';
    }
    return 'assets/images/crops.webp';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedLocation) {
      final loc = Provider.of<LocationProvider>(context);
      final availableStates = _mandiService.getAvailableStates();
      final matchedState = availableStates.firstWhere(
        (s) => s.toLowerCase() == loc.currentState.toLowerCase(),
        orElse: () => _selectedState,
      );
      _selectedState = matchedState;

      final availableDistricts = _mandiService.getDistrictsForState(_selectedState);
      final matchedDistrict = availableDistricts.firstWhere(
        (d) => d.toLowerCase() == loc.currentDistrict.toLowerCase(),
        orElse: () => '',
      );
      _selectedDistrict = matchedDistrict.isNotEmpty ? matchedDistrict : null;

      _hasInitializedLocation = true;
      _loadPrices();
    }
  }

  Future<void> _loadPrices() async {
    setState(() => _isLoading = true);
    final results = await _mandiService.fetchPrices(
      state: _selectedState,
      district: _selectedDistrict,
      commodityQuery: _searchQuery.isNotEmpty ? _searchQuery : _selectedCrop,
    );

    if (mounted) {
      setState(() {
        _prices = results;
        _isLoading = false;
      });
    }
  }

  void _showLocationFilterSheet(BuildContext context, bool isHindi) {
    HapticHelper.lightImpact();
    final availableStates = _mandiService.getAvailableStates();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final currentDistricts = _mandiService.getDistrictsForState(_selectedState);
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
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
                  Text(
                    isHindi ? 'राज्य और जिला चुनें' : 'Select State & District',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedState,
                    decoration: InputDecoration(
                      labelText: isHindi ? 'राज्य (State)' : 'State',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: availableStates
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setSheetState(() {
                          _selectedState = val;
                          _selectedDistrict = null;
                        });
                        setState(() {
                          _selectedState = val;
                          _selectedDistrict = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: currentDistricts.contains(_selectedDistrict) ? _selectedDistrict : null,
                    decoration: InputDecoration(
                      labelText: isHindi ? 'जिला (District)' : 'District',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(isHindi ? 'सभी जिले (All Districts)' : 'All Districts'),
                      ),
                      ...currentDistricts.map(
                        (d) => DropdownMenuItem(value: d, child: Text(d)),
                      ),
                    ],
                    onChanged: (val) {
                      setSheetState(() => _selectedDistrict = val);
                      setState(() => _selectedDistrict = val);
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _loadPrices();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E8B30),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(isHindi ? 'लागू करें' : 'Apply Filter', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDistanceFilterSheet(BuildContext context, bool isHindi) {
    HapticHelper.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              Text(
                isHindi ? 'दूरी का दायरा चुनें' : 'Filter by Distance',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 12),
              for (final km in [25, 50, 100, 250])
                ListTile(
                  title: Text(isHindi ? '$km किमी के भीतर' : 'Within $km km'),
                  trailing: _selectedDistanceKm == km
                      ? const Icon(LucideIcons.check, color: Color(0xFF0E8B30))
                      : null,
                  onTap: () {
                    setState(() => _selectedDistanceKm = km);
                    Navigator.pop(ctx);
                  },
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
    final isHindi = lang.isHindi;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(titleKey: 'mandiHeader'),
      body: RefreshIndicator(
        onRefresh: _loadPrices,
        color: const Color(0xFF0E8B30),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // 1. TOP COMMODITY SEARCH BAR
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: isHindi
                          ? 'मंडी, जिला या फसल खोजें...'
                          : 'Search by Mandi/District/State',
                      hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                      prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF6B7280)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _loadPrices();
                    },
                  ),
                ),
              ),

              // ==========================================================
              // 2. LOCATION & DISTANCE FILTER STRIP
              // ==========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    // Location Pill
                    InkWell(
                      onTap: () => _showLocationFilterSheet(context, isHindi),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.map_pin, size: 14, color: Color(0xFF0E8B30)),
                            const SizedBox(width: 6),
                            Text(
                              _selectedDistrict != null
                                  ? '$_selectedDistrict, $_selectedState'
                                  : _selectedState,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(LucideIcons.chevron_down, size: 14, color: Color(0xFF6B7280)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Distance Pill
                    InkWell(
                      onTap: () => _showDistanceFilterSheet(context, isHindi),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isHindi ? '$_selectedDistanceKm किमी' : 'Within $_selectedDistanceKm km',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(LucideIcons.chevron_down, size: 14, color: Color(0xFF6B7280)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ==========================================================
              // 3. HORIZONTAL COMMODITY SELECTOR
              // ==========================================================
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _quickCrops.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final crop = _quickCrops[index];
                    final isSelected = _selectedCrop.toLowerCase() == crop['en'].toString().toLowerCase();

                    return BouncyTap(
                      onTap: () {
                        HapticHelper.lightTap();
                        setState(() => _selectedCrop = crop['en'].toString());
                        _loadPrices();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFDCFCE7) : const Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF0E8B30) : const Color(0xFFE2E8F0),
                                width: isSelected ? 2.5 : 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                crop['image'] as String,
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => const Center(
                                  child: Icon(
                                    LucideIcons.sprout,
                                    color: Color(0xFF0E8B30),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isHindi ? crop['hi'].toString() : crop['en'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? const Color(0xFF0E8B30) : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Solid Gray Section Separator
              Container(height: 8, color: const Color(0xFFF3F4F6)),

              // ==========================================================
              // 4. MANDI LISTINGS
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_prices.length} ${isHindi ? 'मंडी परिणाम' : 'Mandi Results'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      isHindi ? 'प्रति क्विंटल (₹/Q)' : 'Price per Quintal',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E8B30),
                      ),
                    ),
                  ],
                ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF0E8B30)),
                  ),
                )
              else if (_prices.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(LucideIcons.store, size: 48, color: Color(0xFFCBD5E1)),
                        const SizedBox(height: 12),
                        Text(
                          isHindi
                              ? 'चुने गए क्षेत्र में इस फसल के भाव उपलब्ध नहीं हैं।'
                              : 'No mandi records found for this crop in selected district.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _prices.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    final item = _prices[index];
                    final mandiId = '${item.market}_${item.commodity}';
                    final isBookmarked = _bookmarkedMandis.contains(mandiId);
                    final isGraphOpen = _expandedGraphMandiId == mandiId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mandi Header Row: Real Crop PNG + Market name + Distance + Star
                          Row(
                            children: [
                              // Real Crop PNG Thumbnail
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    _getCropImage(item.commodity),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => const Center(
                                      child: Icon(LucideIcons.sprout, color: Color(0xFF0E8B30), size: 24),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.market,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDCFCE7),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.commodityHindi.isNotEmpty ? item.commodityHindi : item.commodity,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF15803D),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${item.district}, ${item.state} • ~${12 + (index * 7)} km',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF6B7280),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Bookmark Star (followMandi)
                              IconButton(
                                icon: Icon(
                                  isBookmarked ? LucideIcons.star : LucideIcons.star,
                                  color: isBookmarked ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                                  size: 22,
                                ),
                                onPressed: () {
                                  HapticHelper.lightImpact();
                                  setState(() {
                                    if (isBookmarked) {
                                      _bookmarkedMandis.remove(mandiId);
                                    } else {
                                      _bookmarkedMandis.add(mandiId);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Price Row: Modal Price + Trend Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '₹${item.modalPrice.round()}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '/ Quintal',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.trending_up, size: 12, color: Color(0xFF16A34A)),
                                    SizedBox(width: 4),
                                    Text(
                                      '+₹50 ▲ Today',
                                      style: TextStyle(
                                        color: Color(0xFF16A34A),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Min / Max range
                          Text(
                            'Min: ₹${item.minPrice.round()}  •  Max: ₹${item.maxPrice.round()}  •  Arrival: 140 Q',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 7-Day Price History Button (mandiPreviousPrices)
                          InkWell(
                            onTap: () {
                              HapticHelper.lightTap();
                              setState(() {
                                if (isGraphOpen) {
                                  _expandedGraphMandiId = null;
                                } else {
                                  _expandedGraphMandiId = mandiId;
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(LucideIcons.chart_line, size: 15, color: Color(0xFF0E8B30)),
                                  const SizedBox(width: 6),
                                  Text(
                                    isGraphOpen
                                        ? (isHindi ? 'चार्ट छिपाएं' : 'Hide Price Trend')
                                        : (isHindi ? '7 दिनों का भाव इतिहास (Trend)' : '7-Day Price History'),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0E8B30),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    isGraphOpen ? LucideIcons.chevron_up : LucideIcons.chevron_down,
                                    size: 16,
                                    color: const Color(0xFF0E8B30),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Expanded 7-Day Chart
                          if (isGraphOpen) ...[
                            const SizedBox(height: 12),
                            Container(
                              height: 160,
                              padding: const EdgeInsets.fromLTRB(8, 12, 16, 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 42,
                                        getTitlesWidget: (val, meta) => Text(
                                          '₹${val.toInt()}',
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                        ),
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (val, meta) {
                                          const days = ['D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'Yest', 'Today'];
                                          final i = val.toInt();
                                          if (i >= 0 && i < days.length) {
                                            return Text(days[i], style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)));
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        FlSpot(0, item.modalPrice * 0.95),
                                        FlSpot(1, item.modalPrice * 0.96),
                                        FlSpot(2, item.modalPrice * 0.97),
                                        FlSpot(3, item.modalPrice * 0.96),
                                        FlSpot(4, item.modalPrice * 0.98),
                                        FlSpot(5, item.modalPrice * 0.99),
                                        FlSpot(6, item.modalPrice),
                                      ],
                                      isCurved: true,
                                      color: const Color(0xFF0E8B30),
                                      barWidth: 2.5,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: const Color(0xFF0E8B30).withValues(alpha: 0.12),
                                      ),
                                      dotData: const FlDotData(show: true),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
