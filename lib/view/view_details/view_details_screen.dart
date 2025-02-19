import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/res/routes/routes_name.dart';

class ViewDetailsScreen extends StatelessWidget {
  const ViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic data = Get.arguments; // Get data from previous screen

    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.kPrimaryColor,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                      ),
                      border: Border.all(
                        color: AppColors.kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.location_on_sharp,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.fName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                data.address,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.kPrimaryColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${data.distance.toStringAsFixed(2)} km',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/Details.jpg'), // Provide your image path here
                              fit: BoxFit
                                  .cover, // Adjust the image fit as needed
                            ),
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // Center(
                        //   child: Text(
                        //     data.details,
                        //     style: const TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: AppColors.kPrimaryColor,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Basic Details",
                                style: TextStyle(
                                  color: AppColors.kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.kPrimaryColor,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Contact No. : ${data.phone}',
                            style: AppColors.kTextStyleB),

                        const SizedBox(
                          height: 10,
                        ),

                        Text('Who can get the food? : Every One',
                            style: AppColors.kTextStyleB),

                        const SizedBox(
                          height: 10,
                        ),
                        Text('Any min. Price for food? : 0 Rs.',
                            style: AppColors.kTextStyleB),

                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          color: AppColors.kPrimaryColor,
                          thickness: 2,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.kPrimaryColor,
                          ),
                          onPressed: () {
                            Get.to(RouteName.findFoodScreen, arguments: {
                              'lat': data.latitude,
                              'lng': data.longitude,
                            });
                          },
                          icon: const Icon(
                            Icons.directions,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Get Directions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
