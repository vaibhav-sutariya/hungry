import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationServices extends GetxController {
  RxBool isLoading = false.obs;
  RxString currentAddress = ''.obs;

  Future<LatLng?> getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied.');
      return null;
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  void getCurrentAddress() async {
    try {
      isLoading.value = true;
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        log(placemark.toString());
        currentAddress.value = "${placemark.name}, "
            "${placemark.subLocality},"
            " ${placemark.locality}, "
            "${placemark.administrativeArea}, "
            "${placemark.subAdministrativeArea}"
            "${placemark.country}, "
            "${placemark.postalCode}";
        log(currentAddress.value);
        isLoading.value = false;
      } else {
        currentAddress.value = "Address not found";
      }
    } catch (e) {
      print(e);
    } finally {
      // isLoading.value = false;
    }
  }
}
