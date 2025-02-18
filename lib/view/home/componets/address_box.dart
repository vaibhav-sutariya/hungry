// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view_models/services/location_services/location_permission.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:shimmer/shimmer.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({
    super.key,
  });

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  LocationPermissionServices locationPermissionServices =
      Get.put(LocationPermissionServices());
  LocationServices locationServices = Get.put(LocationServices());

  @override
  void initState() {
    super.initState();
    locationPermissionServices.getLocationPermission(context);
    // _getLocationPermission();
    locationServices.getCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.searchScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.kPrimaryColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 40,
                color: AppColors.kPrimaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return locationServices.isLoading.value
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: double.infinity - 200,
                                      height: 15.0,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: 100,
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  locationServices.currentAddress.value,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
