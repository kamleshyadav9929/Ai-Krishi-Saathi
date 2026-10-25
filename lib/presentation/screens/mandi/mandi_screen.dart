import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/mandi_price_model.dart';
import '../../../data/services/mandi_service.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/animated_counter.dart';

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
  String _selectedChartCrop = 'Wheat';

  List<String> get _availableCropsForChart {
    final list = _prices.map((p) => p.commodity).toSet().toList();
    if (list.isEmpty) {
      return ['Wheat', 'Paddy(Dhan)(Common)', 'Mustard', 'Potato', 'Cotton', 'Onion'];
    }
    return list;
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
      commodityQuery: _searchQuery,
    );
    if (!mounted) return;
    setState(() {
      _prices = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final availableStates = _mandiService.getAvailableStates();
    final availableDistricts = _mandiService.getDistrictsForState(_selectedState);

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'mandiHeader'),
      body: RefreshIndicator(
        onRefresh: _loadPrices,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // APMC Market Visual Banner (Rich Illustration Banner)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 145,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF854D0E).withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/mandi_market_hero.png',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.78),
                              Colors.black.withValues(alpha: 0.42),
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
                                color: const Color(0xFFD97706),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                lang.isHindi ? 'ताज़ा APMC मंडी भाव' : 'Live APMC Market Rates',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lang.isHindi
                                  ? 'आज का सही भाव\nव मंडी दर विश्लेषण'
                                  : 'Daily Market Rates\n& Price Analysis',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang.isHindi
                                  ? 'राज्य व जिला चुनें और मंडी का मॉडल भाव जानें'
                                  : 'Select state & district to track modal prices',
                              style: const TextStyle(
                                color: Color(0xFFFEF3C7),
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

              // Filter Selector (State & District - Stacked for No Overflow)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    key: ValueKey('state_$_selectedState'),
                    isExpanded: true,
                    initialValue: _selectedState,
                    decoration: InputDecoration(
                      labelText: lang.tr('filterState'),
                      prefixIcon: const Icon(LucideIcons.map_pin, size: 18, color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: availableStates
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                                  height: 1.3,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedState = val;
                          _selectedDistrict = null;
                        });
                        _loadPrices();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    key: ValueKey('dist_${_selectedState}_$_selectedDistrict'),
                    isExpanded: true,
                    initialValue: availableDistricts.contains(_selectedDistrict) ? _selectedDistrict : null,
                    decoration: InputDecoration(
                      labelText: lang.tr('filterDistrict'),
                      prefixIcon: const Icon(LucideIcons.building, size: 18, color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          lang.isHindi ? 'सभी जिले (All Districts)' : 'All Districts',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                            height: 1.3,
                          ),
                        ),
                      ),
                      ...availableDistricts.map(
                        (d) => DropdownMenuItem(
                          value: d,
                          child: Text(
                            d,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedDistrict = val);
                      _loadPrices();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: lang.tr('filterCommodity'),
                      prefixIcon: const Icon(LucideIcons.search, size: 20, color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _loadPrices();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          HapticHelper.lightImpact();
                          final loc = Provider.of<LocationProvider>(context, listen: false);
                          final matchedState = availableStates.firstWhere(
                            (s) => s.toLowerCase() == loc.currentState.toLowerCase(),
                            orElse: () => _selectedState,
                          );
                          setState(() {
                            _selectedState = matchedState;
                            final currentDistricts = _mandiService.getDistrictsForState(_selectedState);
                            final matchedDistrict = currentDistricts.firstWhere(
                              (d) => d.toLowerCase() == loc.currentDistrict.toLowerCase(),
                              orElse: () => '',
                            );
                            _selectedDistrict = matchedDistrict.isNotEmpty ? matchedDistrict : null;
                          });
                          _loadPrices();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.map_pin, size: 14, color: AppColors.primaryDark),
                              const SizedBox(width: 6),
                              Text(
                                '${lang.isHindi ? 'मेरी लोकेशन' : 'My Location'}: ${Provider.of<LocationProvider>(context).currentDistrict}',
                                style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '${_prices.length} ${lang.isHindi ? 'मंडी रिकॉर्ड' : 'mandi records'}',
                        style: AppTypography.bodySmall().copyWith(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Mandi Price Comparison & Analytics Card
            Builder(
              builder: (context) {
                final chartMarkets = _mandiService.getMarketsForCommodity(_selectedChartCrop, state: _selectedState);
                final sortedMarkets = List<MandiPriceModel>.from(chartMarkets)
                  ..sort((a, b) => b.modalPrice.compareTo(a.modalPrice));
                final displayMarkets = sortedMarkets.take(5).toList();
                final bestMarket = displayMarkets.isNotEmpty ? displayMarkets.first : null;
                final double highestPrice = (bestMarket?.modalPrice ?? 1.0) > 0 ? bestMarket!.modalPrice : 1.0;

                final trend = _mandiService.getPriceTrend(_selectedChartCrop);
                final double startPrice = trend.first;
                final double endPrice = trend.last;
                final double delta = endPrice - startPrice;
                final double deltaPct = startPrice > 0 ? (delta / startPrice) * 100 : 0.0;
                final bool isPositive = delta >= 0;

                final double minVal = trend.reduce((a, b) => a < b ? a : b);
                final double maxVal = trend.reduce((a, b) => a > b ? a : b);
                final double range = maxVal - minVal;
                final double buffer = range > 0 ? range * 0.25 : (minVal > 0 ? minVal * 0.05 : 100);
                final double computedMinY = (minVal - buffer).clamp(0, double.infinity);
                final double computedMaxY = maxVal + buffer;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.035),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (Crop badge removed to prevent any overflow)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(LucideIcons.trending_up, size: 18, color: Color(0xFF15803D)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.isHindi ? '7 दिनों का भाव ग्राफ़ व मंडी तुलना' : '7-Day Price Trend & Mandi Comparison',
                                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  lang.isHindi ? 'दैनिक भाव का उतार-चढ़ाव व मंडियों की दरें' : 'Daily price movement & market rates',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Crop Selector Horizontal Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableCropsForChart.take(8).map((crop) {
                            final isSelected = crop.toLowerCase() == _selectedChartCrop.toLowerCase();
                            final hindiName = MandiPriceModel.getHindiCommodity(crop);
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                label: Text(
                                  lang.isHindi ? hindiName : crop,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF334155),
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 12,
                                    fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: const Color(0xFF15803D),
                                backgroundColor: const Color(0xFFF8FAFC),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onSelected: (selected) {
                                  if (selected) {
                                    HapticHelper.lightImpact();
                                    setState(() => _selectedChartCrop = crop);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 7-Day Trend Direction & Today Rate Banner
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isPositive ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive ? LucideIcons.trending_up : LucideIcons.trending_down,
                                  size: 14,
                                  color: isPositive ? const Color(0xFF15803D) : const Color(0xFFE11D48),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isPositive
                                      ? (lang.isHindi
                                          ? '+₹${delta.toInt()} (+${deltaPct.toStringAsFixed(1)}%) बढ़त'
                                          : '+₹${delta.toInt()} (+${deltaPct.toStringAsFixed(1)}%) Rising')
                                      : (lang.isHindi
                                          ? '-₹${delta.abs().toInt()} (-${deltaPct.abs().toStringAsFixed(1)}%) मंदी'
                                          : '-₹${delta.abs().toInt()} (-${deltaPct.abs().toStringAsFixed(1)}%) Falling'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isPositive ? const Color(0xFF15803D) : const Color(0xFFE11D48),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${lang.isHindi ? 'आज' : 'Today'}: ₹${endPrice.toInt()}/Q',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 7-Day Smooth Price Graph
                      SizedBox(
                        height: 185,
                        child: LineChart(
                          LineChartData(
                            minY: computedMinY,
                            maxY: computedMaxY,
                            minX: 0,
                            maxX: 6,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: (range > 0 ? (range / 3).ceilToDouble() : 500.0).clamp(100.0, 5000.0).toDouble(),
                              getDrawingHorizontalLine: (value) => const FlLine(
                                color: Color(0xFFF1F5F9),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 42,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '₹${value.toInt()}',
                                      style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    final idx = value.toInt();
                                    if (idx < 0 || idx > 6) return const SizedBox.shrink();
                                    if (idx != 0 && idx != 2 && idx != 4 && idx != 6) {
                                      return const SizedBox.shrink();
                                    }
                                    final d = DateTime.now().subtract(Duration(days: 6 - idx));
                                    final label = idx == 6
                                        ? (lang.isHindi ? 'आज' : 'Today')
                                        : DateFormat('d MMM').format(d);
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: idx == 6 ? FontWeight.w700 : FontWeight.w500,
                                          color: idx == 6 ? const Color(0xFF15803D) : const Color(0xFF64748B),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    final idx = spot.x.toInt();
                                    final d = DateTime.now().subtract(Duration(days: 6 - idx));
                                    final dateStr = DateFormat('dd MMM').format(d);
                                    return LineTooltipItem(
                                      '$dateStr\n₹${spot.y.toInt()}/Q',
                                      const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: trend.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                                isCurved: true,
                                curveSmoothness: 0.35,
                                color: const Color(0xFF15803D),
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    final isLast = index == 6;
                                    return FlDotCirclePainter(
                                      radius: isLast ? 4.5 : 3.0,
                                      color: isLast ? const Color(0xFF15803D) : Colors.white,
                                      strokeWidth: isLast ? 2.5 : 2.0,
                                      strokeColor: const Color(0xFF15803D),
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xFF22C55E).withValues(alpha: 0.22),
                                      const Color(0xFF22C55E).withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Highest Rate Mandi Card
                      if (bestMarket != null)
                        Container(
                          margin: const EdgeInsets.only(top: 14, bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF15803D),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.trophy, size: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.isHindi ? '🏆 सर्वाधिक भाव वाली मंडी' : '🏆 Highest Rate Mandi',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF15803D),
                                      ),
                                    ),
                                    Text(
                                      '${bestMarket.market} (${bestMarket.district})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                        fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${bestMarket.modalPrice.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                  Text(
                                    lang.isHindi ? 'प्रति क्विंटल' : 'per quintal',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      if (displayMarkets.isNotEmpty) ...[
                        // Visual Mandi-by-Mandi Comparison Summary List (Borderless)
                        ...displayMarkets.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final m = entry.value;
                          final isBest = idx == 0;
                          final diffFromBest = (bestMarket?.modalPrice ?? 0) - m.modalPrice;
                          final double barRatio = (m.modalPrice / highestPrice).clamp(0.2, 1.0);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isBest ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isBest ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '#${idx + 1}',
                                        style: TextStyle(
                                          color: isBest ? Colors.white : const Color(0xFF475569),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.market,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                              fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${m.district}, ${m.state}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹${m.modalPrice.toInt()}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: isBest ? const Color(0xFF15803D) : const Color(0xFF1E293B),
                                          ),
                                        ),
                                        Text(
                                          lang.isHindi ? 'मॉडल भाव /क्विं.' : 'Modal /Q',
                                          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Visual Proportional Comparative Bar
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final totalWidth = constraints.maxWidth;
                                    final fillWidth = totalWidth * barRatio;

                                    return Stack(
                                      children: [
                                        Container(
                                          height: 7,
                                          width: totalWidth,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE2E8F0),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        Container(
                                          height: 7,
                                          width: fillWidth,
                                          decoration: BoxDecoration(
                                            color: isBest
                                                ? const Color(0xFF15803D)
                                                : const Color(0xFF22C55E).withValues(alpha: 0.75),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 6),

                                // Range & Status Tags
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${lang.isHindi ? 'रेंज' : 'Range'}: ₹${m.minPrice.toInt()} - ₹${m.maxPrice.toInt()}',
                                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                    ),
                                    if (isBest)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          lang.isHindi ? '★ सर्वाधिक भाव' : '★ Top Rate',
                                          style: const TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF15803D),
                                          ),
                                        ),
                                      )
                                    else if (diffFromBest > 0)
                                      Text(
                                        '-₹${diffFromBest.toInt()} ${lang.isHindi ? 'कम' : 'lower'}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFE11D48),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Commodity Price Cards List
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_prices.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    lang.tr('noMandiData'),
                    style: AppTypography.bodyMedium(isHindi: lang.isHindi),
                  ),
                ),
              )
            else ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lang.isHindi
                            ? 'लाइव सरकारी मंडी भाव (Agmarknet / APMC Mandi)'
                            : 'Live APMC Mandi Rates (Official Agmarknet Feed)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF166534),
                          fontFamily: lang.isHindi ? 'Noto Sans Devanagari' : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ..._prices.asMap().entries.map((entry) => _buildPriceCard(context, entry.value, entry.key)),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildPriceCard(BuildContext context, MandiPriceModel item, [int index = 0]) {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final commodityName = lang.isHindi ? item.commodityHindi : item.commodity;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(item.reportedDate);
    final spread = item.maxPrice - item.minPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Commodity Icon + Name & Market + Large Modal Price
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.sprout, color: Color(0xFF15803D), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commodityName,
                        style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item.market}, ${item.district}',
                        style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedCounter(
                          value: item.modalPrice,
                          prefix: '₹',
                          fractionDigits: 0,
                          style: AppTypography.metricValue().copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          ' /Q',
                          style: AppTypography.bodySmall().copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      lang.isHindi ? 'मॉडल भाव' : 'Modal Rate',
                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Fluid Price Range Ribbon (Min - Modal - Max)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          lang.isHindi ? 'न्यूनतम: ' : 'Min: ',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        Text(
                          '₹${item.minPrice.toInt()}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 12,
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lang.isHindi ? 'अधिकतम: ' : 'Max: ',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        Text(
                          '₹${item.maxPrice.toInt()}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 12,
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.activity, size: 12, color: Color(0xFF0284C7)),
                      const SizedBox(width: 3),
                      Text(
                        '₹${spread.toInt()} ${lang.isHindi ? 'अंतर' : 'spread'}',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Subtle Footer: Date & Live Source
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.source,
                      style: AppTypography.bodySmall().copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms)
        .slideY(begin: 0.04, end: 0, curve: Curves.easeOutCubic);
  }
}
