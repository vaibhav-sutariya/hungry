import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FindFoodController extends GetxController {
  final LocationServices locationService = Get.put(LocationServices());
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Marker> markers2 = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final Completer<GoogleMapController> controller = Completer();
  final RxString currentAddress = 'Loading...'.obs;

  static const LatLng _center = LatLng(23.044857, 72.6459813);
  final Rx<LatLng> lastMapPosition = _center.obs;
  final Rx<MapType> currentMapType = MapType.normal.obs;
  late BitmapDescriptor markerIcon;

  final PanelController panelController = PanelController();
  final String googleAPIKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(milliseconds: 100), () async {
      await getUserLocation();
    }); // Fetch user location on init
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

  GoogleMapController? _mapController; // Store controller instance

  void onMapCreated(GoogleMapController googleMapController) async {
    _mapController ??= googleMapController;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserLocation();
    });
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
    markers.refresh();

    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: lastMapPosition.value, zoom: 14),
    ));
  }

  /// Set Destination Marker and Fetch Directions
  void setDestinationMarker(double lat, double lng) {
    LatLng destination = LatLng(lat, lng);

    markers2.add(Marker(
      markerId: const MarkerId("origin"),
      position: lastMapPosition.value,
      infoWindow: const InfoWindow(title: 'Origin'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
    markers2.add(Marker(
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
        "&mode=driving"; // Change "walking", "bicycling", or "transit" as needed

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData["status"] == "ZERO_RESULTS") {
        Get.snackbar("Error", "No route found between locations.");
        return;
      }

      if (decodedData["status"] != "OK") {
        Get.snackbar("Error", "Google API Error: ${decodedData["status"]}");
        return;
      }

      if (decodedData["routes"].isNotEmpty) {
        final points = decodedData["routes"][0]["overview_polyline"]["points"];
        final List<LatLng> polylineCoordinates = _decodePolyline(points);

        _addPolyline(polylineCoordinates);

        // Adjust Camera to Fit Route
        _fitMapToPolyline(origin, destination);
      } else {
        Get.snackbar("Error", "No route found.");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch directions.");
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
      color: Colors.blueAccent, // Visible Google Maps-like color
      width: 6,
      points: polylineCoordinates,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );

    polylines.clear();
    polylines.add(polyline);
    update();
  }

  /// Adjust Camera to Fit Entire Route
  void _fitMapToPolyline(LatLng origin, LatLng destination) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        origin.latitude < destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude < destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
      northeast: LatLng(
        origin.latitude > destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude > destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
    );

    controller.future.then((mapController) {
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    });
  }

  // Add this method to your FindFoodController class
void clearMarkers() {
  // Clear existing markers from your map
  markers.clear();
  update();
}
}
