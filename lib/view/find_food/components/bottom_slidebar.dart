import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/repository/location_data_fetch.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view/find_food/widgets/list_tile_widget.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSlider extends StatelessWidget {
  final FindFoodController controller = Get.put(FindFoodController());
  final LocationDataRepository locationDataRepository =
      Get.put(LocationDataRepository());

  BottomSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      borderRadius: BorderRadius.circular(24.0),
      controller: controller.panelController,
      minHeight: 200,
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      isDraggable: true,
      parallaxEnabled: true,
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (ScrollController sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          border: Border(
            top: BorderSide(
              color: AppColors.kPrimaryColor,
              width: 3.0,
            ),
            left: BorderSide(
              color: AppColors.kPrimaryColor,
              width: 3.0,
            ),
            right: BorderSide(
              color: AppColors.kPrimaryColor,
              width: 3.0,
            ),
          ),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const Icon(Icons.drag_handle, color: Colors.black, size: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteName.seeAllScreen);
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () {
                  final dataList = locationDataRepository.combinedDataList;
                  return locationDataRepository.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : dataList.isEmpty
                          ? const Center(child: Text('No data available'))
                          : ListView.builder(
                              controller: sc,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) =>
                                  buildListTile(dataList[index]),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
