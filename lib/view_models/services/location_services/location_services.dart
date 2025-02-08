import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationServices extends GetxController {
  RxBool isLoading = false.obs;
  RxString currentAddress = ''.obs;
  void getCurrentLocation() async {
    try {
      isLoading.value = true;
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        log(placemark.toString());
        currentAddress.value = "${placemark.thoroughfare}, "
            "${placemark.subLocality},"
            " ${placemark.locality}, "
            "${placemark.administrativeArea}, "
            "${placemark.subAdministrativeArea}"
            "${placemark.country}, "
            "${placemark.postalCode}";
        log(currentAddress.value);
      } else {
        currentAddress.value = "Address not found";
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
