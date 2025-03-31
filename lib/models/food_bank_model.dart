class FoodBankModel {
  String? email;
  String? createdAt;
  String? foodBankName;
  String? address;
  String? phone;
  String? name;
  Location? location;
  Services? services;
  int? volunteers;
  String? updatedAt;
  double? distance;

  FoodBankModel(
      {this.email,
      this.createdAt,
      this.foodBankName,
      this.address,
      this.phone,
      this.name,
      this.location,
      this.services,
      this.volunteers,
      this.updatedAt,
      this.distance});

  FoodBankModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    createdAt = json['createdAt'];
    foodBankName = json['FoodBankName'];
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    services =
        json['services'] != null ? Services.fromJson(json['services']) : null;
    volunteers = json['volunteers'];
    updatedAt = json['updatedAt'];
    distance = json['distance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['foodBankName'] = foodBankName;
    data['address'] = address;
    data['phone'] = phone;
    data['name'] = name;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (services != null) {
      data['services'] = services!.toJson();
    }
    data['volunteers'] = volunteers;
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

class Services {
  bool? freeMealAvailable;
  bool? minPeopleAccepted;
  bool? acceptingRemainingFood;
  bool? acceptingDonations;
  bool? distributingToNeedyPerson;

  Services(
      {this.freeMealAvailable,
      this.minPeopleAccepted,
      this.acceptingRemainingFood,
      this.acceptingDonations,
      this.distributingToNeedyPerson});

  Services.fromJson(Map<String, dynamic> json) {
    freeMealAvailable = json['freeMealAvailable'];
    minPeopleAccepted = json['minPeopleAccepted'];
    acceptingRemainingFood = json['acceptingRemainingFood'];
    acceptingDonations = json['acceptingDonations'];
    distributingToNeedyPerson = json['distributingToNeedyPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['freeMealAvailable'] = freeMealAvailable;
    data['minPeopleAccepted'] = minPeopleAccepted;
    data['acceptingRemainingFood'] = acceptingRemainingFood;
    data['acceptingDonations'] = acceptingDonations;
    data['distributingToNeedyPerson'] = distributingToNeedyPerson;
    return data;
  }
}
