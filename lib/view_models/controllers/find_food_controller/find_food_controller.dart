import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FindFoodController extends GetxController {
  final LocationServices locationService = Get.put(LocationServices());
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final Completer<GoogleMapController> controller = Completer();
  final RxString currentAddress = 'Loading...'.obs;

  static const LatLng _center = LatLng(23.044857, 72.6459813);
  final Rx<LatLng> lastMapPosition = _center.obs;
  final Rx<MapType> currentMapType = MapType.normal.obs;
  late BitmapDescriptor markerIcon;

  final PanelController panelController = PanelController();
  final String googleAPIKey = "YOUR_GOOGLE_API_KEY";

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

  /// Set Destination Marker and Fetch Directions
  void setDestinationMarker(double lat, double lng) {
    LatLng destination = LatLng(lat, lng);

    markers.add(Marker(
      markerId: const MarkerId("destination"),
      position: destination,
      infoWindow: const InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    update();

    _fetchDirections(lastMapPosition.value, destination);
  }

  /// Fetch Directions from Google Directions API
  Future<void> _fetchDirections(LatLng origin, LatLng destination) async {
    final String url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&key=$googleAPIKey"
        "&mode=walking"; // You can change mode to "driving" or "bicycling"

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData["routes"].isNotEmpty) {
        final points = decodedData["routes"][0]["overview_polyline"]["points"];
        final List<LatLng> polylineCoordinates = _decodePolyline(points);

        _addPolyline(polylineCoordinates);
      }
    }
  }

  /// Decode Google Maps Polyline Points
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  /// Add Polyline to Map
  void _addPolyline(List<LatLng> polylineCoordinates) {
    final Polyline polyline = Polyline(
      polylineId: const PolylineId("route"),
      color: const Color(0xFF42A5F5), // Blue color
      width: 5,
      points: polylineCoordinates,
    );

    polylines.clear();
    polylines.add(polyline);
    update();
  }
}
