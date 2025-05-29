class LeftoverFood {
  final String id;
  final String fName;
  final String phone;
  final String address;
  final String numberOfPersons;
  final String details;
  final String createdAt;
  final String updatedAt;
  final double latitude;
  final double longitude;

  LeftoverFood({
    required this.id,
    required this.fName,
    required this.phone,
    required this.address,
    required this.numberOfPersons,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
  });

  factory LeftoverFood.fromJson(String id, Map<dynamic, dynamic> json) {
    return LeftoverFood(
      id: id,
      fName: json['fName'] ?? 'Unknown',
      phone: json['phone'] ?? 'N/A',
      address: json['address'] ?? 'No address provided',
      numberOfPersons: json['numberOfPersons'] ?? '0',
      details: json['details'] ?? 'No details provided',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      latitude: (json['location']?['latitude'] ?? 0.0).toDouble(),
      longitude: (json['location']?['longitude'] ?? 0.0).toDouble(),
    );
  }
}
