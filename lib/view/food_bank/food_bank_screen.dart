import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/food_bank/components/food_bank_details_form.dart';

class FoodBankScreen extends StatelessWidget {
  const FoodBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                "Enter Food Bank Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "You have any Food Bank details?  \nThen fill this form and submit the details",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              FoodBankDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
