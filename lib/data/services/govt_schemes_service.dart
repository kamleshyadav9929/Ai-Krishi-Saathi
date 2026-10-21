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
      eligibility: 'All farmers growing notified crops in notified areas, including sharecroppers and tenant farmers.',
      eligibilityHindi: 'अधिसूचित क्षेत्रों में अधिसूचित फसल उगाने वाले सभी किसान, जिसमें बटाईदार और काश्तकार भी शामिल हैं।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Possession Certificate (LPC) / Rent Agreement',
        'Sowing Certificate / Self-Declaration',
        'Bank Passbook with IFSC',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'भूमि स्वामित्व प्रमाण पत्र (LPC) / बटाईदारी अनुबंध',
        'बुवाई प्रमाण पत्र / स्व-घोषणा',
        'बैंक पासबुक की प्रति',
      ],
      portalUrl: 'https://pmfby.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'kcc',
      title: 'Kisan Credit Card (KCC) Scheme',
      titleHindi: 'किसान क्रेडिट कार्ड (KCC) रियायती कृषि ऋण',
      category: 'Credit & Loans',
      categoryHindi: 'सस्ता कृषि ऋण',
      benefit: 'Short-term credit up to ₹3,00,000 at an effective interest rate of only 4% per annum (with prompt repayment incentive).',
      benefitHindi: 'समय पर भुगतान करने पर मात्र 4% वार्षिक ब्याज दर पर ₹3 लाख तक का सस्ता कृषि ऋण (बिना किसी गारंटी के ₹1.6 लाख तक)।',
      eligibility: 'All farmers, individual/joint borrowers, tenant farmers, oral lessees, and Self Help Groups (SHGs). Also covers animal husbandry and fisheries.',
      eligibilityHindi: 'सभी किसान, बटाईदार, पट्टाधारक व स्वयं सहायता समूह। अब पशुपालन व मछली पालक किसानों के लिए भी उपलब्ध।',
      requiredDocuments: [
        'Duly filled Application Form',
        'Identity Proof (Aadhaar / Voter ID)',
        'Land Revenue Records / Land Title',
        'Crop Sowing Declaration',
      ],
      requiredDocumentsHindi: [
        'विधिवत भरा हुआ आवेदन पत्र',
        'पहचान पत्र (आधार / वोटर आईडी)',
        'जमीन के कागजात (खतौनी नकल)',
        'फसल बुवाई का ब्योरा',
      ],
      portalUrl: 'https://www.myscheme.gov.in/schemes/kcc',
      nodalMinistry: 'Department of Financial Services / MoA&FW',
    ),
    GovtSchemeModel(
      id: 'smam',
      title: 'Sub-Mission on Agricultural Mechanization (SMAM)',
      titleHindi: 'कृषि यंत्रीकरण उप-मिशन (कृषि यंत्र अनुदान)',
      category: 'Machinery',
      categoryHindi: 'कृषि मशीनरी व उपकरण',
      benefit: '40% to 50% subsidy on procurement of tractors, rotavators, happy seeders, laser levellers, and harvesters.',
      benefitHindi: 'ट्रैक्टर, रोटावेटर, हैप्पी सीडर, लेजर लैंड लेवलर व थ्रेशर की खरीद पर 40% से 50% तक सरकारी अनुदान।',
      eligibility: 'Individual farmers (special priority for small/marginal, women, SC/ST farmers) and registered Farmer Producer Organizations (FPOs).',
      eligibilityHindi: 'व्यक्तिगत किसान (लघु-सीमांत, महिला व अनुसूचित जाति/जनजाति को प्राथमिकता) व FPO।',
      requiredDocuments: [
        'Aadhaar Card',
        'Caste Certificate (if applicable)',
        'Land Revenue Record',
        'Bank Account Passbook',
        'Quotation from Authorized Dealer',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'जाति प्रमाण पत्र (यदि लागू हो)',
        'जमीन के दस्तावेज (खतौनी)',
        'बैंक खाता पासबुक',
        'अधिकृत डीलर का कोटेशन / बिल',
      ],
      portalUrl: 'https://agrimachinery.nic.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'per-drop-more-crop',
      title: 'Per Drop More Crop (Micro-Irrigation)',
      titleHindi: 'प्रति बूंद अधिक फसल (ड्रिप व स्प्रिंकलर सब्सिडी)',
      category: 'Solar & Irrigation',
      categoryHindi: 'सौर ऊर्जा व सिंचाई',
      benefit: 'Up to 55% subsidy for small and marginal farmers, and 45% for other farmers on Drip and Sprinkler irrigation systems.',
      benefitHindi: 'ड्रिप (टपक) व स्प्रिंकलर (फव्वारा) सिंचाई प्रणाली लगाने पर लघु व सीमांत किसानों को 55% तक सब्सिडी।',
      eligibility: 'Farmers of all categories having suitable cultivable land and an assured water source on their farm.',
      eligibilityHindi: 'सभी श्रेणी के किसान जिनके पास खेती योग्य जमीन और खेत पर सिंचाई का निश्चित जल स्रोत उपलब्ध हो।',
      requiredDocuments: [
        'Aadhaar Card',
        'Proof of Land Ownership (Jamabandi / Khasra)',
        'Electricity Bill / Diesel Engine Details for Water Source',
        'Bank Passbook',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'जमीन की नकल / जमाबंदी',
        'जल स्रोत व पंप का विवरण',
        'बैंक पासबुक',
      ],
      portalUrl: 'https://pmksy.gov.in/microirrigation',
      nodalMinistry: 'Department of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'soil-health-card',
      title: 'Soil Health Card Scheme',
      titleHindi: 'मृदा स्वास्थ्य कार्ड योजना (मुफ्त मिट्टी जांच)',
      category: 'Organic & Soil',
      categoryHindi: 'प्राकृतिक खेती व मिट्टी',
      benefit: 'Free testing of 12 soil parameters (N, P, K, S, Zn, Fe, Cu, Mn, Bo, pH, EC, OC) and crop-specific fertilizer advisory every 3 years.',
      benefitHindi: '12 प्रमुख पोषक तत्वों की निशुल्क मिट्टी जांच व फसल के अनुसार खाद-उर्वरक की सही मात्रा की सिफारिश।',
      eligibility: 'All farmers cultivating agricultural land in India.',
      eligibilityHindi: 'भारत के सभी किसान जो कृषि भूमि पर खेती करते हैं।',
      requiredDocuments: [
        'Soil Sample from Farm (sampled as per guidelines)',
        'Farmer Aadhaar and Mobile Number',
        'Field Khasra Number',
      ],
      requiredDocumentsHindi: [
        'खेत से सही विधि से लिया गया मिट्टी का नमूना',
        'किसान का आधार व मोबाइल नंबर',
        'खेत का खसरा नंबर',
      ],
      portalUrl: 'https://soilhealth.dac.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'pkvy',
      title: 'Paramparagat Krishi Vikas Yojana (PKVY)',
      titleHindi: 'परम्परागत कृषि विकास योजना (जैविक खेती)',
      category: 'Organic & Soil',
      categoryHindi: 'प्राकृतिक खेती व मिट्टी',
      benefit: 'Financial assistance of ₹50,000 per hectare over 3 years, of which ₹31,000 is given directly for organic inputs (bio-fertilizers, vermicompost).',
      benefitHindi: '3 साल में ₹50,000 प्रति हेक्टेयर की सहायता, जिसमें ₹31,000 जैविक खाद, वर्मीकम्पोस्ट व जैव-कीटनाशकों हेतु सीधे किसान को।',
      eligibility: 'Farmers willing to form clusters of 20 or more hectares and adopt organic farming practices certified under PGS-India.',
      eligibilityHindi: 'किसान जो 20 या अधिक हेक्टेयर का क्लस्टर बनाकर जैविक खेती अपनाने को तैयार हों।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Records',
        'Self-declaration of non-chemical farming',
        'Bank Passbook',
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
    GovtSchemeModel(
      id: 'kisan-drone',
      title: 'Kisan Drone Subsidy Scheme',
      titleHindi: 'किसान ड्रोन सब्सिडी योजना (कीटनाशक छिड़काव ड्रोन)',
      category: 'Machinery',
      categoryHindi: 'कृषि मशीनरी व उपकरण',
      benefit: 'Up to 50% or ₹5,00,000 financial assistance for SC/ST, women, and small farmers to purchase agriculture drones.',
      benefitHindi: 'कीटनाशक व तरल नैनो यूरिया छिड़काव ड्रोन खरीदने पर लघु-सीमांत, महिला व SC/ST किसानों को 50% (अधिकतम ₹5 लाख) तक सब्सिडी।',
      eligibility: 'Individual farmers with remote pilot certificate, FPOs, and custom hiring centers.',
      eligibilityHindi: 'प्रमाणित ड्रोन पायलट प्रशिक्षण प्राप्त किसान, FPO व कस्टम हायरिंग केंद्र।',
      requiredDocuments: [
        'Aadhaar Card',
        'DGCA Remote Pilot Certificate',
        'Land Records / CHC Registration',
        'Bank Account Details',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'डीजीसीए ड्रोन पायलट प्रमाण पत्र',
        'जमीन के कागजात या सीएचसी पंजीकरण',
        'बैंक पासबुक',
      ],
      portalUrl: 'https://agrimachinery.nic.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'aif-loan',
      title: 'Agriculture Infrastructure Fund (AIF)',
      titleHindi: 'कृषि अवसंरचना कोष (गोदाम व कोल्ड स्टोरेज ऋण)',
      category: 'Credit & Loans',
      categoryHindi: 'सस्ता कृषि ऋण',
      benefit: 'Collateral-free loans up to ₹2 Crore with 3% annual interest subvention for post-harvest storage, pack houses, and grading units.',
      benefitHindi: 'कोल्ड स्टोरेज, वेयरहाउस, सॉर्टिंग-ग्रेडिंग यूनिट और प्राथमिक प्रसंस्करण इकाई लगाने हेतु 3% ब्याज छूट के साथ ₹2 करोड़ तक का ऋण।',
      eligibility: 'Farmers, Agri-entrepreneurs, FPOs, Startups, and Primary Agricultural Credit Societies (PACS).',
      eligibilityHindi: 'किसान, कृषि उद्यमी, FPO, स्टार्ट-अप व पैक्स (PACS)।',
      requiredDocuments: [
        'Detailed Project Report (DPR)',
        'Land Ownership / Long-term Lease Agreement',
        'Aadhaar & PAN Card',
        'Bank Credit Clearance',
      ],
      requiredDocumentsHindi: [
        'परियोजना विस्तृत रिपोर्ट (DPR)',
        'जमीन की मिल्कियत / दीर्घकालिक लीज दस्तावेज',
        'आधार व पैन कार्ड',
        'बैंक खाता विवरण',
      ],
      portalUrl: 'https://agriinfra.dac.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'midh-horticulture',
      title: 'Mission for Integrated Development of Horticulture (MIDH)',
      titleHindi: 'राष्ट्रीय बागवानी मिशन (पॉलीहाउस व फल-सब्जी बागवानी)',
      category: 'Machinery',
      categoryHindi: 'कृषि मशीनरी व उपकरण',
      benefit: 'Up to 50% subsidy on polyhouse/shade-net installation, high-density orchards, mushroom units, and cold storage vans.',
      benefitHindi: 'पॉलीहाउस, शेडनेट हाउस, फलदार बाग लगाने, मशरूम उत्पादन व रेफ्रिजरेटेड वैन पर 50% तक सरकारी अनुदान।',
      eligibility: 'Farmers with cultivable land interested in fruit, vegetable, flower, or spice cultivation.',
      eligibilityHindi: 'फल, सब्जी, फूल या मसाला खेती करने वाले किसान जिनके पास उपयुक्त जमीन उपलब्ध है।',
      requiredDocuments: [
        'Aadhaar Card',
        'Land Ownership Record (Khatauni)',
        'Soil and Water Test Report',
        'Vendor Cost Estimate',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'खसरा-खतौनी नकल',
        'मिट्टी व पानी जांच रिपोर्ट',
        'पॉलीहाउस निर्माण का अधिकृत कोटेशन',
      ],
      portalUrl: 'https://midh.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
    GovtSchemeModel(
      id: 'enam-portal',
      title: 'e-NAM (National Agriculture Market)',
      titleHindi: 'ई-नाम (एक देश एक बाजार — ऑनलाइन मंडी)',
      category: 'Income Support',
      categoryHindi: 'आय सहायता (Direct Benefit)',
      benefit: 'Sell farm produce directly to buyers across 1,000+ national APMC mandis online with transparent competitive bidding and zero commission leakage.',
      benefitHindi: 'बिचौलियों के बिना पूरे देश की 1,000 से अधिक APMC मंडियों में अपनी फसल ऑनलाइन बेचें, पारदर्शी नीलामी से अधिकतम मूल्य पाएं।',
      eligibility: 'All farmers possessing agricultural harvest looking to sell their crops in registered APMCs.',
      eligibilityHindi: 'सभी किसान जो अपनी कृषि उपज को पंजीकृत मंडियों में ऑनलाइन बेचना चाहते हैं।',
      requiredDocuments: [
        'Farmer Aadhaar Card',
        'Active Bank Account Details (Passbook / Cancelled Cheque)',
        'Mandi Gate Pass / Lot Slip',
      ],
      requiredDocumentsHindi: [
        'आधार कार्ड',
        'बैंक पासबुक प्रति / रद्द चेक',
        'मंडी गेट पास या फसल लॉट पर्ची',
      ],
      portalUrl: 'https://enam.gov.in',
      nodalMinistry: 'Ministry of Agriculture & Farmers Welfare',
    ),
  ];

  List<GovtSchemeModel> getAllSchemes() => _schemes;

  List<String> getCategories({bool isHindi = true}) {
    return isHindi
        ? [
            'सभी योजनाएं',
            'आय सहायता (Direct Benefit)',
            'फसल बीमा व सुरक्षा',
            'सौर ऊर्जा व सिंचाई',
            'कृषि मशीनरी व उपकरण',
            'सस्ता कृषि ऋण',
            'प्राकृतिक खेती व मिट्टी',
          ]
        : [
            'All Schemes',
            'Income Support',
            'Crop Insurance',
            'Solar & Irrigation',
            'Machinery',
            'Credit & Loans',
            'Organic & Soil',
          ];
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
            scheme.benefit.toLowerCase().contains(q) ||
            scheme.eligibilityHindi.toLowerCase().contains(q) ||
            scheme.eligibility.toLowerCase().contains(q);
        if (!matchesTitle) return false;
      }

      return true;
    }).toList();
  }
}
