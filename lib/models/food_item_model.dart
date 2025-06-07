class FoodItemModel {
  final String id;
  final String fName;
  final String phone;
  final String address;
  final String numberOfPersons;
  final String details;
  final Map<String, dynamic> location;
  final String? status;
  final String createdAt;
  final String updatedAt;
  double? distance;

  FoodItemModel({
    required this.id,
    required this.fName,
    required this.phone,
    required this.address,
    required this.numberOfPersons,
    required this.details,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    this.distance,
  });

  factory FoodItemModel.fromMap(Map data, String id) {
    return FoodItemModel(
      id: id,
      fName: data['fName'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      numberOfPersons: data['numberOfPersons'] ?? '',
      details: data['details'] ?? '',
      location: Map<String, dynamic>.from(data['location'] ?? {}),
      status: data['status'],
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
    );
  }
}
