import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';

/// Builds a Card for Live Events (Carousel)
Widget buildLiveEventCard(Map<String, String> event) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          event["image"]!,
          fit: BoxFit.fill,
          width: double.infinity,
          height: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
        ),
      ),
      Positioned(
        left: 16,
        bottom: 16,
        right: 16,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event["title"]!,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kWhiteColor),
              ),
              Text(
                "${event["date"]} | ${event["time"]}",
                style:
                    const TextStyle(fontSize: 12, color: AppColors.kWhiteColor),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 16,
        right: 16,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.kWhiteColor),
          child: const Icon(Icons.play_circle_fill,
              color: AppColors.kPrimaryColor, size: 30),
        ),
      ),
    ],
  );
}
