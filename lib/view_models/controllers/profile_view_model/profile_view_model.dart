import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/action_tile_model.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/models/user_model.dart';
import 'package:hungry/view_models/services/firebase_services/user_services.dart';

class ProfileViewModel extends GetxController {
  final FirebaseService _firebaseService =
      Get.put<FirebaseService>(FirebaseService());

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<DonationModel> donations = <DonationModel>[].obs;
  final RxInt totalDonations = 0.obs;

  final RxList<ActionTileModel> actionTiles = <ActionTileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _fetchUserDonations();
    _initializeActionTiles();
  }

  void _initializeActionTiles() {
    actionTiles.value = [
      ActionTileModel(
        title: 'Register Food Bank',
        icon: Icons.store_mall_directory,
        color: Colors.blue,
        onTap: () => Get.toNamed('/register-food-bank'),
      ),
      ActionTileModel(
        title: 'Add Location',
        icon: Icons.add_location_alt,
        color: Colors.green,
        onTap: () => Get.toNamed('/add-location'),
      ),
      ActionTileModel(
        title: 'Volunteer',
        icon: Icons.people,
        color: Colors.orange,
        onTap: () => Get.toNamed('/volunteer'),
      ),
      ActionTileModel(
        title: 'Schedule Pickup',
        icon: Icons.schedule,
        color: Colors.purple,
        onTap: () => Get.toNamed('/schedule-pickup'),
      ),
      ActionTileModel(
        title: 'Donation History',
        icon: Icons.history,
        color: Colors.teal,
        onTap: () => Get.toNamed('/donation-history'),
      ),
      ActionTileModel(
        title: 'Impact Report',
        icon: Icons.insert_chart,
        color: Colors.red,
        onTap: () => Get.toNamed('/impact-report'),
      ),
    ];
  }

  void _loadUserData() {
    user.value = _firebaseService.getCurrentUserModel();
  }

  void _fetchUserDonations() {
    if (user.value == null) return;

    _firebaseService.getUserDonations(user.value!.id).listen((donationsList) {
      donations.value = donationsList;
      totalDonations.value = donationsList.length;
    });
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
  }
}
