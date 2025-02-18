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

  Position? _currentPosition;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      fetchLocations();
      fetchFoodBanks();
    } catch (e) {
      log("Error getting user location: $e");
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

  void fetchLocations() {
    _locationSubscription = _locationsRef.onValue.listen((event) {
      locationList.clear();
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> locationsMap = event.snapshot.value as Map;
        locationsMap.forEach((userId, userData) {
          if (userData is Map) {
            userData.forEach((id, data) {
              try {
                final locationModel =
                    LocationModel.fromJson(Map<String, dynamic>.from(data));
                if (_isWithinRange(
                    locationModel.latitude, locationModel.longitude)) {
                  double distance = Geolocator.distanceBetween(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                        locationModel.latitude,
                        locationModel.longitude,
                      ) /
                      1000; // distance in kilometers

                  locationModel.distance = distance; // Store distance
                  locationList.add(locationModel);
                  combinedDataList.add(locationModel);
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
  }

  void fetchFoodBanks() {
    _foodBankSubscription = _foodBanksRef.onValue.listen((event) {
      foodBankList.clear();
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> foodBanksMap = event.snapshot.value as Map;
        foodBanksMap.forEach((userId, userData) {
          if (userData is Map) {
            userData.forEach((id, data) {
              try {
                final foodBankModel =
                    FoodBankModel.fromJson(Map<String, dynamic>.from(data));
                if (_isWithinRange(
                    foodBankModel.latitude, foodBankModel.longitude)) {
                  double distance = Geolocator.distanceBetween(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                        foodBankModel.latitude,
                        foodBankModel.longitude,
                      ) /
                      1000; // distance in kilometers

                  foodBankModel.distance = distance; // Store distance
                  foodBankList.add(foodBankModel);
                  combinedDataList.add(foodBankModel);
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
  }

  @override
  void onClose() {
    _locationSubscription?.cancel();
    _foodBankSubscription?.cancel();
    super.onClose();
  }
}
