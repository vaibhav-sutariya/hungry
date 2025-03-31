class LocationModel {
  String? createdAt;
  String? address;
  String? phone;
  String? name;
  String? details;
  Location? location;
  List<String>? categories;
  String? updatedAt;
  double? distance = 0.0;

  LocationModel({
    this.createdAt,
    this.address,
    this.phone,
    this.name,
    this.details,
    this.location,
    this.categories,
    this.updatedAt,
    this.distance,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
    details = json['details'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    // Handle categories safely
    categories = json['categories'] != null
        ? List<String>.from(json['categories'])
        : <String>[];
    updatedAt = json['updatedAt'];
    distance = json['distance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['address'] = address;
    data['phone'] = phone;
    data['name'] = name;
    data['details'] = details;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['categories'] = categories;
    data['updatedAt'] = updatedAt;
    data['distance'] = distance;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
