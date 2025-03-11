import 'package:flutter/material.dart';

class ProfileActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const ProfileActionsWidget(
      {super.key, required this.onEditProfile, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onEditProfile,
          icon: const Icon(Icons.edit, color: Colors.white),
          label:
              const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
