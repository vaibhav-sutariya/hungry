import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/volunteer_registration/components/volunteer_details_form.dart';

class VolunteerRegistrationScreen extends StatelessWidget {
  const VolunteerRegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Volunteer Registration",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Your small effort takes our mission one step further.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              VolunteerDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
