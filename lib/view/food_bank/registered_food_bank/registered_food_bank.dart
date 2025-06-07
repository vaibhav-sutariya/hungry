import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view_models/controllers/food_bank/registered_food_bank_controller.dart';

class RegisteredFoodBank extends StatelessWidget {
  final controller = Get.put(RegisteredFoodBankController());

  RegisteredFoodBank({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchFoodItems();

    return RefreshIndicator(
      color: AppColors.kPrimaryColor,
      onRefresh: () async => controller.fetchFoodItems(),
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(showLogOut: true),
        body: Obx(() {
          if (controller.foodItems.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.kPrimaryColor,
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.foodItems.length,
            itemBuilder: (context, index) {
              final item = controller.foodItems[index];
              final isClaimed = item.status?.toLowerCase() == 'claimed';

              return Card(
                color: isClaimed ? Colors.grey[300] : AppColors.kWhiteColor,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fastfood, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.details,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      infoRow(Icons.person, 'Donor', item.fName),
                      infoRow(Icons.phone, 'Phone', item.phone),
                      infoRow(Icons.location_on, 'Address', item.address),
                      infoRow(Icons.people, 'Serves', item.numberOfPersons),
                      infoRow(Icons.info_outline, 'Status',
                          item.status ?? 'Pending'),
                      infoRow(Icons.map, 'Distance',
                          '${item.distance?.toStringAsFixed(2) ?? "-"} km'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isClaimed)
                            ElevatedButton.icon(
                              onPressed: () =>
                                  controller.updateFoodStatus(item, 'claimed'),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text("Claim"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                iconColor: AppColors.kWhiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          if (!isClaimed) const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () =>
                                controller.updateFoodStatus(item, 'rejected'),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text("Reject"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              foregroundColor: Colors.white,
                              iconColor: AppColors.kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
