import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/view/donations/recipe_screen/recipe_screen.dart';
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
                  _navigateToRecipeScreen(context, donations[index].items),
            ),
          );
        },
      ),
    );
  }

  void _navigateToRecipeScreen(
      BuildContext context, List<String> ingredients) async {
    final RecipeViewModel viewModel = Get.put(RecipeViewModel());

    Get.to(() => RecipeScreen());
    await viewModel.getRecipe(ingredients);
  }
}
