class LocationModel {
  final String address;
  final List<String> categories;
  final String details;
  final String name;
  final double latitude;
  final double longitude;
  final String phone;
  double distance = 0.0;
  final String createdAt;
  final String updatedAt;

  LocationModel({
    required this.address,
    required this.categories,
    required this.details,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.distance,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from a JSON object
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? '',
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      details: json['details'] ?? '',
      name: json['name'] ?? '',
      latitude:
          (json['location'] != null && json['location']['latitude'] != null)
              ? (json['location']['latitude'] as num).toDouble()
              : 0.0,
      longitude:
          (json['location'] != null && json['location']['longitude'] != null)
              ? (json['location']['longitude'] as num).toDouble()
              : 0.0,
      phone: json['phone'] ?? '',
      distance: json['distance'] ?? 0.0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  // Method to convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'categories': categories,
      'details': details,
      'fName': name,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'phone': phone,
      'distance': distance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
