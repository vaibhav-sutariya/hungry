import 'package:flutter/material.dart';

class RegisteredFoodBank extends StatelessWidget {
  const RegisteredFoodBank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Food Bank'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'You have successfully registered as a Food Bank!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
