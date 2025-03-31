import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view_models/controllers/event_view_model.dart/event_view_model.dart';

Widget buildCalendarView(EventViewModel viewModel) {
  return Container(
    height: 250,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.kSecondaryColor.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
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
                    ? AppColors.kPrimaryLightColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      hasEvent ? AppColors.kPrimaryColor : Colors.transparent,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                day.toString(),
                style: TextStyle(
                    fontWeight: hasEvent ? FontWeight.bold : FontWeight.normal,
                    color: hasEvent
                        ? AppColors.kPrimaryColor
                        : AppColors.kTextColor),
              ),
            ),
          );
        },
      ),
    ),
  );
}
