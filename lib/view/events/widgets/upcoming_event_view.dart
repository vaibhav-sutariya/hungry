import 'package:flutter/material.dart';
import 'package:hungry/view_models/controllers/event_view_model.dart/event_view_model.dart';

Widget buildUpcomingEventsList(EventViewModel viewModel) {
  return Column(
    children: viewModel.upcomingEvents.map((event) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              event["date"]!.split(" ")[1],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
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
              color: Colors.orange,
            ),
            onPressed: () => viewModel.toggleEventReminder(event["title"]!),
          ),
          onTap: () => viewModel.navigateToEventDetails(event),
        ),
      );
    }).toList(),
  );
}
