import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/models/location_model.dart';

class FindFoodController extends GetxController {
  // late DatabaseReference _databaseRef;
  // StreamSubscription<DatabaseEvent>? _userDataSubscription;

  final RxList<LocationModel> userDataList = <LocationModel>[].obs;
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
    _loadMarkerIcon();
    // loadUserLocations();
    getUserCurrentLocation(); // Fetch user location on init
  }

  Future<void> _loadMarkerIcon() async {
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

  // void loadUserLocations() {
  //   _databaseRef = FirebaseDatabase.instance.ref().child('locations');
  //   _userDataSubscription = _databaseRef.onValue.listen((event) {
  //     if (event.snapshot.value != null && event.snapshot.value is Map) {
  //       userDataList.clear();
  //       markers.clear();
  //       Map<dynamic, dynamic> usersDataMap = event.snapshot.value as Map;
  //       usersDataMap.forEach((userId, userData) {
  //         if (userData is Map) {
  //           userData.forEach((id, data) {
  //             if (data is Map && data.containsKey('location')) {
  //               userDataList.add(LocationModel.fromJson(data));
  //               log('User Data: $data');

  //               final List<String> locationParts =
  //                   data['location'].toString().split(',');
  //               if (locationParts.length == 2) {
  //                 double? latitude = double.tryParse(locationParts[0]);
  //                 double? longitude = double.tryParse(locationParts[1]);

  //                 if (latitude != null && longitude != null) {
  //                   markers.add(Marker(
  //                     markerId: MarkerId(id.toString()),
  //                     position: LatLng(latitude, longitude),
  //                     infoWindow: InfoWindow(
  //                       title: data['Fname'] ?? 'No Name',
  //                       snippet: data['address'] ?? 'No Address',
  //                     ),
  //                     icon: markerIcon,
  //                   ));
  //                 }
  //               }
  //             }
  //           });
  //         }
  //       });
  //     }
  //   });
  // }

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

    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: lastMapPosition.value, zoom: 14),
    ));
  }
}
