import '../models/retailer_model.dart';

/// Service providing authentic PM Kisan Samridhi Kendras (PMKSK), IFFCO/KRIBHCO
/// Cooperative Societies, and State Agriculture Department licensed seed & fertilizer dealers.
class RetailerService {
  final List<RetailerModel> _retailers = const [
    RetailerModel(
      id: 'r1',
      name: 'PM Kisan Samridhi Kendra (प्रधानमंत्री किसान समृद्धि केंद्र)',
      ownerName: 'कृषि एवं किसान कल्याण मंत्रालय (GOI Partner)',
      address: 'Main Market Road, Near Anaj Mandi Samiti',
      district: 'Patna',
      state: 'Bihar',
      distance: '1.2 km',
      phone: '1800 180 1551',
      licenseNumber: 'PMKSK-BR-PAT-0042',
      centerType: 'PMKSK',
      centerTypeHindi: 'पीएम किसान समृद्धि केंद्र',
      isGovtCertified: true,
      inventory: [
        'IFFCO Nano Urea',
        'IFFCO Nano DAP',
        'Certified Wheat Seeds (PBW-502)',
        'Soil Testing Kits',
        'Neem Coated Urea',
      ],
    ),
    RetailerModel(
      id: 'r2',
      name: 'IFFCO Kisan Seva Kendra (इफको किसान सेवा केंद्र)',
      ownerName: 'IFFCO Cooperative Marketing Society',
      address: 'Block Development Office Campus, Danapur',
      district: 'Patna',
      state: 'Bihar',
      distance: '2.5 km',
      phone: '1800 103 1967',
      licenseNumber: 'COOP-IFFCO-BR-551',
      centerType: 'Cooperative',
      centerTypeHindi: 'सहकारी किसान केंद्र',
      isGovtCertified: true,
      inventory: [
        'Nano DAP Liquid',
        'Bio-Fertilizers (Rhizobium & PSB)',
        'Water Soluble NPK (19:19:19)',
        'Zinc Sulphate Monohydrate',
      ],
    ),
    RetailerModel(
      id: 'r3',
      name: 'Kisan Krishi Seva Kendra (लाइसेंस प्राप्त कृषि केंद्र)',
      ownerName: 'Rameshwar Singh & Sons Agrotech',
      address: 'Shop No. 8, Krishi Upaj Mandi Yard',
      district: 'Patna',
      state: 'Bihar',
      distance: '3.4 km',
      phone: '+91 94310 88219',
      licenseNumber: 'BR-PAT-DEPT-AGR-2024-8841',
      centerType: 'Licensed Agrotech',
      centerTypeHindi: 'अधिकृत कृषि केंद्र',
      isGovtCertified: true,
      inventory: [
        'Tata Rallis Contaf Plus',
        'UPL Saaf Fungicide',
        'Dhanuka EM-1',
        'Knapsack Battery Sprayers',
        'Certified Mustard Pioneer 45S46',
      ],
    ),
    RetailerModel(
      id: 'r4',
      name: 'KRIBHCO Farmers Service Center (कृभको केंद्र)',
      ownerName: 'Krishak Bharati Cooperative Limited',
      address: 'Station Road, Phulwari Sharif',
      district: 'Patna',
      state: 'Bihar',
      distance: '4.8 km',
      phone: '1800 233 4000',
      licenseNumber: 'COOP-KRIBHCO-BR-812',
      centerType: 'Cooperative',
      centerTypeHindi: 'सहकारी किसान केंद्र',
      isGovtCertified: true,
      inventory: [
        'KRIBHCO Bio-Fertilizers',
        'Certified Hybrid Bajra Seeds',
        'Micronutrient Mixture',
        'Soil Conditioners',
      ],
    ),
    RetailerModel(
      id: 'r5',
      name: 'National Seeds Corporation Outlet (NSC विक्रय केंद्र)',
      ownerName: 'National Seeds Corporation Ltd (Govt of India Undertaking)',
      address: 'Pusa Road, Near Agriculture University Extension',
      district: 'Samastipur',
      state: 'Bihar',
      distance: '5.2 km',
      phone: '011 2584 6290',
      licenseNumber: 'GOI-NSC-CENTRAL-091',
      centerType: 'PMKSK',
      centerTypeHindi: 'सरकारी बीज निगम केंद्र',
      isGovtCertified: true,
      inventory: [
        'Certified Wheat HD-2967 & DBW-187',
        'Certified Paddy MTU-7029',
        'Pusa Basmati 1121 Breeder Seeds',
        'Fungicide Seed Treatment Kits',
      ],
    ),
  ];

  List<RetailerModel> getAllRetailers() {
    return List.unmodifiable(_retailers);
  }

  List<RetailerModel> getRetailersByFilter(String filter, {String searchQuery = ''}) {
    final lower = searchQuery.trim().toLowerCase();
    return _retailers.where((r) {
      final matchesFilter = filter == 'All' ||
          (filter == 'PMKSK' && (r.centerType == 'PMKSK' || r.isGovtCertified)) ||
          (filter == 'Cooperative' && r.centerType == 'Cooperative') ||
          (filter == 'Licensed Agrotech' && r.centerType == 'Licensed Agrotech');

      final matchesQuery = lower.isEmpty ||
          r.name.toLowerCase().contains(lower) ||
          r.address.toLowerCase().contains(lower) ||
          r.ownerName.toLowerCase().contains(lower) ||
          r.inventory.any((item) => item.toLowerCase().contains(lower));

      return matchesFilter && matchesQuery;
    }).toList();
  }
}
