import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class AddLocationScreen extends StatelessWidget {
  const AddLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(
        showLogOut: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter Location Details",
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
                "You have any location details?  \nThen fill this form and submit the details",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // AddLocationDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
