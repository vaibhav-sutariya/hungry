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

  final RxBool isLoading = false.obs; // Loading state

  Position? _currentPosition;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      isLoading.value = true; // Start loading
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await fetchLocations();
      await fetchFoodBanks();
    } catch (e) {
      log("Error getting user location: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  bool _isWithinRange(double lat, double lon) {
    if (_currentPosition == null) return false;
    double distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          lat,
          lon,
        ) /
        1000;
    log("Distance: $distance");
    return distance < 20;
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true; // Start loading
      _locationSubscription = _locationsRef.onValue.listen((event) {
        locationList.clear();
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map<dynamic, dynamic> locationsMap = event.snapshot.value as Map;
          locationsMap.forEach((userId, userData) {
            if (userData is Map) {
              userData.forEach((id, data) {
                try {
                  final locationModel =
                      LocationModel.fromJson(_sanitizeData(data));
                  log("Location Model: ${locationModel.fName}");
                  if (_isWithinRange(
                      locationModel.latitude, locationModel.longitude)) {
                    double distance = Geolocator.distanceBetween(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                          locationModel.latitude,
                          locationModel.longitude,
                        ) /
                        1000;

                    locationModel.distance = distance; // Store distance
                    locationList.add(locationModel);
                    combinedDataList.add(locationModel);
                    log("Combined Data List: $combinedDataList");
                    findFoodController.addMarker(
                      locationModel.latitude,
                      locationModel.longitude,
                      locationModel.fName,
                      locationModel.address,
                    );
                    log("Location Added: ${locationModel.fName}");
                  }
                } catch (e) {
                  log('Error parsing location data for ID $id: $e');
                }
              });
            }
          });
        }
      });
    } catch (e) {
      log("Error fetching locations: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> fetchFoodBanks() async {
    try {
      isLoading.value = true; // Start loading
      _foodBankSubscription = _foodBanksRef.onValue.listen((event) {
        foodBankList.clear();
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map<dynamic, dynamic> foodBanksMap = event.snapshot.value as Map;
          foodBanksMap.forEach((userId, userData) {
            if (userData is Map) {
              userData.forEach((id, data) {
                try {
                  final foodBankModel =
                      FoodBankModel.fromJson(_sanitizeData(data));
                  log('Food Bank Model: ${foodBankModel.foodNgoName}');
                  if (_isWithinRange(
                      foodBankModel.latitude, foodBankModel.longitude)) {
                    double distance = Geolocator.distanceBetween(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                          foodBankModel.latitude,
                          foodBankModel.longitude,
                        ) /
                        1000;

                    foodBankModel.distance = distance; // Store distance
                    foodBankList.add(foodBankModel);
                    combinedDataList.add(foodBankModel);
                    log("Combined Data List: $combinedDataList");
                    findFoodController.addMarker(
                      foodBankModel.latitude,
                      foodBankModel.longitude,
                      foodBankModel.foodNgoName,
                      foodBankModel.address,
                    );
                    log("Food Bank Added: ${foodBankModel.foodNgoName}");
                  }
                } catch (e) {
                  log('Error parsing food bank data for ID $id: $e');
                }
              });
            }
          });
        }
      });
    } catch (e) {
      log("Error fetching food banks: $e");
    } finally {
      isLoading.value = false; // Stop loading
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
      'fName': data['fName']?.toString() ?? '',
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
