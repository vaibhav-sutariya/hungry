import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSlider extends StatelessWidget {
  final FindFoodController controller = Get.find<FindFoodController>();

  BottomSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: controller.panelController,
      minHeight: 50,
      maxHeight: MediaQuery.of(context).size.height * 0.5,
      // panel: buildPanel(context),
      isDraggable: true,
      parallaxEnabled: true,
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (ScrollController sc) => Obx(
        () => controller.combinedDataList.isEmpty
            ? const Center(
                child: Text('No data available'),
              )
            : ListView(
                controller: sc,
                children: [
                  ...controller.foodBankList.map(
                    (foodBank) => ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: const Icon(
                        Icons.location_on_outlined,
                        size: 50,
                        color: AppColors.kPrimaryColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              foodBank.fName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: AppColors.kPrimaryColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              // setState(() {
                              // _showSeeAll = false;
                              // });
                              // _panelController.close();
                              // print(
                              // 'Directions pressed for ${userData.fname}');
                            },
                            child: Text(
                              ' km',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(foodBank.address,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.kPrimaryColor,
                                ),
                                onPressed: () {
                                  // setState(() {
                                  //   _showSeeAll = true;
                                  // });
                                  controller.panelController.close();
                                  // print('Directions pressed for ${userData.fname}');
                                  // _launchMapsApp(locationLat, locationLon);
                                },
                                icon: const Icon(Icons.directions),
                                label: const Text(
                                  'Directions',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (context) => ViewDetailsScreen(
                                  //       userData: userData,
                                  //       distance: distance,
                                  //       locationLat: locationLat,
                                  //       locationLon: locationLon,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: const Text(
                                    'View Details',
                                    style: TextStyle(
                                      color: AppColors.kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ...controller.locationList.map((location) => ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: const Icon(
                          Icons.location_on_outlined,
                          size: 50,
                          color: AppColors.kPrimaryColor,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                location.fName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                    color: AppColors.kPrimaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // setState(() {
                                // _showSeeAll = false;
                                // });
                                // _panelController.close();
                                // print(
                                // 'Directions pressed for ${userData.fname}');
                              },
                              child: Text(
                                ' km',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(location.address,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.kPrimaryColor,
                                  ),
                                  onPressed: () {
                                    // setState(() {
                                    //   _showSeeAll = true;
                                    // });
                                    controller.panelController.close();
                                    // print('Directions pressed for ${userData.fname}');
                                    // _launchMapsApp(locationLat, locationLon);
                                  },
                                  icon: const Icon(Icons.directions),
                                  label: const Text(
                                    'Directions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   CupertinoPageRoute(
                                    //     builder: (context) => ViewDetailsScreen(
                                    //       userData: userData,
                                    //       distance: distance,
                                    //       locationLat: locationLat,
                                    //       locationLon: locationLon,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: const Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: AppColors.kPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppColors.kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}
