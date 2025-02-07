import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/leftover_food/components/food_details_form.dart';

class SubmitLeftoverFoodScreen extends StatelessWidget {
  const SubmitLeftoverFoodScreen({super.key});
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
                "Submit Leftover Food",
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
                "Your small help let our App one step\nclose to kill hunger.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              FoodDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
