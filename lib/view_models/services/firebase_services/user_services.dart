import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/models/user_model.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  User? get currentUser => _auth.currentUser;

  UserModel? getCurrentUserModel() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  Stream<List<DonationModel>> getUserDonations(String userId) {
    return _database
        .child('donations')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      List<DonationModel> donations = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          donations.add(DonationModel.fromMap(
            Map<String, dynamic>.from(value as Map),
            key,
            userId,
          ));
        });
      }

      return donations;
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
