import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/models/food_item_model.dart';

class RegisteredFoodBankController extends GetxController {
  var foodItems = <FoodItemModel>[].obs;

  Future<void> fetchFoodItems() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('leftOverFood');
    Position currentPosition = await Geolocator.getCurrentPosition();

    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<FoodItemModel> tempList = [];

        data.forEach((_, userFoodMap) {
          if (userFoodMap is Map) {
            userFoodMap.forEach((foodId, foodData) {
              if (foodData is Map) {
                try {
                  final item = FoodItemModel.fromMap(foodData, foodId);

                  double lat = item.location['latitude'] ?? 0;
                  double lng = item.location['longitude'] ?? 0;

                  item.distance = Geolocator.distanceBetween(
                          currentPosition.latitude,
                          currentPosition.longitude,
                          lat,
                          lng) /
                      1000; // convert to km

                  tempList.add(item);
                } catch (e) {
                  debugPrint("Error parsing food item: $e");
                }
              }
            });
          }
        });

        tempList.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
        foodItems.value = tempList;
      } else {
        foodItems.clear();
      }
    });
  }

  void updateFoodStatus(FoodItemModel item, String newStatus) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('leftOverFood');

    try {
      DatabaseEvent event = await ref.once();
      final data = event.snapshot.value as Map?;
      if (data != null) {
        data.forEach((userId, userFoodMap) {
          if (userFoodMap is Map && userFoodMap.containsKey(item.id)) {
            ref.child(userId).child(item.id).update({
              'status': newStatus,
              'updatedAt': DateTime.now().toIso8601String(),
            });
            foodItems.refresh();
            return;
          }
        });
      }
    } catch (e) {
      debugPrint("Error updating food status: $e");
    }
  }
}
