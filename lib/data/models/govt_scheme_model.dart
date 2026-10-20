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
  });
}
