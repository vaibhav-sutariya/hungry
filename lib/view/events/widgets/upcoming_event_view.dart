import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view_models/controllers/event_view_model.dart/event_view_model.dart';

Widget buildUpcomingEventsList(EventViewModel viewModel) {
  return Column(
    children: viewModel.upcomingEvents.map((event) {
      return Card(
        color: AppColors.kWhiteColor,
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryLightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  event["date"]!.split(" ")[1],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
                Text(
                  event["date"]!.split(" ")[2],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            event["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(event["date"]!),
              Text(event["time"]!),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              viewModel.reminderEvents.contains(event["title"])
                  ? Icons.notifications_active
                  : Icons.notifications_none,
              color: AppColors.kPrimaryColor,
            ),
            onPressed: () => viewModel.toggleEventReminder(event["title"]!),
          ),
          onTap: () => viewModel.navigateToEventDetails(event),
        ),
      );
    }).toList(),
  );
}
