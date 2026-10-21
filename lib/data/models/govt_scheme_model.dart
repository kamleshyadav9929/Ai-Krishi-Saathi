class GovtSchemeModel {
  final String id;
  final String title;
  final String titleHindi;
  final String category; // Income, Insurance, Solar/Irrigation, Machinery, Loan, Organic
  final String categoryHindi;
  final String benefit;
  final String benefitHindi;
  final String eligibility;
  final String eligibilityHindi;
  final List<String> requiredDocuments;
  final List<String> requiredDocumentsHindi;
  final String portalUrl;
  final String nodalMinistry;
  final String? helpline;
  final String? latestAnnouncement;
  final String? portalStatus;
  final String? lastUpdated;
  final bool isLiveUpdated;

  GovtSchemeModel({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.category,
    required this.categoryHindi,
    required this.benefit,
    required this.benefitHindi,
    required this.eligibility,
    required this.eligibilityHindi,
    required this.requiredDocuments,
    required this.requiredDocumentsHindi,
    required this.portalUrl,
    required this.nodalMinistry,
    this.helpline,
    this.latestAnnouncement,
    this.portalStatus,
    this.lastUpdated,
    this.isLiveUpdated = false,
  });

  factory GovtSchemeModel.fromJson(Map<String, dynamic> json) {
    return GovtSchemeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleHindi: json['titleHindi'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      categoryHindi: json['categoryHindi'] as String? ?? 'सामान्य योजना',
      benefit: json['benefit'] as String? ?? '',
      benefitHindi: json['benefitHindi'] as String? ?? '',
      eligibility: json['eligibility'] as String? ?? '',
      eligibilityHindi: json['eligibilityHindi'] as String? ?? '',
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      requiredDocumentsHindi: (json['requiredDocumentsHindi'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      portalUrl: json['portalUrl'] as String? ?? '',
      nodalMinistry: json['nodalMinistry'] as String? ?? '',
      helpline: json['helpline'] as String?,
      latestAnnouncement: json['latestAnnouncement'] as String?,
      portalStatus: json['portalStatus'] as String?,
      lastUpdated: json['lastUpdated'] as String?,
      isLiveUpdated: json['isLiveUpdated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleHindi': titleHindi,
      'category': category,
      'categoryHindi': categoryHindi,
      'benefit': benefit,
      'benefitHindi': benefitHindi,
      'eligibility': eligibility,
      'eligibilityHindi': eligibilityHindi,
      'requiredDocuments': requiredDocuments,
      'requiredDocumentsHindi': requiredDocumentsHindi,
      'portalUrl': portalUrl,
      'nodalMinistry': nodalMinistry,
      if (helpline != null) 'helpline': helpline,
      if (latestAnnouncement != null) 'latestAnnouncement': latestAnnouncement,
      if (portalStatus != null) 'portalStatus': portalStatus,
      if (lastUpdated != null) 'lastUpdated': lastUpdated,
      'isLiveUpdated': isLiveUpdated,
    };
  }
}
