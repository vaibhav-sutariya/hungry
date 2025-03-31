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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );
      await fetchLocations();
      await fetchFoodBanks();
    } catch (e) {
      log("Error getting user location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _isWithinRange(double lat, double lon) {
    if (currentPosition == null) return false;
    double distance = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          lat,
          lon,
        ) /
        1000;
    log("Distance: $distance");
    return distance < 200000; // 20 km radius
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;
      _locationSubscription?.cancel(); // Cancel any existing subscription
      locationList.clear(); // Clear list before fetching

      _locationSubscription = _locationsRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map<dynamic, dynamic> locationsMap = event.snapshot.value as Map;
          for (var userData in locationsMap.values) {
            if (userData is Map) {
              for (var data in userData.values) {
                try {
                  final locationModel =
                      LocationModel.fromJson(_sanitizeData(data));

                  if (_isWithinRange(
                      locationModel.latitude, locationModel.longitude)) {
                    // Ensure data is not duplicated
                    if (!locationList.any((l) =>
                        l.latitude == locationModel.latitude &&
                        l.longitude == locationModel.longitude)) {
                      locationList.add(locationModel);
                      combinedDataList.add(locationModel);
                      findFoodController.addMarker(
                        locationModel.latitude,
                        locationModel.longitude,
                        locationModel.name,
                        locationModel.address,
                      );
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
      _foodBankSubscription?.cancel(); // Cancel any existing subscription
      foodBankList.clear(); // Clear list before fetching

      _foodBankSubscription = _foodBanksRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map<dynamic, dynamic> foodBanksMap = event.snapshot.value as Map;
          for (var userData in foodBanksMap.values) {
            if (userData is Map) {
              for (var data in userData.values) {
                try {
                  final foodBankModel =
                      FoodBankModel.fromJson(_sanitizeData(data));

                  if (_isWithinRange(
                      foodBankModel.latitude, foodBankModel.longitude)) {
                    // Ensure data is not duplicated
                    if (!foodBankList.any((f) =>
                        f.latitude == foodBankModel.latitude &&
                        f.longitude == foodBankModel.longitude)) {
                      foodBankList.add(foodBankModel);
                      combinedDataList.add(foodBankModel);
                      findFoodController.addMarker(
                        foodBankModel.latitude,
                        foodBankModel.longitude,
                        foodBankModel.foodNgoName,
                        foodBankModel.address,
                      );
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

  /// Ensures data types are correct for parsing
  Map<String, dynamic> _sanitizeData(dynamic data) {
    return {
      'latitude': _parseDouble(data['latitude']),
      'longitude': _parseDouble(data['longitude']),
      'name': data['name']?.toString() ?? '',
      'address': data['address']?.toString() ?? '',
    };
  }

  /// Converts value to double safely
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
