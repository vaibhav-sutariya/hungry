import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSlider extends StatelessWidget {
  final FindFoodController controller = Get.find<FindFoodController>();

  BottomSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      borderRadius: BorderRadius.circular(24.0),
      controller: controller.panelController,
      minHeight: 200,
      maxHeight: MediaQuery.of(context).size.height * 0.5,
      isDraggable: true,
      parallaxEnabled: true,
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (ScrollController sc) => Obx(
        () => Container(
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
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) => const SeeAllScreen(),
                        //   ),
                        // );
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
                child: controller.combinedDataList.isEmpty
                    ? const Center(child: Text('No data available'))
                    : ListView(
                        controller: sc,
                        children: controller.combinedDataList
                            .map((data) => _buildListTile(data))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(dynamic data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: AppColors.kPrimaryColor,
          width: 2.0,
        ),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/logo.png',
          ),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.10),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: ListTile(
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
                data.fName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton(
              style: _buttonStyle(),
              onPressed: () {},
              child: Text(' km',
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.kPrimaryColor)),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.address, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.kPrimaryColor,
                  ),
                  onPressed: controller.panelController.close,
                  icon: const Icon(
                    Icons.directions,
                    color: Colors.white,
                  ),
                  label: const Text('Directions',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.kPrimaryColor, width: 1.0),
      ),
    );
  }
}
