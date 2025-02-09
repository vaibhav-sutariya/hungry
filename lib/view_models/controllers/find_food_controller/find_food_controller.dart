import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/models/food_bank_model.dart';
import 'package:hungry/models/location_model.dart';

class FindFoodController extends GetxController {
  late DatabaseReference _locationsRef;
  late DatabaseReference _foodBanksRef;
  StreamSubscription<DatabaseEvent>? _locationSubscription;
  StreamSubscription<DatabaseEvent>? _foodBankSubscription;
  final RxList<dynamic> combinedDataList = <dynamic>[].obs;

  final RxSet<Marker> markers = <Marker>{}.obs;
  final Completer<GoogleMapController> controller = Completer();
  final RxString currentAddress = 'Loading...'.obs;

  static const LatLng _center = LatLng(23.044857, 72.6459813);
  final Rx<LatLng> lastMapPosition = _center.obs;
  final Rx<MapType> currentMapType = MapType.normal.obs;
  late BitmapDescriptor markerIcon;

  @override
  void onInit() {
    super.onInit();
    // loadMarkerIcon().then((_) {
    //   fetchAllData();
    // });
    getUserCurrentLocation(); // Fetch user location on init
  }

  Future<void> loadMarkerIcon() async {
    final Uint8List markerIconBytes =
        await getBytesFromAsset('assets/images/marker_icon.png', 80);
    markerIcon = BitmapDescriptor.fromBytes(markerIconBytes);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void onMapCreated(GoogleMapController googleMapController) async {
    controller.complete(googleMapController);
    await getUserCurrentLocation();
  }

  void onCameraMove(CameraPosition position) {
    lastMapPosition.value = position.target;
  }

  LatLng initialPosition() {
    return _center;
  }

  // void fetchAllData() {
  //   fetchLocations();
  //   fetchFoodBanks();
  // }

  void fetchLocations() {
    _locationsRef = FirebaseDatabase.instance.ref().child('locations');
    _locationSubscription = _locationsRef.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> locationsMap = event.snapshot.value as Map;
        locationsMap.forEach((userId, userData) {
          if (userData is Map) {
            userData.forEach((id, data) {
              try {
                final locationModel =
                    LocationModel.fromJson(Map<String, dynamic>.from(data));
                combinedDataList.add(locationModel);
                addMarker(locationModel.latitude, locationModel.longitude,
                    locationModel.fName, locationModel.address);
                log(locationModel.latitude.toString());
                log(locationModel.longitude.toString());
                log(locationModel.fName.toString());
                log(locationModel.address.toString());
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
    _foodBanksRef = FirebaseDatabase.instance.ref().child('FoodBanks');
    _foodBankSubscription = _foodBanksRef.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> foodBanksMap = event.snapshot.value as Map;
        foodBanksMap.forEach((userId, userData) {
          if (userData is Map) {
            userData.forEach((id, data) {
              try {
                final foodBankModel =
                    FoodBankModel.fromJson(Map<String, dynamic>.from(data));
                combinedDataList.add(foodBankModel);
                addMarker(foodBankModel.latitude, foodBankModel.longitude,
                    foodBankModel.foodNgoName, foodBankModel.address);
                log(foodBankModel.latitude.toString());
                log(foodBankModel.longitude.toString());
                log(foodBankModel.fName.toString());
                log(foodBankModel.address.toString());
              } catch (e) {
                log('Error parsing food bank data for ID $id: $e');
              }
            });
          }
        });
      }
    });
  }

  void addMarker(
      double latitude, double longitude, String title, String snippet) {
    markers.add(Marker(
      markerId: MarkerId(title),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: markerIcon,
    ));
    update();
  }

  void toggleMapType() {
    currentMapType.value = currentMapType.value == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  Future<void> getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    lastMapPosition.value = LatLng(position.latitude, position.longitude);

    markers.add(Marker(
      markerId: const MarkerId("currentLocation"),
      position: lastMapPosition.value,
      infoWindow: const InfoWindow(title: 'Your Current Location'),
    ));
    update();
    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: lastMapPosition.value, zoom: 14),
    ));
  }
}
