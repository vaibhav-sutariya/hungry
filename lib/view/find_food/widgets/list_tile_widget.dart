import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view_models/controllers/find_food_controller/find_food_controller.dart';

final FindFoodController controller = Get.put(FindFoodController());

Widget buildListTile(dynamic data) {
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
        size: 40,
        color: AppColors.kPrimaryColor,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              data.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: AppColors.kPrimaryColor,
                width: 1.0,
              ),
            ),
            child: Text('${data.distance?.toStringAsFixed(2)} km',
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
                onTap: () =>
                    Get.toNamed(RouteName.viewDetailsScreen, arguments: data),
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
          ),
        ],
      ),
    ),
  );
}
