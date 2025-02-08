class LocationModel {
  final String id;
  final String firstName;
  final String address;
  final String location;

  LocationModel({
    required this.id,
    required this.firstName,
    required this.address,
    required this.location,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      firstName: json['Fname'] ?? '',
      address: json['address'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Fname': firstName,
      'address': address,
      'location': location,
    };
  }
}
