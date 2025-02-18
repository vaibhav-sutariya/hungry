import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FindFoodController extends GetxController {
  final LocationServices locationService = Get.put(LocationServices());
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Completer<GoogleMapController> controller = Completer();
  final RxString currentAddress = 'Loading...'.obs;

  static const LatLng _center = LatLng(23.044857, 72.6459813);
  final Rx<LatLng> lastMapPosition = _center.obs;
  final Rx<MapType> currentMapType = MapType.normal.obs;
  late BitmapDescriptor markerIcon;

  final PanelController panelController = PanelController();

  @override
  void onInit() {
    super.onInit();

    getUserLocation(); // Fetch user location on init
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
    await getUserLocation();
  }

  void onCameraMove(CameraPosition position) {
    lastMapPosition.value = position.target;
  }

  LatLng initialPosition() {
    return _center;
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

  Future<void> getUserLocation() async {
    LatLng? userLocation = await locationService.getUserCurrentLocation();
    lastMapPosition.value = userLocation!;

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
