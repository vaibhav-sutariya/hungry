import 'package:get/get.dart';
import 'package:hungry/models/volunteer_event_model.dart';

class VolunteerController extends GetxController {
  var volunteerName = 'Vaibhav Sutariya'.obs;
  var email = 'vaibhav@example.com'.obs;
  var phone = '9876543210'.obs;

  var upcomingEvents = <VolunteerEvent>[].obs;
  var completedEvents = <VolunteerEvent>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVolunteerData();
  }

  void fetchVolunteerData() async {
    isLoading.value = true;

    // Mocked data — Replace this with Firebase fetch if needed
    await Future.delayed(const Duration(seconds: 1), () {
      upcomingEvents.value = [
        VolunteerEvent(
          title: 'Food Drive',
          description: 'Help us distribute food to the needy.',
          date: DateTime.now().add(const Duration(days: 2)),
          location: 'Ahmedabad Central',
        ),
        VolunteerEvent(
          title: 'Kitchen Volunteering',
          description: 'Assist in preparing and serving meals.',
          date: DateTime.now().add(const Duration(days: 4)),
          location: 'Naranpura',
        ),
      ];

      completedEvents.value = [
        VolunteerEvent(
          title: 'City Clean-Up',
          description: 'Cleaned public areas after food distribution.',
          date: DateTime.now().subtract(const Duration(days: 5)),
          location: 'Gandhinagar',
        ),
        VolunteerEvent(
          title: 'Leftover Collection',
          description: 'Collected excess food from restaurants.',
          date: DateTime.now().subtract(const Duration(days: 10)),
          location: 'CG Road',
        ),
      ];
    });

    isLoading.value = false;
  }

  void joinEvent(VolunteerEvent event) {
    Get.snackbar(
      'Joined Event',
      'You have joined "${event.title}"',
      snackPosition: SnackPosition.TOP,
    );
  }
}
