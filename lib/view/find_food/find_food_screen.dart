import 'package:flutter/material.dart';

class FindFoodScreen extends StatefulWidget {
  const FindFoodScreen({super.key});

  @override
  State<FindFoodScreen> createState() => _FindFoodScreenState();
}

class _FindFoodScreenState extends State<FindFoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Food'),
      ),
      body: const Center(
        child: Text('Find Food Screen'),
      ),
    );
  }
}
