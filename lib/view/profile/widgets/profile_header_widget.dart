import 'package:flutter/material.dart';
import 'package:hungry/models/user_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel? user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Profile Picture
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : const AssetImage("assets/images/splash.png") as ImageProvider,
          ),
        ),
        const SizedBox(height: 16),
        // User Details
        Text(
          user?.displayName ?? 'No Name Available',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          user?.email ?? 'No Email Available',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        if (user?.phoneNumber != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                user!.phoneNumber!,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
