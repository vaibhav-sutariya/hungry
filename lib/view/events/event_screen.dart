import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view_models/controllers/event_view_model/event_view_model.dart';

class EventScreen extends StatelessWidget {
  final EventViewModel viewModel = Get.put(EventViewModel());

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
                      .map((event) => buildLiveEventCard(context, event))
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
                      .map((event) => buildPastEventCard(context, event))
                      .toList(),
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

                const SizedBox(height: 10),

                /// Calendar View Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Calendar View"),
                    Switch(
                      value: viewModel.showCalendarView.value,
                      onChanged: (value) => viewModel.toggleCalendarView(),
                      activeColor: Colors.orange,
                    ),
                  ],
                ),

                /// Conditional Calendar or List View
                Obx(() => viewModel.showCalendarView.value
                    ? _buildCalendarView()
                    : _buildUpcomingEventsList()),

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
                          color: Colors.deepOrange,
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
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "Subscribe",
                              style: TextStyle(color: Colors.white),
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
                        color: Colors.orange),
                    label: const Text(
                      "Share Your Event Experience",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildCalendarView() {
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

  Widget _buildUpcomingEventsList() {
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

  Widget buildLiveEventCard(BuildContext context, Map<String, String> event) {
    return GestureDetector(
      onTap: () => viewModel.navigateToLiveEvent(event),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(event["image"]!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Colors.white, size: 10),
                  SizedBox(width: 4),
                  Text(
                    "LIVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        event["date"]!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        event["time"]!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton.icon(
              onPressed: () => viewModel.joinLiveEvent(event),
              icon: const Icon(Icons.play_circle_outline, size: 16),
              label: const Text("Join"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPastEventCard(BuildContext context, Map<String, String> event) {
    return GestureDetector(
      onTap: () => viewModel.navigateToPastEventDetails(event),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Image.network(
                event["image"]!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event["title"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          event["date"]!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => viewModel.watchPastEventVideo(event),
                          icon: const Icon(Icons.play_circle_outline, size: 14),
                          label: const Text("Watch",
                              style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            foregroundColor: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => viewModel.sharePastEvent(event),
                          icon: const Icon(Icons.share, size: 14),
                          label: const Text("Share",
                              style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            foregroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
