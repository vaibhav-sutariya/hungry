import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class VolunteerDetailConfirmationScreen extends StatefulWidget {
  final String firstName;
  final String dob;
  final String gender;
  final String phoneNumber;
  final String email;
  final String address;
  final String reason;
  // final LatLng location;
  final String id;
  const VolunteerDetailConfirmationScreen(
      {super.key,
      required this.firstName,
      required this.dob,
      required this.gender,
      required this.phoneNumber,
      required this.email,
      required this.address,
      required this.reason,
      required this.id});

  @override
  State<VolunteerDetailConfirmationScreen> createState() =>
      _VolunteerDetailConfirmationScreenState();
}

class _VolunteerDetailConfirmationScreenState
    extends State<VolunteerDetailConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Confirm???',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Your small help let our App one step close to'),
                  Text('kill the Hunger'),
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
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Name: ',
                                    style: AppColors.kTextStyleB,
                                  ),
                                  TextSpan(
                                    text: widget.firstName,
                                    style: AppColors.kTextStyleN,
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Address: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.address,
                                      style: AppColors.kTextStyleN),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Persons: ',
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
                                      text: 'Food Details: ',
                                      style: AppColors.kTextStyleB),
                                  TextSpan(
                                      text: widget.reason,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // NearbyFoodBanks(),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
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
                //     builder: (context) => ThankYouScreen(
                //       firstName: widget.firstName,
                //       phoneNumber: widget.phoneNumber,
                //       address: widget.address,
                //       details: widget.details,
                //       persons: widget.persons,
                //       location: widget.location,
                //       id: widget.id,
                //     ),
                //   ),
                // );
                // sendNotification();
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text('Food bank will be notified when you click "confirm"'),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
