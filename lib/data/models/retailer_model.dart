class RetailerModel {
  final String id;
  final String name;
  final String ownerName;
  final String address;
  final String district;
  final String state;
  final String distance;
  final String phone;
  final String licenseNumber;
  final String centerType; // 'PMKSK', 'Cooperative', 'Licensed Agrotech'
  final String centerTypeHindi;
  final bool isGovtCertified;
  final List<String> inventory;

  const RetailerModel({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.district,
    required this.state,
    required this.distance,
    required this.phone,
    required this.licenseNumber,
    required this.centerType,
    required this.centerTypeHindi,
    required this.isGovtCertified,
    required this.inventory,
  });

  factory RetailerModel.fromJson(Map<String, dynamic> json) {
    return RetailerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      district: json['district'] as String? ?? '',
      state: json['state'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      licenseNumber: json['licenseNumber'] as String? ?? '',
      centerType: json['centerType'] as String? ?? 'Licensed Agrotech',
      centerTypeHindi: json['centerTypeHindi'] as String? ?? 'अधिकृत कृषि केंद्र',
      isGovtCertified: json['isGovtCertified'] as bool? ?? true,
      inventory: (json['inventory'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerName': ownerName,
      'address': address,
      'district': district,
      'state': state,
      'distance': distance,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'centerType': centerType,
      'centerTypeHindi': centerTypeHindi,
      'isGovtCertified': isGovtCertified,
      'inventory': inventory,
    };
  }
}
