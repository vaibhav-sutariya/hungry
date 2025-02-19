import 'package:flutter/material.dart';

/// Builds a Card for Live Events (Carousel)
Widget buildLiveEventCard(Map<String, String> event) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          event["image"]!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      Positioned(
        left: 16,
        bottom: 16,
        right: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event["title"]!,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "${event["date"]} | ${event["time"]}",
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 16,
        right: 16,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: const Icon(Icons.play_circle_fill,
              color: Colors.orange, size: 30),
        ),
      ),
    ],
  );
}
