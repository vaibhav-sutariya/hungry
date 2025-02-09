import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';

class FindFoodScreen extends StatefulWidget {
  const FindFoodScreen({super.key});

  @override
  State<FindFoodScreen> createState() => _FindFoodScreenState();
}

class _FindFoodScreenState extends State<FindFoodScreen> {
  final FindFoodController controller = Get.put(FindFoodController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.fetchLocations();
    // controller.fetchFoodBanks();
    controller.loadMarkerIcon().then((_) {
      controller.fetchLocations();
      controller.fetchFoodBanks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: false),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            top: AppBar().preferredSize.height + 30,
            bottom: 65,
            left: 5,
            right: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Obx(
                () => GoogleMap(
                  mapToolbarEnabled: true,
                  onMapCreated: controller.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: controller.initialPosition(),
                    zoom: 11.0,
                  ),
                  mapType: controller.currentMapType(),
                  markers: Set<Marker>.of(controller.markers),
                  onCameraMove: controller.onCameraMove,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  buildingsEnabled: true,
                  fortyFiveDegreeImageryEnabled: true,
                  zoomControlsEnabled: true,
                ),
              ),
            ),
          ),
          // const BottomSlider(),
        ],
      ),
    );
  }
}
