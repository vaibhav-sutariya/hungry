import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text("Events"),
      ),
    );
  }
}
