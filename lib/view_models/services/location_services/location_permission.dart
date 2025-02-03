import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationPermissionServices extends GetxController {
  void getLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Show a snackbar to inform the user about the importance of location permission
      final snackBar = SnackBar(
        content: const Text('Location permission is mandatory for this app.'),
        action: SnackBarAction(
          label: 'Grant',
          onPressed: () async {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              getLocationPermission(context);
            } else {
              // User granted permission, proceed to get location
              // _getCurrentLocation();
            }
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // if (permission == LocationPermission.denied) {
      //   Get.snackbar(onTap: (snack) async {
      //     permission = await Geolocator.requestPermission();
      //     if (permission == LocationPermission.denied) {
      //       getLocationPermission();
      //     } else {
      //       // _getCurrentLocation();
      //     }
      //   }, 'Grant Location permission', 'Location Permission is mandatory');
    }
  }
}
