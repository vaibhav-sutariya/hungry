// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view_models/services/location_services/location_permission.dart';
import 'package:shimmer/shimmer.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({
    super.key,
  });

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  Position? _currentPosition;
  String? _currentAddress;

  bool _isLoading = true;
  LocationPermissionServices locationPermissionServices =
      LocationPermissionServices();

  @override
  void initState() {
    super.initState();
    locationPermissionServices.getLocationPermission(context);
    // _getLocationPermission();
    _getCurrentLocation();
  }

  // Future<void> _getLocationPermission() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     // Show a snackbar to inform the user about the importance of location permission
  //     final snackBar = SnackBar(
  //       content: const Text('Location permission is mandatory for this app.'),
  //       action: SnackBarAction(
  //         label: 'Grant',
  //         onPressed: () async {
  //           permission = await Geolocator.requestPermission();
  //           if (permission == LocationPermission.denied) {
  //             _getLocationPermission();
  //           } else {
  //             // User granted permission, proceed to get location
  //             _getCurrentLocation();
  //           }
  //         },
  //       ),
  //     );

  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else {
  //     // Location permission is already granted, proceed to get location
  //     _getCurrentLocation();
  //   }
  // }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      // Reverse geocode the coordinates to get the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the address details
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _currentAddress = "${placemark.locality}\n"
            "${placemark.subAdministrativeArea}"
            "${placemark.country}, "
            "${placemark.postalCode}";
      } else {
        _currentAddress = "Address not found";
      }

      setState(() {
        _currentPosition = position;
        _currentAddress = _currentAddress;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 40,
                color: AppColors.kPrimaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: 100.0,
                                height: 15.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: double.infinity - 200,
                                height: 15.0,
                              ),
                            ],
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const SearchScreen(),
                            //   ),
                            // );
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _currentAddress!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
