import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hungry/models/left_over_food_model.dart';
import 'package:hungry/view_models/controllers/left_over_food/left_over_food_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationDetailsViewModel extends GetxController {
  final _food = Rxn<LeftoverFood>();
  final _isLoading = false.obs;
  final _error = Rxn<String>();
  String? _userId; // Store the userId where the foodId was found

  LeftoverFood? get food => _food.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  Future<void> fetchFoodDetails(String foodId) async {
    _isLoading.value = true;
    _error.value = null;
    _userId = null;
    update();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _error.value = 'User not logged in';
        _isLoading.value = false;
        update();
        return;
      }

      final databaseReference = FirebaseDatabase.instance.ref();
      final usersSnapshot = await databaseReference.child('leftOverFood').get();

      if (!usersSnapshot.exists) {
        _error.value = 'No leftover food data found';
        _isLoading.value = false;
        update();
        return;
      }

      // Search for foodId across all userIds
      bool found = false;
      final usersData = usersSnapshot.value as Map<dynamic, dynamic>;
      for (var userEntry in usersData.entries) {
        final userId = userEntry.key as String;
        final foodEntries = userEntry.value as Map<dynamic, dynamic>;
        if (foodEntries.containsKey(foodId)) {
          _food.value = LeftoverFood.fromJson(foodId, foodEntries[foodId]);
          _userId = userId; // Store userId for claimDonation
          found = true;
          break;
        }
      }

      if (!found) {
        _error.value = 'No data found for ID: $foodId';
      }
    } catch (e) {
      _error.value = 'Error fetching data: $e';
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> claimDonation() async {
    if (_food.value == null || _userId == null) {
      Get.snackbar('Error', 'No food data or user ID available');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseDatabase.instance
            .ref()
            .child('leftOverFood')
            .child(_userId!)
            .child(_food.value!.id)
            .update({'status': 'claimed'});
        Get.snackbar('Success', 'Donation claimed!');
      } else {
        Get.snackbar('Error', 'User not logged in');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to claim donation: $e');
    }
  }

  Future<void> approveDonation() async {
    if (_food.value == null || _userId == null) {
      Get.snackbar('Error', 'No food data or user ID available');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseDatabase.instance
            .ref()
            .child('leftOverFood')
            .child(_userId!)
            .child(_food.value!.id)
            .update({'status': 'approved'});
        Get.snackbar('Success', 'Donation approved!');
        LeftOverFoodViewModel().sendNotification(
            _food.value!.id, _food.value!.fName, _food.value!.address);
      } else {
        Get.snackbar('Error', 'User not logged in');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve donation: $e');
    }
  }

  Future<void> contactDonor(String phone) async {
    try {
      final uri = Uri.parse('tel:$phone');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('Error', 'Cannot launch phone dialer for $phone');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to contact donor: $e');
    }
  }
}
