class FarmExpenseItem {
  final String id;
  final String category;
  final String categoryHindi;
  final double amount;
  final DateTime date;
  final String notes;

  FarmExpenseItem({
    required this.id,
    required this.category,
    required this.categoryHindi,
    required this.amount,
    required this.date,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'categoryHindi': categoryHindi,
        'amount': amount,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  factory FarmExpenseItem.fromJson(Map<String, dynamic> json) =>
      FarmExpenseItem(
        id: json['id'] ?? '',
        category: json['category'] ?? '',
        categoryHindi: json['categoryHindi'] ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        notes: json['notes'] ?? '',
      );
}

class ProfitEstimateResult {
  final double totalCost;
  final double expectedYieldQuintals;
  final double expectedPricePerQuintal;
  final double estimatedGrossRevenue;
  final double estimatedNetProfit;

  ProfitEstimateResult({
    required this.totalCost,
    required this.expectedYieldQuintals,
    required this.expectedPricePerQuintal,
    required this.estimatedGrossRevenue,
    required this.estimatedNetProfit,
  });
}
