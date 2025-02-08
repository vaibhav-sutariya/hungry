import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class LocationConfirmationScreen extends StatefulWidget {
  final String firstName;
  final String phoneNumber;
  final String address;
  final String details;
  String status;
  // final LatLng location;
  LocationConfirmationScreen({
    super.key,
    required this.firstName,
    required this.phoneNumber,
    required this.address,
    required this.details,
    this.status = 'Pending',
  });

  @override
  State<LocationConfirmationScreen> createState() =>
      _LocationConfirmationScreenState();
}

class _LocationConfirmationScreenState
    extends State<LocationConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Thank you',
                    style: TextStyle(
                      color: AppColors.kPrimaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'For your Contribution',
                    style: TextStyle(
                      color: AppColors.kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Your details has been updated after approval,'),
                  Text('We will Contact you soon for verification.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Here is your Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.kPrimaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: ListTile(
                        title: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Location Name: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.firstName,
                                      style: AppColors.kTextStyleN),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Location Address: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.address,
                                      style: AppColors.kTextStyleN),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Details: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.details,
                                      style: AppColors.kTextStyleN),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Phone: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.phoneNumber,
                                      style: AppColors.kTextStyleN),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Status: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.status,
                                      style: AppColors.kTextStyleN),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                      color: AppColors.kPrimaryColor, width: 2),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
              ),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   CupertinoPageRoute(
                //     builder: (context) => const LocationDetailsScreen(),
                //   ),
                // );
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
