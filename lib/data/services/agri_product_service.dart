import 'package:flutter/material.dart';
import '../models/agri_product_model.dart';

/// Repository service for verified agricultural inputs, certified seeds,
/// bio-fertilizers, and ICAR-approved agrochemicals.
class AgriProductService {
  final List<AgriProductModel> _catalog = const [
    AgriProductModel(
      id: 'p1',
      name: 'IFFCO Nano Urea Plus (Liquid)',
      brand: 'IFFCO',
      chemicalName: 'Nano Nitrogen (4.0% w/v Liquid)',
      category: 'Fertilizer',
      categoryHindi: 'तरल नैनो उर्वरक',
      targetPests: 'पौधों में नाइट्रोजन की कमी, कल्ले व हरियाली विकास',
      targetCrops: 'सभी खाद्यान्न, दलहन व तिलहन फसलें',
      dosagePer15LTank: '30 - 40 मिली',
      dosagePerAcre: '500 मिली (1 बोतल) / एकड़',
      phiDays: 'सुरक्षित (0 दिन)',
      badgeColor: Color(0xFF15803D),
    ),
    AgriProductModel(
      id: 'p2',
      name: 'IFFCO Nano DAP (Liquid)',
      brand: 'IFFCO',
      chemicalName: 'Nano Phosphorus (8.0% P2O5 w/v)',
      category: 'Fertilizer',
      categoryHindi: 'तरल नैनो फास्फेट',
      targetPests: 'जड़ों का विकास, कल्लों की संख्या व दाना भराव',
      targetCrops: 'गेहूं, धान, मक्का, चना, सरसों, सोयाबीन',
      dosagePer15LTank: '35 - 50 मिली',
      dosagePerAcre: '500 मिली (1 बोतल) / 150 लीटर पानी',
      phiDays: 'सुरक्षित (0 दिन)',
      badgeColor: Color(0xFF047857),
    ),
    AgriProductModel(
      id: 'p3',
      name: 'Tata Rallis Contaf Plus',
      brand: 'Tata Rallis',
      chemicalName: 'Hexaconazole 5% SC',
      category: 'Fungicide',
      categoryHindi: 'फफूंदनाशक',
      targetPests: 'शीथ ब्लाइट, टिक्का रोग, पाउडरी मिल्ड्यू (चूर्णी फफूंद)',
      targetCrops: 'धान, मूंगफली, मिर्च, आम, सेब',
      dosagePer15LTank: '25 - 30 मिली',
      dosagePerAcre: '250 - 300 मिली / 150 लीटर पानी',
      phiDays: '21 दिन',
      badgeColor: Color(0xFF0284C7),
    ),
    AgriProductModel(
      id: 'p4',
      name: 'UPL Saaf Fungicide',
      brand: 'UPL India',
      chemicalName: 'Carbendazim 12% + Mancozeb 63% WP',
      category: 'Fungicide',
      categoryHindi: 'फफूंदनाशक',
      targetPests: 'ब्लास्ट, झुलसा रोग (Blight), जड़ सड़न व बीज जनित रोग',
      targetCrops: 'गेहूं, धान, टमाटर, आलू, मूंगफली',
      dosagePer15LTank: '30 - 35 ग्राम',
      dosagePerAcre: '300 - 350 ग्राम / 150 लीटर पानी',
      phiDays: '15 दिन',
      badgeColor: Color(0xFF2563EB),
    ),
    AgriProductModel(
      id: 'p5',
      name: 'Dhanuka EM-1 (Emamectin)',
      brand: 'Dhanuka Agritech',
      chemicalName: 'Emamectin Benzoate 5% SG',
      category: 'Insecticide',
      categoryHindi: 'कीटनाशक',
      targetPests: 'फॉल आर्मीवर्म, तना छेदक, फल छेदक (Helicoverpa)',
      targetCrops: 'मक्का, चना, कपास, टमाटर, गोभी',
      dosagePer15LTank: '8 - 10 ग्राम',
      dosagePerAcre: '80 - 100 ग्राम / 150 लीटर पानी',
      phiDays: '7 दिन',
      badgeColor: Color(0xFFDC2626),
    ),
    AgriProductModel(
      id: 'p6',
      name: 'KRIBHCO Bio-Fertilizer (Rhizobium)',
      brand: 'KRIBHCO',
      chemicalName: 'Rhizobium Leguminosarum Culture',
      category: 'Bio-Fertilizer',
      categoryHindi: 'जैविक उर्वरक संवर्धन',
      targetPests: 'प्राकृतिक नाइट्रोजन स्थिरीकरण (गठबंधन), मृदा स्वास्थ्य',
      targetCrops: 'चना, मटर, मूंग, उड़द, मसूर, सोयाबीन',
      dosagePer15LTank: 'बीजोपचार (Seed Treatment)',
      dosagePerAcre: '200 ग्राम प्रति 10-12 किग्रा बीज',
      phiDays: '100% प्राकृतिक',
      badgeColor: Color(0xFF16A34A),
    ),
    AgriProductModel(
      id: 'p7',
      name: 'NSC Certified Seeds (HD-2967)',
      brand: 'National Seeds Corp (NSC)',
      chemicalName: 'Certified Breeder Wheat Seed (ICAR-IARI)',
      category: 'Certified Seeds',
      categoryHindi: 'प्रमाणित बीज',
      targetPests: 'पीला रतुआ रोधी, उच्च ताप सहनशील व अधिक उपज',
      targetCrops: 'गेहूं (सिंचित समय पर बुवाई)',
      dosagePer15LTank: 'बीज बुवाई',
      dosagePerAcre: '40 किलोग्राम प्रति एकड़',
      phiDays: '125 - 130 दिन परिपक्वता',
      badgeColor: Color(0xFFD97706),
    ),
    AgriProductModel(
      id: 'p8',
      name: 'PI Industries Osheen',
      brand: 'PI Industries',
      chemicalName: 'Dinotefuran 20% SG',
      category: 'Insecticide',
      categoryHindi: 'कीटनाशक',
      targetPests: 'भूरा माहू (BPH), हरा तेला (Jassids), सफेद मक्खी',
      targetCrops: 'धान, कपास, मिर्च',
      dosagePer15LTank: '15 - 20 ग्राम',
      dosagePerAcre: '60 - 80 ग्राम / 150 लीटर पानी',
      phiDays: '14 दिन',
      badgeColor: Color(0xFFB45309),
    ),
  ];

  List<AgriProductModel> getAllProducts() {
    return List.unmodifiable(_catalog);
  }

  List<AgriProductModel> getProductsByCategory(String category) {
    if (category == 'All') return getAllProducts();
    return _catalog.where((p) => p.category == category).toList();
  }

  List<AgriProductModel> searchProducts(String query, {String category = 'All'}) {
    final lower = query.trim().toLowerCase();
    return _catalog.where((p) {
      final matchesCategory = category == 'All' || p.category == category;
      final matchesQuery = lower.isEmpty ||
          p.name.toLowerCase().contains(lower) ||
          p.brand.toLowerCase().contains(lower) ||
          p.chemicalName.toLowerCase().contains(lower) ||
          p.targetCrops.toLowerCase().contains(lower) ||
          p.targetPests.toLowerCase().contains(lower);
      return matchesCategory && matchesQuery;
    }).toList();
  }
}
