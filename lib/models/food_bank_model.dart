class FoodBankModel {
  final String fName;
  final String foodNgoName;
  final String address;
  final String gmail;
  final double latitude;
  final double longitude;
  final String phone;
  final int volunteers;
  double distance = 0.0;

  FoodBankModel({
    required this.fName,
    required this.foodNgoName,
    required this.address,
    required this.gmail,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.volunteers,
    required this.distance,
  });

  // Factory constructor to create an instance from a JSON object
  factory FoodBankModel.fromJson(Map<String, dynamic> json) {
    return FoodBankModel(
      fName: json['Fname'] ?? '',
      foodNgoName: json['FoodNgoName'] ?? '',
      address: json['address'] ?? '',
      gmail: json['gmail'] ?? '',
      latitude:
          (json['location'] != null && json['location']['latitude'] != null)
              ? (json['location']['latitude'] as num).toDouble()
              : 0.0,
      longitude:
          (json['location'] != null && json['location']['longitude'] != null)
              ? (json['location']['longitude'] as num).toDouble()
              : 0.0,
      phone: json['phone'] ?? '',
      volunteers: int.tryParse(json['volunteers'].toString()) ??
          0, // Convert to integer safely
      distance: json['distance'] ?? 0.0,
    );
  }

  // Method to convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Fname': fName,
      'FoodNgoName': foodNgoName,
      'address': address,
      'gmail': gmail,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'phone': phone,
      'volunteers': volunteers.toString(),
      'distance': distance,
    };
  }
}
