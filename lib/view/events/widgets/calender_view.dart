import 'package:flutter/material.dart';
import 'package:hungry/view_models/controllers/event_view_model.dart/event_view_model.dart';

Widget buildCalendarView(EventViewModel viewModel) {
  return Container(
    height: 250,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 31, // Days in month
      itemBuilder: (context, index) {
        final day = index + 1;
        final hasEvent = viewModel.daysWithEvents.contains(day);

        return InkWell(
          onTap: () => hasEvent ? viewModel.showEventsForDay(day) : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: hasEvent
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: hasEvent ? Colors.orange : Colors.transparent,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: TextStyle(
                fontWeight: hasEvent ? FontWeight.bold : FontWeight.normal,
                color: hasEvent ? Colors.deepOrange : Colors.black,
              ),
            ),
          ),
        );
      },
    ),
  );
}
