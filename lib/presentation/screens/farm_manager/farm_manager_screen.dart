import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../data/models/farm_record_model.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/bouncy_tap.dart';
import '../../widgets/custom_app_bar.dart';

class FarmManagerScreen extends StatefulWidget {
  const FarmManagerScreen({super.key});

  @override
  State<FarmManagerScreen> createState() => _FarmManagerScreenState();
}

class _FarmManagerScreenState extends State<FarmManagerScreen> {
  static const String _storageKey = 'saved_farm_expenses';
  List<FarmExpenseItem> _expenses = [];

  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  double _calculatedRevenue = 0.0;
  double _calculatedNetProfit = 0.0;
  double _costPerQuintal = 0.0;
  double _roiPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final List list = jsonDecode(data);
        setState(() {
          _expenses = list.map((e) => FarmExpenseItem.fromJson(e)).toList();
        });
      } else {
        setState(() {
          _expenses = [];
        });
      }
    } catch (_) {}
    _calculateEstimates();
  }

  Future<void> _saveExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_expenses.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (_) {}
  }

  double get _totalExpenses => _expenses.fold(0.0, (sum, item) => sum + item.amount);

  void _calculateEstimates() {
    final yieldText = _yieldController.text.trim();
    final priceText = _priceController.text.trim();
    final yieldQ = double.tryParse(yieldText) ?? 0.0;
    final priceQ = double.tryParse(priceText) ?? 0.0;
    final totalCost = _totalExpenses;
    final revenue = yieldQ * priceQ;
    final profit = totalCost > 0 || revenue > 0 ? (revenue - totalCost) : 0.0;

    setState(() {
      _calculatedRevenue = revenue;
      _calculatedNetProfit = profit;
      _costPerQuintal = yieldQ > 0 ? (totalCost / yieldQ) : 0.0;
      _roiPercent = totalCost > 0 ? ((profit / totalCost) * 100) : 0.0;
    });
  }

  void _removeExpense(String id) {
    HapticHelper.lightImpact();
    setState(() {
      _expenses.removeWhere((e) => e.id == id);
      _calculateEstimates();
    });
    _saveExpenses();
  }

  void _showAddExpenseDialog(BuildContext context) {
    HapticHelper.lightTap();
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final catController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          lang.tr('addExpense'),
          style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: catController,
              decoration: InputDecoration(
                labelText: lang.tr('expenseCategory'),
                hintText: lang.isHindi ? 'उदा. बीज, यूरिया, मजदूरी, डीजल' : 'e.g. Seeds, Fertilizer, Labor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: lang.tr('amount'),
                hintText: '₹ 2500',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              lang.isHindi ? 'रद्द करें' : 'Cancel',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final amt = double.tryParse(amountController.text) ?? 0.0;
              if (catController.text.trim().isNotEmpty && amt > 0) {
                setState(() {
                  _expenses.insert(
                    0,
                    FarmExpenseItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      category: catController.text.trim(),
                      categoryHindi: catController.text.trim(),
                      amount: amt,
                      date: DateTime.now(),
                    ),
                  );
                  _calculateEstimates();
                });
                _saveExpenses();
                Navigator.pop(ctx);
              }
            },
            child: Text(lang.isHindi ? 'जोड़ें' : 'Add'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('fertilizer') || lower.contains('उर्वरक') || lower.contains('यूरिया') || lower.contains('खाद')) {
      return LucideIcons.flask_conical;
    }
    if (lower.contains('seed') || lower.contains('बीज')) {
      return LucideIcons.sprout;
    }
    if (lower.contains('diesel') || lower.contains('डीजल') || lower.contains('fuel') || lower.contains('पेट्रोल')) {
      return LucideIcons.fuel;
    }
    if (lower.contains('labor') || lower.contains('मजदूरी') || lower.contains('मजदूर')) {
      return LucideIcons.users;
    }
    if (lower.contains('tractor') || lower.contains('ट्रैक्टर') || lower.contains('जुताई')) {
      return LucideIcons.wrench;
    }
    return LucideIcons.receipt;
  }

  Color _getCategoryBg(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('fertilizer') || lower.contains('उर्वरक') || lower.contains('यूरिया')) {
      return const Color(0xFFDCFCE7);
    }
    if (lower.contains('seed') || lower.contains('बीज')) {
      return const Color(0xFFFEF3C7);
    }
    if (lower.contains('diesel') || lower.contains('डीजल')) {
      return const Color(0xFFE0F2FE);
    }
    if (lower.contains('labor') || lower.contains('मजदूरी')) {
      return const Color(0xFFF3E8FF);
    }
    return const Color(0xFFF1F5F9);
  }

  Color _getCategoryColor(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('fertilizer') || lower.contains('उर्वरक') || lower.contains('यूरिया')) {
      return const Color(0xFF15803D);
    }
    if (lower.contains('seed') || lower.contains('बीज')) {
      return const Color(0xFFD97706);
    }
    if (lower.contains('diesel') || lower.contains('डीजल')) {
      return const Color(0xFF0284C7);
    }
    if (lower.contains('labor') || lower.contains('मजदूरी')) {
      return const Color(0xFF7E22CE);
    }
    return const Color(0xFF475569);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'farmHeader'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Financial Cockpit (Borderless Surface)
            _buildHeroCockpit(lang),
            const SizedBox(height: 16),

            // 2. Agricultural Yield & Price Simulator Capsule
            _buildSimulatorCapsule(lang),
            const SizedBox(height: 20),

            // 3. Saved Farm Ledger Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.isHindi ? 'लागत खाता (Farm Ledger)' : 'Farm Expense Ledger',
                      style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_expenses.length} ${lang.isHindi ? 'खर्च दर्ज हैं' : 'transactions recorded'}',
                      style: AppTypography.bodySmall().copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                BouncyTap(
                  onTap: () => _showAddExpenseDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.plus, size: 16, color: AppColors.primaryDark),
                        const SizedBox(width: 4),
                        Text(
                          lang.tr('addExpense'),
                          style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_expenses.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.receipt, size: 24, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.isHindi ? 'अभी कोई खर्च दर्ज नहीं है' : 'No expenses recorded yet',
                      style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang.isHindi
                          ? 'बीज, खाद, डीजल या मजदूरी का खर्च जोड़ने के लिए ऊपर बटन दबाएं'
                          : 'Tap "+ Add" to log seeds, fertilizer, fuel, or labor',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._expenses.map((exp) => _buildExpenseItem(exp, lang)),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  /// Kiwi-Style Hero Financial Cockpit
  Widget _buildHeroCockpit(LanguageProvider lang) {
    final isProfit = _calculatedNetProfit >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Label & ROI Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.isHindi ? 'अनुमानित शुद्ध लाभ (Net P&L)' : 'Estimated Net Farm Profit',
                style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isProfit ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isProfit ? LucideIcons.trending_up : LucideIcons.trending_down,
                      size: 12,
                      color: isProfit ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'ROI: ${_roiPercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isProfit ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Big Tabular Net Profit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AnimatedCounter(
                value: _calculatedNetProfit,
                prefix: '₹',
                fractionDigits: 0,
                style: AppTypography.metricValue().copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isProfit ? AppColors.primaryDark : const Color(0xFFDC2626),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                lang.isHindi ? 'शुद्ध बचत' : 'net surplus',
                style: AppTypography.bodySmall(isHindi: lang.isHindi).copyWith(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3-Pillar Breakdown Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.tr('totalExpense'),
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${_totalExpenses.toInt()}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.black.withValues(alpha: 0.08)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.isHindi ? 'अनुमानित आय' : 'Gross Revenue',
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${_calculatedRevenue.toInt()}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.black.withValues(alpha: 0.08)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.isHindi ? 'लागत/क्विंटल' : 'Cost / Qntl',
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${_costPerQuintal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Modern Yield and Expected Price Simulator
  Widget _buildSimulatorCapsule(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.calculator, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                lang.isHindi ? 'फसल उत्पादन व भाव अनुमान' : 'Yield & Price Calculator',
                style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _yieldController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: lang.tr('expectedYield'),
                    hintText: 'उदा. 40 Q',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => _calculateEstimates(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: lang.tr('expectedPrice'),
                    hintText: 'उदा. ₹2400',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => _calculateEstimates(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(FarmExpenseItem exp, LanguageProvider lang) {
    final catName = lang.isHindi ? exp.categoryHindi : exp.category;
    final icon = _getCategoryIcon(catName);
    final bg = _getCategoryBg(catName);
    final color = _getCategoryColor(catName);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catName,
                  style: AppTypography.headingSmall(isHindi: lang.isHindi).copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${exp.date.day}/${exp.date.month}/${exp.date.year}',
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ₹${exp.amount.toInt()}',
            style: AppTypography.metricValue().copyWith(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFDC2626),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(LucideIcons.trash, size: 16, color: AppColors.textMuted),
            onPressed: () => _removeExpense(exp.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: lang.isHindi ? 'हटाएं' : 'Delete',
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 180.ms)
        .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic);
  }
}
