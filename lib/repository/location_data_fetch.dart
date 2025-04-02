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
  final RxBool dataInitialized =
      false.obs; // Track if data has been initialized

  Position? currentPosition;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  // New method to initialize data only once
  void _initializeData() {
    if (!dataInitialized.value) {
      _getCurrentLocation();
    }
  }

  // Method to clear data and reinitialize
  void refreshData() {
    // Cancel existing subscriptions
    _locationSubscription?.cancel();
    _foodBankSubscription?.cancel();

    // Clear existing data
    locationList.clear();
    foodBankList.clear();
    combinedDataList.clear();

    // Clear markers from the map
    findFoodController.clearMarkers();

    // Reset initialization flag
    dataInitialized.value = false;

    // Get location and fetch data again
    _initializeData();
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
      dataInitialized.value = true; // Mark data as initialized
    } catch (e) {
      log("Error getting user location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Modify the _isWithinRange method to return the distance
  double _calculateDistance(double? lat, double? lon) {
    if (currentPosition == null || lat == null || lon == null) return 0.0;

    if (lat.abs() > 90 || lon.abs() > 180) {
      log("⚠️ Invalid Coordinates - Latitude: $lat, Longitude: $lon");
      return 0.0;
    }

    // Calculate the distance in meters
    double distance = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      lat,
      lon,
    );

    double distanceInKm = distance / 1000; // Convert meters to kilometers
    log("Distance (${currentPosition!.latitude} ${currentPosition!.longitude}) to ($lat, $lon): $distanceInKm km");

    return distanceInKm;
  }

  bool _isWithinRange(double? lat, double? lon) {
    double distanceInKm = _calculateDistance(lat, lon);
    return distanceInKm <= 20;
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;

      // Cancel existing subscription
      _locationSubscription?.cancel();

      // Clear location list before fetching new data
      locationList.clear();

      _locationSubscription = _locationsRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          // Temporary list to collect all locations before updating the observable list
          final List<LocationModel> tempLocationList = [];

          Map<dynamic, dynamic> locationsMap = event.snapshot.value as Map;
          for (var userData in locationsMap.values) {
            if (userData is Map) {
              for (var data in userData.values) {
                try {
                  final Map<String, dynamic> sanitizedData =
                      _sanitizeLocationData(data);
                  final locationModel = LocationModel.fromJson(sanitizedData);

                  if (locationModel.location != null &&
                      _isWithinRange(locationModel.location!.latitude,
                          locationModel.location!.longitude)) {
                    double distanceInKm = _calculateDistance(
                        locationModel.location!.latitude,
                        locationModel.location!.longitude);
                    locationModel.distance = distanceInKm;

                    // Check for duplicates in the temporary list
                    bool isDuplicate = tempLocationList.any((l) =>
                        l.location != null &&
                        l.location!.latitude ==
                            locationModel.location!.latitude &&
                        l.location!.longitude ==
                            locationModel.location!.longitude);

                    if (!isDuplicate) {
                      tempLocationList.add(locationModel);
                    }
                  }
                } catch (e) {
                  log('Error parsing location data: $e');
                }
              }
            }
          }

          // Update locations and add markers in a single batch
          locationList.assignAll(tempLocationList);

          // Update combined data list
          _updateCombinedDataList();

          // Add markers for each location
          for (var location in tempLocationList) {
            if (location.name != null && location.address != null) {
              findFoodController.addMarker(
                location.location!.latitude!,
                location.location!.longitude!,
                location.name!,
                location.address!,
              );
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

      // Cancel existing subscription
      _foodBankSubscription?.cancel();

      // Clear food bank list before fetching new data
      foodBankList.clear();

      _foodBankSubscription = _foodBanksRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          // Temporary list to collect all food banks before updating the observable list
          final List<FoodBankModel> tempFoodBankList = [];

          Map<dynamic, dynamic> foodBanksMap = event.snapshot.value as Map;
          for (var userData in foodBanksMap.values) {
            if (userData is Map) {
              for (var data in userData.values) {
                try {
                  final Map<String, dynamic> sanitizedData =
                      _sanitizeFoodBankData(data);
                  final foodBankModel = FoodBankModel.fromJson(sanitizedData);

                  if (foodBankModel.location != null &&
                      _isWithinRange(foodBankModel.location!.latitude,
                          foodBankModel.location!.longitude)) {
                    double distanceInKm = _calculateDistance(
                        foodBankModel.location!.latitude,
                        foodBankModel.location!.longitude);
                    foodBankModel.distance = distanceInKm;

                    // Check for duplicates in the temporary list
                    bool isDuplicate = tempFoodBankList.any((f) =>
                        f.location != null &&
                        f.location!.latitude ==
                            foodBankModel.location!.latitude &&
                        f.location!.longitude ==
                            foodBankModel.location!.longitude);

                    if (!isDuplicate) {
                      tempFoodBankList.add(foodBankModel);
                    }
                  }
                } catch (e) {
                  log('Error parsing food bank data: $e');
                }
              }
            }
          }

          // Update food banks and add markers in a single batch
          foodBankList.assignAll(tempFoodBankList);

          // Update combined data list
          _updateCombinedDataList();

          // Add markers for each food bank
          for (var foodBank in tempFoodBankList) {
            if (foodBank.foodBankName != null && foodBank.address != null) {
              findFoodController.addMarker(
                foodBank.location!.latitude!,
                foodBank.location!.longitude!,
                foodBank.foodBankName!,
                foodBank.address!,
              );
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

  // Update combined data list method
  void _updateCombinedDataList() {
    // Clear the combined list first
    combinedDataList.clear();

    // Add all locations and food banks to combined list
    combinedDataList.addAll(locationList);
    combinedDataList.addAll(foodBankList);
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
