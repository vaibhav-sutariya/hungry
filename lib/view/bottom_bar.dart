import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view/donations/donation_screen.dart';
import 'package:hungry/view/events/event_screen.dart';
import 'package:hungry/view/leftover_food/submit_leftover_food_screen.dart';
import 'package:hungry/view/profile/profile_screen.dart';
import 'package:hungry/view/volunteer_registration/volunteer_registration_screen.dart';
import 'package:hungry/view_models/services/location_services/location_permission.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  LocationPermissionServices locationPermissionServices =
      Get.put(LocationPermissionServices());
  LocationServices locationServices = Get.put(LocationServices());
  int _selectedIndex = 0; // Home is selected by default
  final List<Widget> _pages = [
    EventScreen(),
    VolunteerRegistrationScreen(),
    // FindFoodScreen(),
    SubmitLeftoverFoodScreen(),
    DonationScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to FindFoodScreen and hide the bottom navbar
      Get.toNamed(RouteName.findFoodScreen);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationPermissionServices.getLocationPermission(context);
    // _getLocationPermission();
    locationServices.getCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _selectedIndex == 2
          ? null // Hide Bottom Navigation Bar when on FindFoodScreen
          : BottomAppBar(
              color: AppColors.kPrimaryColor,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.event, "Events", 0),
                    _buildNavItem(Icons.article, "Volunteer", 1),
                    const SizedBox(width: 50), // Space for floating button
                    _buildNavItem(Icons.food_bank, "Donations", 3),
                    _buildNavItem(Icons.person, "Profile", 4),
                  ],
                ),
              ),
            ),
      floatingActionButton: _selectedIndex == 2
          ? null // Hide FAB when on FindFoodScreen
          : FloatingActionButton(
              onPressed: () => _onItemTapped(2),
              backgroundColor: AppColors.kPrimaryColor,
              tooltip: "Find Food",
              shape: const CircleBorder(),
              elevation: 5,
              child: const Icon(Icons.find_in_page_outlined,
                  color: Colors.white, size: 30),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 28),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.black : Colors.white,
              )),
        ],
      ),
    );
  }
}
