import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';

/// Builds a Card for Past Events
Widget buildPastEventCard(Map<String, String> event) {
  return Card(
    color: AppColors.kWhiteColor,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(event["image"]!,
            width: 60, height: 60, fit: BoxFit.cover),
      ),
      title: Text(event["title"]!,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(event["date"]!),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    ),
  );
}
