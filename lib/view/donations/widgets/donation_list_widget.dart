import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view_models/controllers/donation_view_model/recipe_view_model/recipe_view_model.dart';

class DonationListWidget extends StatelessWidget {
  final List<DonationModel> donations;
  final bool isLoading;

  const DonationListWidget({
    super.key,
    required this.donations,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final RecipeViewModel viewModel = Get.put(RecipeViewModel());

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (donations.isEmpty) {
      return const Center(child: Text("No donations available 😔"));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          var donation = donations[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fastfood_rounded,
                  color: Colors.green,
                  size: 28,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: donation.items
                    .map((item) =>
                        Text("- $item", style: const TextStyle(fontSize: 14)))
                    .toList(),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18,
              ),
              onTap: () =>
                  _showRecipeDialog(context, viewModel, donation.items),
            ),
          );
        },
      ),
    );
  }

  void _showRecipeDialog(BuildContext context, RecipeViewModel viewModel,
      List<String> ingredients) {
    // Call getRecipe to fetch the recipe for the selected donation
    viewModel.getRecipe(ingredients);

    // Show the recipe dialog with loading indicator and fetched content
    Get.defaultDialog(
      backgroundColor: AppColors.kWhiteColor,
      title: "Generated Recipe",
      content: Obx(() => viewModel.isLoading.value
          ? const Center(
              child:
                  CircularProgressIndicator()) // Centered spinner during loading
          : ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.7, // Constrain the max height of the dialog
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    viewModel.recipe.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )),
      textConfirm: "Close",
      buttonColor: AppColors.kPrimaryColor,
      titleStyle: const TextStyle(
        color: AppColors.kPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      confirmTextColor: AppColors.kWhiteColor,
      onConfirm: () => Get.back(),
      radius: 15.0,
    );
  }
}
