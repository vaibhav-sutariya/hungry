import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/models/food_bank_model.dart';
import 'package:hungry/models/location_model.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';

class LocationDataRepository extends GetxController {
  final FindFoodController findFoodController = Get.put(FindFoodController());

  final DatabaseReference _locationsRef =
      FirebaseDatabase.instance.ref().child('locations');
  final DatabaseReference _foodBanksRef =
      FirebaseDatabase.instance.ref().child('FoodBanks');

  StreamSubscription<DatabaseEvent>? _locationSubscription;
  StreamSubscription<DatabaseEvent>? _foodBankSubscription;

  final RxList<FoodBankModel> foodBankList = <FoodBankModel>[].obs;
  final RxList<LocationModel> locationList = <LocationModel>[].obs;
  final RxList<dynamic> combinedDataList = <dynamic>[].obs;

  final RxBool isLoading = false.obs;

  Position? currentPosition;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      isLoading.value = true;
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );
      await fetchLocations();
      await fetchFoodBanks();
    } catch (e) {
      log("Error getting user location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _isWithinRange(double? lat, double? lon) {
    if (currentPosition == null || lat == null || lon == null) return false;

    if (lat.abs() > 90 || lon.abs() > 180) {
      log("⚠️ Invalid Coordinates - Latitude: $lat, Longitude: $lon");
      return false;
    }

    // Calculate the distance in meters
    double distance = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      lat,
      lon,
    );

    double distanceInKm = distance / 1000; // Convert meters to kilometers
    log("Distance (${currentPosition!.latitude} ${currentPosition!.longitude} ) to ($lat, $lon): $distanceInKm km");

    return distanceInKm <= 20; // Ensuring range is <= 20km
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;
      _locationSubscription?.cancel();
      locationList.clear();

      _locationSubscription = _locationsRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map<dynamic, dynamic> locationsMap = event.snapshot.value as Map;
          for (var userData in locationsMap.values) {
            log("🔥 Raw Firebase location Data: ${userData.toString()}");
            if (userData is Map) {
              for (var data in userData.values) {
                log("location Inner Data: ${data.toString()}");

                try {
                  final Map<String, dynamic> sanitizedData =
                      _sanitizeLocationData(data);
                  final locationModel = LocationModel.fromJson(sanitizedData);

                  if (locationModel.location != null &&
                      _isWithinRange(locationModel.location!.latitude,
                          locationModel.location!.longitude)) {
                    if (!locationList.any((l) =>
                        l.location != null &&
                        l.location!.latitude ==
                            locationModel.location!.latitude &&
                        l.location!.longitude ==
                            locationModel.location!.longitude)) {
                      locationList.add(locationModel);
                      combinedDataList.add(locationModel);

                      if (locationModel.name != null &&
                          locationModel.address != null) {
                        findFoodController.addMarker(
                          locationModel.location!.latitude!,
                          locationModel.location!.longitude!,
                          locationModel.name!,
                          locationModel.address!,
                        );
                      }
                    }
                  }
                } catch (e) {
                  log('Error parsing location data: $e');
                }
              }
            }
          }
        }
      });
    } catch (e) {
      log("Error fetching locations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFoodBanks() async {
    try {
      isLoading.value = true;
      _foodBankSubscription?.cancel();
      foodBankList.clear();

      _foodBankSubscription = _foodBanksRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map<dynamic, dynamic> foodBanksMap = event.snapshot.value as Map;
          for (var userData in foodBanksMap.values) {
            if (userData is Map) {
              log("🔥 Raw Firebase foodbank Data: ${userData.toString()}");

              for (var data in userData.values) {
                try {
                  final Map<String, dynamic> sanitizedData =
                      _sanitizeFoodBankData(data);
                  final foodBankModel = FoodBankModel.fromJson(sanitizedData);
                  log("🔥foodbank Inner Data: ${data.toString()}");

                  if (foodBankModel.location != null &&
                      _isWithinRange(foodBankModel.location!.latitude,
                          foodBankModel.location!.longitude)) {
                    if (!foodBankList.any((f) =>
                        f.location != null &&
                        f.location!.latitude ==
                            foodBankModel.location!.latitude &&
                        f.location!.longitude ==
                            foodBankModel.location!.longitude)) {
                      foodBankList.add(foodBankModel);
                      combinedDataList.add(foodBankModel);

                      if (foodBankModel.foodBankName != null &&
                          foodBankModel.address != null) {
                        findFoodController.addMarker(
                          foodBankModel.location!.latitude!,
                          foodBankModel.location!.longitude!,
                          foodBankModel.foodBankName!,
                          foodBankModel.address!,
                        );
                      }
                    }
                  }
                } catch (e) {
                  log('Error parsing food bank data: $e');
                }
              }
            }
          }
        }
      });
    } catch (e) {
      log("Error fetching food banks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _locationSubscription?.cancel();
    _foodBankSubscription?.cancel();
    super.onClose();
  }

  Map<String, dynamic> _sanitizeLocationData(dynamic data) {
    Map<String, dynamic> sanitizedData = <String, dynamic>{};

    if (data is Map) {
      sanitizedData['createdAt'] = data['createdAt']?.toString();
      sanitizedData['address'] = data['address']?.toString() ?? '';
      sanitizedData['phone'] = data['phone']?.toString();
      sanitizedData['name'] = data['name']?.toString() ?? '';
      sanitizedData['details'] = data['details']?.toString();

      if (data['location'] != null && data['location'] is Map) {
        sanitizedData['location'] = {
          'latitude': data['location']['latitude'] is num
              ? (data['location']['latitude'] as num).toDouble()
              : null,
          'longitude': data['location']['longitude'] is num
              ? (data['location']['longitude'] as num).toDouble()
              : null,
        };
      }

      // Handle categories safely
      if (data['categories'] != null && data['categories'] is List) {
        sanitizedData['categories'] = List<String>.from(
            (data['categories'] as List).map((item) => item.toString()));
      } else {
        sanitizedData['categories'] = <String>[];
      }

      sanitizedData['updatedAt'] = data['updatedAt']?.toString();
    }

    return sanitizedData;
  }

  Map<String, dynamic> _sanitizeFoodBankData(dynamic data) {
    Map<String, dynamic> sanitizedData = <String, dynamic>{};

    if (data is Map) {
      sanitizedData['email'] = data['email']?.toString();
      sanitizedData['createdAt'] = data['createdAt']?.toString();
      sanitizedData['foodBankName'] = data['foodBankName']?.toString() ?? '';
      sanitizedData['address'] = data['address']?.toString() ?? '';
      sanitizedData['phone'] = data['phone']?.toString();
      sanitizedData['name'] = data['name']?.toString() ?? '';

      if (data['location'] != null && data['location'] is Map) {
        sanitizedData['location'] = {
          'latitude': data['location']['latitude'] is num
              ? (data['location']['latitude'] as num).toDouble()
              : null,
          'longitude': data['location']['longitude'] is num
              ? (data['location']['longitude'] as num).toDouble()
              : null,
        };
      }

      if (data['services'] != null && data['services'] is Map) {
        sanitizedData['services'] = {
          'freeMealAvailable': data['services']['freeMealAvailable'] is bool
              ? data['services']['freeMealAvailable']
              : false,
          'minPeopleAccepted': data['services']['minPeopleAccepted'] is bool
              ? data['services']['minPeopleAccepted']
              : false,
          'acceptingRemainingFood':
              data['services']['acceptingRemainingFood'] is bool
                  ? data['services']['acceptingRemainingFood']
                  : false,
          'acceptingDonations': data['services']['acceptingDonations'] is bool
              ? data['services']['acceptingDonations']
              : false,
          'distributingToNeedyPerson':
              data['services']['distributingToNeedyPerson'] is bool
                  ? data['services']['distributingToNeedyPerson']
                  : false,
        };
      }

      sanitizedData['volunteers'] = data['volunteers'] is int
          ? data['volunteers']
          : (data['volunteers'] is String
              ? int.tryParse(data['volunteers'])
              : null);
      sanitizedData['updatedAt'] = data['updatedAt']?.toString();
    }

    return sanitizedData;
  }
}
