import '../models/govt_scheme_model.dart';

class GovtSchemesService {
  final List<GovtSchemeModel> _schemes = [
    GovtSchemeModel(
      id: 'pm-kisan',
      title: 'PM-Kisan Samman Nidhi Yojana',
      titleHindi: 'प्रधानमंत्री किसान सम्मान निधि योजना',
      category: 'Income Support',
      categoryHindi: 'आय सहायता (Direct Benefit)',
      benefit: '₹6,000 per year directly credited in 3 equal installments of ₹2,000 every 4 months.',
      benefitHindi: '₹6,000 प्रति वर्ष, ₹2,000 की 3 समान किश्तों में सीधे बैंक खाते में DBT के माध्यम से।',
      eligibility: 'All landholding farmer families with cultivable land in their names. Excludes institutional landholders and income-tax payers.',
      eligibilityHindi: 'सभी भूमिधारक किसान परिवार जिनके नाम पर खेती योग्य जमीन है। सरकारी कर्मचारी व आयकर दाता अपात्र हैं।',
      requiredDocuments: [
        'Aadhaar Card linked to Mobile',
        'Land Ownership Record (Khatauni / Khasra / RoR)',
        'Active Bank Account linked to Aadhaar (NPCI enabled)',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड (मोबाइल से लिंक)',
        'जमीन की खतौनी / खसरा नकल',
        'आधार लिंक बैंक पासबुक (DBT सक्रिय)',
      ],
      portalUrl: 'https://pmkisan.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'pm-kusum',
      title: 'PM-KUSUM (Solar Agricultural Pump Scheme)',
      titleHindi: 'पीएम कुसुम योजना (सोलर सिंचाई पंप सब्सिडी)',
      category: 'Solar & Irrigation',
      categoryHindi: 'सौर ऊर्जा व सिंचाई',
      benefit: 'Up to 90% subsidy on stand-alone solar agricultural water pumps (3 HP, 5 HP, 7.5 HP).',
      benefitHindi: 'सोलर पंप (3 HP, 5 HP, 7.5 HP) लगाने पर केंद्र व राज्य सरकार द्वारा 90% तक की भारी सब्सिडी।',
      eligibility: 'Individual farmers, farmer groups, cooperatives, and water user associations with farmland requiring irrigation.',
      eligibilityHindi: 'व्यक्तिगत किसान, कृषक समूह या सहकारी समितियां जिनके पास सिंचाई हेतु कृषि भूमि उपलब्ध है।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Revenue Record / Khasra',
        'Bank Account Details',
        'Certificate of No Electrical Connection on tube well',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'जमीन की फर्द / खसरा-खतौनी',
        'बैंक खाता विवरण',
        'खेत में बिजली कनेक्शन न होने का शपथ पत्र',
      ],
      portalUrl: 'https://pmkusum.mnre.gov.in',
      nodalMinistry: 'Ministry of New & Renewable Energy (MNRE)',
    ),
    GovtSchemeModel(
      id: 'pmfby',
      title: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      titleHindi: 'प्रधानमंत्री फसल बीमा योजना (PMFBY)',
      category: 'Crop Insurance',
      categoryHindi: 'फसल बीमा व सुरक्षा',
      benefit: 'Comprehensive crop insurance against drought, floods, pests. Farmer premium: 1.5% for Rabi, 2% for Kharif, 5% for Horticulture.',
      benefitHindi: 'बाढ़, सूखा, कीट और ओलावृष्टि से नुकसान पर पूर्ण मुआवजा। किसान प्रीमियम मात्र: रबी 1.5%, खरीफ 2%, बागवानी 5%।',
      eligibility: 'All farmers (sharecroppers and tenant farmers included) growing notified crops in notified areas.',
      eligibilityHindi: 'अधिसूचित क्षेत्र में अधिसूचित फसल उगाने वाले सभी किसान (बटाईदार और काश्तकार किसान भी शामिल)।',
      requiredDocuments: [
        'Aadhaar Card',
        'Sowing Certificate / Self-Declaration from Patwari/Kisan Salahkar',
        'Land Possession Certificate (LPC) / Rent Agreement',
        'Bank Account details',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'बुवाई प्रमाण पत्र / स्व-घोषणा पत्र',
        'जमीन की रसीद या बटाईनामा अनुबंध',
        'बैंक खाता पासबुक',
      ],
      portalUrl: 'https://pmfby.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'kcc',
      title: 'Kisan Credit Card (KCC) Scheme',
      titleHindi: 'किसान क्रेडिट कार्ड (KCC) योजना',
      category: 'Credit & Loans',
      categoryHindi: 'सस्ता कृषि ऋण',
      benefit: 'Short-term credit up to ₹3,00,000 at concessional interest rate of 4% per annum (with prompt repayment incentive).',
      benefitHindi: 'खेती की लागत हेतु ₹3 लाख तक का अल्पकालिक कृषि ऋण केवल 4% वार्षिक ब्याज दर पर (समय पर भुगतान पर 3% छूट)।',
      eligibility: 'All individual farmers, joint borrowers, tenant farmers, and Self Help Groups (SHGs) engaged in agriculture or animal husbandry.',
      eligibilityHindi: 'सभी व्यक्तिगत किसान, बटाईदार और पशुपालन/मत्स्य पालन करने वाले किसान।',
      requiredDocuments: [
        'Filled KCC Application Form',
        'Identity & Address Proof (Aadhaar / Voter ID)',
        'Land Records verified by Revenue Authority',
        'Passport-sized photographs',
      ],
      requiredDocumentsHindi: [
        'KCC आवेदन प्रपत्र',
        'पहचान व निवास प्रमाण (आधार / वोटर आईडी)',
        'राजस्व अधिकारी द्वारा सत्यापित भू-अभिलेख',
        '2 पासपोर्ट साइज फोटो',
      ],
      portalUrl: 'https://www.myscheme.gov.in/schemes/kcc',
      nodalMinistry: 'Department of Financial Services & RBI',
    ),
    GovtSchemeModel(
      id: 'smam',
      title: 'Sub-Mission on Agricultural Mechanization (SMAM)',
      titleHindi: 'कृषि यंत्रीकरण उप-मिशन (SMAM - कृषि यंत्र सब्सिडी)',
      category: 'Machinery',
      categoryHindi: 'कृषि मशीनरी व उपकरण',
      benefit: '40% to 50% subsidy on purchase of Tractors, Rotavators, Power Tillers, Laser Land Levelers, and Seed Drills.',
      benefitHindi: 'ट्रैक्टर, रोटावेटर, पावर टिलर, लेजर लैंड लेवलर व सीड ड्रिल की खरीद पर 40% से 50% तक सरकारी अनुदान।',
      eligibility: 'Small and marginal farmers, SC/ST, and women farmers given special priority.',
      eligibilityHindi: 'लघु व सीमांत किसान। महिला, एससी/एसटी वर्ग के किसानों को प्राथमिकता व अतिरिक्त अनुदान।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Ownership Record (Khatauni)',
        'Caste Certificate (for SC/ST)',
        'Bank Passbook & Quotation from authorized dealer',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'जमीन की खतौनी',
        'जाति प्रमाण पत्र (यदि लागू हो)',
        'बैंक पासबुक व अधिकृत डीलर का कोटेशन',
      ],
      portalUrl: 'https://agrimachinery.nic.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'per-drop-more-crop',
      title: 'Per Drop More Crop (Micro Irrigation Scheme)',
      titleHindi: 'प्रति बूंद अधिक फसल (ड्रिप व स्प्रिंकलर सिंचाई सब्सिडी)',
      category: 'Solar & Irrigation',
      categoryHindi: 'सौर ऊर्जा व सिंचाई',
      benefit: '55% subsidy for small/marginal farmers and 45% for other farmers for installing Drip & Sprinkler irrigation systems.',
      benefitHindi: 'ड्रिप व स्प्रिंकलर सिंचाई सिस्टम लगाने पर छोटे/सीमांत किसानों को 55% तथा अन्य को 45% सब्सिडी।',
      eligibility: 'All farmers having cultivable land with an assured water source (borewell, tube well, canal).',
      eligibilityHindi: 'सभी किसान जिनके पास सिंचाई योग्य जमीन और निश्चित जल स्रोत (बोरवेल, कुआं, नहर) उपलब्ध है।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Map / Khasra Certificate',
        'Electricity Connection bill or Diesel pump details',
        'Bank Passbook',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'खेत का नक्शा / खसरा खतौनी',
        'सिंचाई जल स्रोत प्रमाण पत्र',
        'बैंक खाता पासबुक',
      ],
      portalUrl: 'https://pmksy.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'soil-health-card-scheme',
      title: 'Soil Health Card (SHC) Scheme',
      titleHindi: 'मृदा स्वास्थ्य कार्ड योजना (निःशुल्क मिट्टी जांच)',
      category: 'Organic',
      categoryHindi: 'मृदा स्वास्थ्य व परीक्षण',
      benefit: 'Free soil sample collection and laboratory testing across 12 parameters every 2 years, with customized fertilizer recommendations.',
      benefitHindi: 'प्रत्येक 2 वर्ष में खेत की मिट्टी का निःशुल्क नमूना परीक्षण और 12 पोषक तत्वों का विस्तृत स्वास्थ्य कार्ड।',
      eligibility: 'Every farmer owning or cultivating agricultural land in India.',
      eligibilityHindi: 'भारत में कृषि भूमि पर खेती करने वाला प्रत्येक किसान पात्र है।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Location Details (Village, Survey / Khasra number)',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'खेत का खसरा नंबर व गांव का नाम',
      ],
      portalUrl: 'https://soilhealth.dac.gov.in',
      nodalMinistry: 'Department of Agriculture and Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'pkvy',
      title: 'Paramparagat Krishi Vikas Yojana (PKVY)',
      titleHindi: 'परम्परागत कृषि विकास योजना (प्राकृतिक व जैविक खेती)',
      category: 'Organic',
      categoryHindi: 'प्राकृतिक खेती',
      benefit: 'Financial assistance of ₹50,000 per hectare over 3 years for adopting organic inputs, bio-fertilizers, and PGS certification.',
      benefitHindi: 'जैविक खेती अपनाने हेतु 3 वर्षों में ₹50,000 प्रति हेक्टेयर की आर्थिक सहायता व निःशुल्क जैविक प्रमाणीकरण।',
      eligibility: 'Farmers forming clusters of 20 or more hectares for chemical-free natural farming.',
      eligibilityHindi: 'किसानों के समूह (Clusters) जो रसायन-मुक्त प्राकृतिक व जैविक खेती अपनाते हैं।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Records',
        'Self-declaration of non-use of synthetic chemical fertilizers/pesticides',
        'Bank Account Details',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'भूमि अभिलेख',
        'रासायनिक कीटनाशक न डालने का स्व-घोषणा पत्र',
        'बैंक पासबुक',
      ],
      portalUrl: 'https://pgsindia-ncof.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
  ];

  List<GovtSchemeModel> getAllSchemes() => _schemes;

  List<String> getCategories({bool isHindi = true}) {
    return isHindi
        ? ['सभी योजनाएं', 'आय सहायता (Direct Benefit)', 'फसल बीमा व सुरक्षा', 'सौर ऊर्जा व सिंचाई', 'कृषि मशीनरी व उपकरण', 'सस्ता कृषि ऋण', 'प्राकृतिक खेती']
        : ['All Schemes', 'Income Support', 'Crop Insurance', 'Solar & Irrigation', 'Machinery', 'Credit & Loans', 'Organic'];
  }

  List<GovtSchemeModel> filterSchemes({String? category, String? searchQuery}) {
    return _schemes.where((scheme) {
      if (category != null && category != 'All Schemes' && category != 'सभी योजनाएं') {
        final matchesCat = scheme.category.toLowerCase().contains(category.toLowerCase()) ||
            scheme.categoryHindi.toLowerCase().contains(category.toLowerCase());
        if (!matchesCat) return false;
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase().trim();
        final matchesTitle = scheme.title.toLowerCase().contains(q) ||
            scheme.titleHindi.toLowerCase().contains(q) ||
            scheme.benefitHindi.toLowerCase().contains(q) ||
            scheme.benefit.toLowerCase().contains(q);
        if (!matchesTitle) return false;
      }

      return true;
    }).toList();
  }
}
