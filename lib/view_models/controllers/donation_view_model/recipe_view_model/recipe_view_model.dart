import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecipeViewModel extends GetxController {
  GenerativeModel? generativeModel;
  final String apiKey = dotenv.env['GEMINI_API_KEY']!; // Store securely

  var isLoading = false.obs; // Reactive loading state
  var recipe = ''.obs; // Reactive recipe state
  var isRecipeGenerated = false.obs; // Check if recipe is already generated

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() {
    generativeModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<void> getRecipe(List<String> ingredients) async {
    if (isRecipeGenerated.value) return; // Don't regenerate if already done

    isLoading.value = true; // Set loading to true while fetching
    try {
      final prompt =
          "Generate a simple recipe using the following ingredients: ${ingredients.join(', ')}.";
      final content = [Content.text(prompt)];
      final response = await generativeModel!.generateContent(content);

      // Check if the response has valid content and assign it
      recipe.value = response.text ?? 'Failed to generate a recipe.';
    } catch (e) {
      log("Error fetching recipe: $e"); // Log the error for debugging
      recipe.value = 'Error: ${e.toString()}'; // Handle errors gracefully
    } finally {
      isLoading.value = false; // Set loading to false after completion
      isRecipeGenerated.value = true; // Mark as generated
    }
  }
}
