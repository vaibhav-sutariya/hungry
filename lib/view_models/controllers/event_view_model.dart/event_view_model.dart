import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customTextField.dart';
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
    // Live food donation events happening now
    liveEvents.value = [
      {
        "title": "Community Free Meal Drive",
        "date": "Sat 14th May",
        "time": "12:00 PM - 3:00 PM",
        "image":
            "https://images.stockcake.com/public/4/f/4/4f4dd440-2d5e-4c15-9109-f9d0cebf5148_large/community-food-drive-stockcake.jpg"
      },
      {
        "title": "Temple Prasadam Distribution",
        "date": "Sun 15th May",
        "time": "6:00 AM - 9:00 AM",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6MBiBVDDJMHFnPAv7k_0wt9McwdlkbO7veg&s"
      },
      {
        "title": "Free Breakfast for the Needy",
        "date": "Sun 15th May",
        "time": "6:00 AM - 9:00 AM",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzXMLT5df848EIaoxp0t7UAEHM_z4m5H78tQ&s"
      }
    ];

    // Past food donation and hunger relief events
    pastEvents.value = [
      {
        "title": "Homeless Food Donation Drive",
        "date": "Fri 10th May",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT41KHWKbWXpm5kbJgQjTSiT5WOK3DiC5Btjg&s"
      },
      {
        "title": "School Mid-Day Meal Program",
        "date": "Wed 8th May",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzoDlRhTMTmmLPYngWWGREGCNi-acR6tWeHg&s"
      },
      {
        "title": "Orphanage Food Support",
        "date": "Wed 9th May",
        "image":
            "https://cimages.milaap.org/milaap/image/upload/c_fill,g_faces,h_315,w_420/v1521807714/production/images/campaign/33419/Fooding_wof6ts_1521807712.jpg"
      }
    ];

    // Upcoming food donation and awareness events
    upcomingEvents.value = [
      {
        "title": "Monthly Food Bank Collection",
        "date": "Mon 20th May",
        "time": "10:00 AM - 4:00 PM",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ19c_UnIuJ-ciRSChjT2S5TkAZHRZOCzjCag&s"
      },
      {
        "title": "Hunger Awareness Workshop",
        "date": "Wed 22nd May",
        "time": "2:30 PM - 5:00 PM",
        "image":
            "https://c8.alamy.com/comp/2FKT5E2/world-hunger-day-food-prevention-and-awareness-vector-concept-banner-poster-world-hunger-day-awareness-campaign-template-2FKT5E2.jpg"
      },
      {
        "title": "Free Meal Distribution",
        "date": "Sat 25th May",
        "time": "6:00 PM - 9:00 PM",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSODmgWXZ5HeqBxVYFAwc8jxDe8wuUJ3lcRoQ&s"
      },
    ];

    // Days that have food-related events
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
        snackPosition: SnackPosition.TOP,
      );
    } else {
      reminderEvents.add(eventTitle);
      Get.snackbar(
        "Reminder Set",
        "You will be notified before this event starts",
        snackPosition: SnackPosition.TOP,
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
                focusColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(width: 1, color: AppColors.kPrimaryColor)),
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
                    activeColor: AppColors.kPrimaryColor,
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
                                ? AppColors.kPrimaryColor
                                : AppColors.kPrimaryLightColor,
                            size: 20,
                          );
                        }),
                      )),
                  const Text("Excellent"),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: feedbackController,
                labelText: 'Your Feedback',
                hintText: 'Share your thoughts about the event...',
                suffixIcon: Icon(
                  Icons.feedback,
                  color: AppColors.kPrimaryColor,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.kPrimaryColor),
            ),
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
                colorText: AppColors.kWhiteColor,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
            ),
            child: const Text("Submit Feedback",
                style: TextStyle(color: AppColors.kWhiteColor)),
          ),
        ],
      ),
    );
  }
}
