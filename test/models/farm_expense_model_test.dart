import 'package:flutter_test/flutter_test.dart';
import 'package:ai_krishi_saathi/data/models/farm_record_model.dart';

void main() {
  group('FarmExpenseItem Model Tests', () {
    test('toJson and fromJson preserves all fields without corruption', () {
      final now = DateTime.now();
      final item = FarmExpenseItem(
        id: 'test-123',
        category: 'Fertilizer',
        categoryHindi: 'उर्वरक',
        amount: 4500.50,
        date: now,
      );

      final jsonMap = item.toJson();
      final restored = FarmExpenseItem.fromJson(jsonMap);

      expect(restored.id, equals('test-123'));
      expect(restored.category, equals('Fertilizer'));
      expect(restored.categoryHindi, equals('उर्वरक'));
      expect(restored.amount, equals(4500.50));
      expect(restored.date.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
    });
  });
}
