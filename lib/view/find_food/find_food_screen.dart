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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: false),
      body: Stack(
        children: <Widget>[
          // Text('current adress'),
          Positioned.fill(
            top: AppBar().preferredSize.height + 30,
            bottom: 65,
            left: 5,
            right: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GoogleMap(
                mapToolbarEnabled: true,
                onMapCreated: controller.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition(),
                  zoom: 11.0,
                ),
                // mapType: controller.currentMapType,
                markers: controller.markers(),
                onCameraMove: controller.onCameraMove,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
              ),
            ),
          ),
          // AddressBox(),
          // Text('current adress'),
          // const BottomSlider(),
        ],
      ),
    );
  }
}
