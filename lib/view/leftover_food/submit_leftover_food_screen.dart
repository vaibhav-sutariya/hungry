import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class SubmitLeftoverFoodScreen extends StatelessWidget {
  const SubmitLeftoverFoodScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: const Center(
        child: Text('Submit Leftover Food Screen'),
      ),
    );
  }
}
