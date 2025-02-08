import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:hungry/models/location_model.dart';

class FirebaseRepository {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<List<LocationModel>> fetchUserLocations() async {
    try {
      DataSnapshot snapshot = await _databaseRef.child('locations').get();
      return _parseUserData(snapshot);
    } catch (e) {
      log('Error fetching user locations: $e');
      return [];
    }
  }

  Future<List<LocationModel>> fetchFoodBanks() async {
    try {
      DataSnapshot snapshot = await _databaseRef.child('FoodBanks').get();
      return _parseUserData(snapshot);
    } catch (e) {
      log('Error fetching food banks: $e');
      return [];
    }
  }

  List<LocationModel> _parseUserData(DataSnapshot snapshot) {
    List<LocationModel> userList = [];
    if (snapshot.value != null) {
      Map<dynamic, dynamic>? usersDataMap = snapshot.value as Map?;
      usersDataMap?.forEach((userId, userData) {
        Map<dynamic, dynamic>? userDataMap = userData as Map?;
        userDataMap?.forEach((id, data) {
          userList.add(LocationModel.fromJson(Map<String, dynamic>.from(data)));
        });
      });
    }
    return userList;
  }
}
