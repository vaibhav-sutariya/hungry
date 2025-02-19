import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/repository/location_data_fetch.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/find_food/components/bottom_slidebar.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';

class FindFoodScreen extends StatefulWidget {
  const FindFoodScreen({super.key});

  @override
  State<FindFoodScreen> createState() => _FindFoodScreenState();
}

class _FindFoodScreenState extends State<FindFoodScreen> {
  final LocationDataRepository locationDataRepository =
      Get.put(LocationDataRepository());

  final FindFoodController findFoodController = Get.put(FindFoodController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.fetchLocations();
    // controller.fetchFoodBanks();
    findFoodController.panelController;
    findFoodController.loadMarkerIcon().then((_) {
      locationDataRepository.fetchLocations();
      locationDataRepository.fetchFoodBanks();
    });
    _setDestinationMarker();
  }

  void _setDestinationMarker() {
    final dynamic args = Get.arguments;
    if (args != null) {
      findFoodController.setDestinationMarker(args['lat'], args['lng']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: false),
      body: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Obx(
              () => GoogleMap(
                mapToolbarEnabled: true,
                onMapCreated: findFoodController.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: findFoodController.initialPosition(),
                  zoom: 11.0,
                ),
                mapType: findFoodController.currentMapType(),
                indoorViewEnabled: true,
                zoomGesturesEnabled: true,
                markers: Set<Marker>.of(findFoodController.markers),
                onCameraMove: findFoodController.onCameraMove,
                polylines: findFoodController.polylines,
                // polygons: findFoodController.polygons,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                buildingsEnabled: true,
                fortyFiveDegreeImageryEnabled: true,
                zoomControlsEnabled: true,
              ),
            ),
          ),
          BottomSlider(),
        ],
      ),
    );
  }
}
