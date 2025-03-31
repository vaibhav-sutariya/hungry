import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/events/components/event_card_widget.dart';
import 'package:hungry/view/events/components/past_event_widget.dart';
import 'package:hungry/view/events/widgets/calender_view.dart';
import 'package:hungry/view/events/widgets/upcoming_event_view.dart';
import 'package:hungry/view_models/controllers/event_view_model.dart/event_view_model.dart';

class EventScreen extends StatelessWidget {
  final EventViewModel viewModel = Get.put<EventViewModel>(EventViewModel());

  EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LIVE BROADCAST SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "LIVE BROADCAST",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => viewModel.navigateToAllLiveEvents(),
                      child: const Text(
                        "View all >",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),

                /// Carousel Slider for Live Events
                CarouselSlider(
                  items: viewModel.liveEvents
                      .map((event) => buildLiveEventCard(event))
                      .toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      viewModel.updateCurrentIndex(index);
                    },
                  ),
                ),

                /// Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: viewModel.liveEvents.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: viewModel.currentIndex.value == entry.key
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                /// UPCOMING EVENTS SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "UPCOMING EVENTS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => viewModel.navigateToAllUpcomingEvents(),
                      child: const Text(
                        "View all >",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.kPrimaryColor.withOpacity(0.7),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Calendar View",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Obx(() => Transform.scale(
                            scale: 0.8,
                            child: Switch.adaptive(
                              value: viewModel.showCalendarView.value,
                              onChanged: (value) {
                                // HapticFeedback.lightImpact();
                                viewModel.toggleCalendarView();
                              },
                              activeColor: Colors.white,
                              activeTrackColor: AppColors.kPrimaryColor,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Icon(Icons.calendar_view_month,
                                        color: AppColors.kPrimaryColor);
                                  }
                                  return Icon(Icons.list, color: Colors.grey);
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                ),

                /// Conditional Calendar or List View
                Obx(() => viewModel.showCalendarView.value
                    ? buildCalendarView(viewModel)
                    : buildUpcomingEventsList(viewModel)),

                /// Calendar View Toggle

                const SizedBox(height: 20),

                /// PAST EVENTS SECTION
                const Text(
                  "PAST EVENTS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// List of Past Events
                Column(
                  children: viewModel.pastEvents
                      .map((event) => buildPastEventCard(event))
                      .toList(),
                ),

                const SizedBox(height: 30),

                /// EVENT REGISTRATION SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Register for Events",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Would you like to receive notifications for upcoming events?",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              controller: viewModel.emailController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () =>
                                viewModel.registerForNotifications(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.kPrimaryColor.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            child: const Text(
                              "Subscribe",
                              style: TextStyle(color: AppColors.kWhiteColor),
                            ),
                          ),
                        ],
                      ),
                      if (viewModel.notificationMessage.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            viewModel.notificationMessage.value,
                            style: TextStyle(
                              color: viewModel.isNotificationSuccess.value
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// EVENT FEEDBACK BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => viewModel.showFeedbackDialog(context),
                    icon: const Icon(Icons.feedback_outlined,
                        color: AppColors.kPrimaryColor),
                    label: const Text(
                      "Share Your Event Experience",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
