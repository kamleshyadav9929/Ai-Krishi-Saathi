class ProductScanResult {
  final String barcode;
  final String productName;
  final String productNameHindi;
  final String manufacturer;
  final String category;
  final String categoryHindi;
  final bool isAuthentic;
  final String batchNumber;
  final String mfgDate;
  final String expiryDate;
  final String composition;
  final String compositionHindi;
  final String dosage;
  final String dosageHindi;
  final String warning;
  final String warningHindi;

  const ProductScanResult({
    required this.barcode,
    required this.productName,
    required this.productNameHindi,
    required this.manufacturer,
    required this.category,
    required this.categoryHindi,
    required this.isAuthentic,
    required this.batchNumber,
    required this.mfgDate,
    required this.expiryDate,
    required this.composition,
    required this.compositionHindi,
    required this.dosage,
    required this.dosageHindi,
    required this.warning,
    required this.warningHindi,
  });

  bool get isExpired {
    try {
      final parts = expiryDate.split('/');
      if (parts.length == 2) {
        final expMonth = int.parse(parts[0]);
        final expYear = int.parse(parts[1]);
        final now = DateTime.now();
        if (expYear < now.year || (expYear == now.year && expMonth < now.month)) {
          return true;
        }
      }
    } catch (_) {}
    return false;
  }
}
