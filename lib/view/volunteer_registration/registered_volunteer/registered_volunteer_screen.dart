import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/volunteer_event_model.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view_models/controllers/volunteer_registration/registered_volunteer_view_model.dart';

class RegisteredVolunteerScreen extends StatelessWidget {
  final controller = Get.put(VolunteerController());

  RegisteredVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.kPrimaryColor,
          ));
        }

        return RefreshIndicator(
          color: AppColors.kPrimaryColor,
          onRefresh: () async => controller.fetchVolunteerData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${controller.volunteerName.value} 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  Text('📧 ${controller.email.value}'),
                  Text('📱 ${controller.phone.value}'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('📆 Upcoming Events'),
                  if (controller.upcomingEvents.isEmpty)
                    const Text('No upcoming events available.'),
                  ...controller.upcomingEvents
                      .map((e) => _buildEventCard(e, true)),
                  const SizedBox(height: 30),
                  _buildSectionTitle('✅ Completed Events'),
                  if (controller.completedEvents.isEmpty)
                    const Text('No completed events available.'),
                  ...controller.completedEvents
                      .map((e) => _buildEventCard(e, false)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
      ),
    );
  }

  Widget _buildEventCard(VolunteerEvent event, bool isJoinable) {
    return Card(
      color: isJoinable ? AppColors.kWhiteColor : Colors.grey[300],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(event.description),
            const SizedBox(height: 8),
            Text('📍 ${event.location}'),
            Text('🗓 ${event.date.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 10),
            if (isJoinable)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => controller.joinEvent(event),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: AppColors.kWhiteColor,
                  ),
                  child: const Text('Join'),
                ),
              )
            else
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
