class MandiPriceModel {
  final String commodity;
  final String commodityHindi;
  final String state;
  final String district;
  final String market;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final DateTime reportedDate;
  final String source;

  MandiPriceModel({
    required this.commodity,
    required this.commodityHindi,
    required this.state,
    required this.district,
    required this.market,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.reportedDate,
    this.source = 'Agmarknet / data.gov.in',
  });

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) {
      final cleaned = val.replaceAll(',', '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  static DateTime _parseDate(dynamic val) {
    if (val == null) return DateTime.now();
    if (val is DateTime) return val;
    final str = val.toString().trim();
    if (str.isEmpty) return DateTime.now();
    if (str.contains('/')) {
      final parts = str.split('/');
      if (parts.length == 3) {
        final d = int.tryParse(parts[0]) ?? 1;
        final m = int.tryParse(parts[1]) ?? 1;
        final y = int.tryParse(parts[2]) ?? 2026;
        return DateTime(y, m, d);
      }
    }
    return DateTime.tryParse(str) ?? DateTime.now();
  }

  static String getHindiCommodity(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wheat') || lower.contains('gehu')) return 'गेहूं';
    if (lower.contains('paddy') || lower.contains('dhan') || lower.contains('rice')) return 'धान (चावल)';
    if (lower.contains('maize') || lower.contains('corn') || lower.contains('makka')) return 'मक्का';
    if (lower.contains('mustard') || lower.contains('sarson')) return 'सरसों';
    if (lower.contains('cotton') || lower.contains('kapas')) return 'कपास (कॉटन)';
    if (lower.contains('soyabean') || lower.contains('soybean')) return 'सोयाबीन';
    if (lower.contains('chickpea') || lower.contains('gram') || lower.contains('chana')) return 'चना';
    if (lower.contains('arhar') || lower.contains('tur') || lower.contains('pigeonpea')) return 'अरहर (तुअर)';
    if (lower.contains('moong') || lower.contains('mung')) return 'मूंग';
    if (lower.contains('urad') || lower.contains('black gram')) return 'उड़द दाल';
    if (lower.contains('potato') || lower.contains('aloo')) return 'आलू';
    if (lower.contains('onion') || lower.contains('pyaj')) return 'प्याज';
    if (lower.contains('tomato') || lower.contains('tamatar')) return 'टमाटर';
    if (lower.contains('garlic') || lower.contains('lahsun')) return 'लहसुन';
    if (lower.contains('ginger') || lower.contains('adrak')) return 'अदरक';
    if (lower.contains('chilli') || lower.contains('mirch')) return 'मिर्च';
    if (lower.contains('turmeric') || lower.contains('haldi')) return 'हल्दी';
    if (lower.contains('apple') || lower.contains('seb')) return 'सेब';
    if (lower.contains('banana') || lower.contains('kela')) return 'केला';
    if (lower.contains('mango') || lower.contains('aam')) return 'आम';
    if (lower.contains('sugarcane') || lower.contains('ganna')) return 'गन्ना';
    if (lower.contains('jute') || lower.contains('patson')) return 'जूट / पटसन';
    if (lower.contains('groundnut') || lower.contains('moongphali')) return 'मूंगफली';
    if (lower.contains('barley') || lower.contains('jau')) return 'जौ';
    if (lower.contains('millets') || lower.contains('bajra') || lower.contains('pearl millet')) return 'बाजरा';
    if (lower.contains('jowar') || lower.contains('sorghum')) return 'ज्वार';
    if (lower.contains('cardamom') || lower.contains('elaichi')) return 'इलायची';
    if (lower.contains('black pepper') || lower.contains('kali mirch')) return 'काली मिर्च';
    if (lower.contains('tea')) return 'चाय';
    if (lower.contains('coffee')) return 'कॉफी';
    return name;
  }

  factory MandiPriceModel.fromJson(Map<String, dynamic> json) {
    final commodityStr = (json['commodity'] ?? '').toString();
    final hindiStr = json['commodityHindi']?.toString() ?? getHindiCommodity(commodityStr);
    final min = _parseDouble(json['min_price'] ?? json['minPrice']);
    final max = _parseDouble(json['max_price'] ?? json['maxPrice']);
    final modal = _parseDouble(json['modal_price'] ?? json['modalPrice']);
    final date = _parseDate(json['arrival_date'] ?? json['reportedDate']);

    return MandiPriceModel(
      commodity: commodityStr,
      commodityHindi: hindiStr.isNotEmpty ? hindiStr : commodityStr,
      state: (json['state'] ?? '').toString(),
      district: (json['district'] ?? '').toString(),
      market: (json['market'] ?? '').toString(),
      minPrice: min,
      maxPrice: max,
      modalPrice: modal,
      reportedDate: date,
      source: (json['source'] ?? 'Agmarknet / data.gov.in (Live)').toString(),
    );
  }
}
