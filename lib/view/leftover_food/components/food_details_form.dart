import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class FoodDetailsForm extends StatelessWidget {
  const FoodDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
    );
  }
}
