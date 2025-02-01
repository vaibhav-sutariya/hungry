import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Help Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // CustomElevatedButton(onPressed: () {}, text: 'FAQ'),
            SizedBox(height: 10),
            // CustomElevatedButton(onPressed: () {}, text: 'Contact Support'),
            SizedBox(height: 10),
            // CustomElevatedButton(onPressed: () {}, text: 'Live Chat'),
            SizedBox(height: 10),
            // CustomElevatedButton(onPressed: () {}, text: 'Report a Problem'),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
