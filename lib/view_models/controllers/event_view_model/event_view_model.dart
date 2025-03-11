import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view_models/services/event_services/event_services.dart';

class EventViewModel extends GetxController {
  final currentIndex = 0.obs;
  final showCalendarView = false.obs;
  final notificationMessage = ''.obs;
  final isNotificationSuccess = false.obs;
  final TextEditingController emailController = TextEditingController();

  // Observable lists
  final RxList<Map<String, String>> liveEvents = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> pastEvents = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> upcomingEvents =
      <Map<String, String>>[].obs;
  final RxList<String> reminderEvents = <String>[].obs;
  final RxList<int> daysWithEvents = <int>[].obs;

  final EventService _eventService = Get.put<EventService>(EventService());

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void fetchEvents() {
    // This would typically come from a service/repository
    liveEvents.value = [
      {
        "title": "Maninagar Evening Katha",
        "date": "Sat 14th May",
        "time": "7.45pm IST",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      },
      {
        "title": "Temple Morning Aarti",
        "date": "Sun 15th May",
        "time": "6.00am IST",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      }
    ];

    pastEvents.value = [
      {
        "title": "Charity Food Drive",
        "date": "Fri 10th May",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      },
      {
        "title": "Community Gathering",
        "date": "Wed 8th May",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      },
      {
        "title": "Community Gathering",
        "date": "Wed 8th May",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      }
    ];

    upcomingEvents.value = [
      {
        "title": "Monthly Community Meeting",
        "date": "Mon 20th May",
        "time": "4.00pm IST",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      },
      {
        "title": "Youth Workshop",
        "date": "Wed 22nd May",
        "time": "2.30pm IST",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      },
      {
        "title": "Weekend Kirtan",
        "date": "Sat 25th May",
        "time": "6.00pm IST",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
      },
    ];

    // Days that have events
    daysWithEvents.value = [14, 15, 20, 22, 25];
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void toggleCalendarView() {
    showCalendarView.value = !showCalendarView.value;
  }

  void navigateToAllLiveEvents() {
    Get.toNamed('/events/live');
  }

  void navigateToAllUpcomingEvents() {
    Get.toNamed('/events/upcoming');
  }

  void navigateToLiveEvent(Map<String, String> event) {
    Get.toNamed('/events/live/details', arguments: event);
  }

  void joinLiveEvent(Map<String, String> event) {
    Get.toNamed('/events/live/stream', arguments: event);
  }

  void navigateToPastEventDetails(Map<String, String> event) {
    Get.toNamed('/events/past/details', arguments: event);
  }

  void navigateToEventDetails(Map<String, String> event) {
    Get.toNamed('/events/details', arguments: event);
  }

  void watchPastEventVideo(Map<String, String> event) {
    Get.toNamed('/events/past/video', arguments: event);
  }

  void sharePastEvent(Map<String, String> event) {
    _eventService.shareEvent(event["title"]!, event["image"]!);
    Get.snackbar(
      "Shared",
      "Event details shared successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  void toggleEventReminder(String eventTitle) {
    if (reminderEvents.contains(eventTitle)) {
      reminderEvents.remove(eventTitle);
      Get.snackbar(
        "Reminder Removed",
        "You will not receive notifications for this event",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      reminderEvents.add(eventTitle);
      Get.snackbar(
        "Reminder Set",
        "You will be notified before this event starts",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  void showEventsForDay(int day) {
    final dayEvents = upcomingEvents.where((event) {
      return event["date"]!.contains('${day}th') ||
          event["date"]!.contains('${day}nd') ||
          event["date"]!.contains('${day}rd') ||
          event["date"]!.contains('${day}st');
    }).toList();

    if (dayEvents.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          title: Text("Events on May $day"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dayEvents.length,
              itemBuilder: (context, index) {
                final event = dayEvents[index];
                return ListTile(
                  title: Text(event["title"]!),
                  subtitle: Text(event["time"]!),
                  trailing: IconButton(
                    icon: Icon(
                      reminderEvents.contains(event["title"])
                          ? Icons.notifications_active
                          : Icons.notifications_none,
                      color: Colors.orange,
                    ),
                    onPressed: () => toggleEventReminder(event["title"]!),
                  ),
                  onTap: () => navigateToEventDetails(event),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  void registerForNotifications() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      notificationMessage.value = "Please enter your email";
      isNotificationSuccess.value = false;
      return;
    }

    if (!GetUtils.isEmail(email)) {
      notificationMessage.value = "Please enter a valid email";
      isNotificationSuccess.value = false;
      return;
    }

    // This would typically call a service to register
    _eventService.subscribeToEventNotifications(email);

    notificationMessage.value =
        "Successfully subscribed to event notifications";
    isNotificationSuccess.value = true;
    emailController.clear();
  }

  void showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    final ratingValue = 3.0.obs;

    Get.dialog(
      AlertDialog(
        title: const Text("Share Your Event Experience"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Which event did you attend?"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  ...pastEvents.map((event) => DropdownMenuItem(
                        value: event["title"],
                        child: Text(event["title"]!),
                      )),
                ],
                onChanged: (value) {},
                hint: const Text("Select an event"),
              ),
              const SizedBox(height: 16),
              const Text("How would you rate your experience?"),
              const SizedBox(height: 8),
              Obx(() => Slider(
                    value: ratingValue.value,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    label: ratingValue.value.toString(),
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      ratingValue.value = value;
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Poor"),
                  Obx(() => Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < ratingValue.value
                                ? Colors.orange
                                : Colors.grey,
                            size: 20,
                          );
                        }),
                      )),
                  const Text("Excellent"),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Your feedback:"),
              const SizedBox(height: 8),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: "Share your thoughts about the event...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Would typically submit to a service
              _eventService.submitFeedback(
                  feedbackController.text, ratingValue.value);
              Get.back();
              Get.snackbar(
                "Thank You!",
                "Your feedback has been submitted successfully",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.7),
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text("Submit Feedback",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
