import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/models/user_model.dart';
import 'package:hungry/view_models/services/firebase_services/user_services.dart';

class ProfileViewModel extends GetxController {
  final FirebaseService _firebaseService =
      Get.put<FirebaseService>(FirebaseService());

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<DonationModel> donations = <DonationModel>[].obs;
  final RxInt totalDonations = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _fetchUserDonations();
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
