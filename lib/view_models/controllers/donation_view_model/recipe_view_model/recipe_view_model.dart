import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecipeViewModel extends GetxController {
  GenerativeModel? generativeModel;
  final String apiKey = dotenv.env['GEMINI_API_KEY']!;

  var isLoading = false.obs;
  var recipe = ''.obs;
  var isRecipeGenerated = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() {
    generativeModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<void> getRecipe(List<String> ingredients) async {
    // if (isRecipeGenerated.value) return;

    isLoading.value = true;
    isRecipeGenerated.value = false;
    recipe.value = '';
    try {
      final prompt =
          "Generate a simple recipe using the following ingredients: ${ingredients.join(', ')}.";
      final content = [Content.text(prompt)];
      final response = await generativeModel!.generateContent(content);

      recipe.value = response.text ?? 'Failed to generate a recipe.';
      isRecipeGenerated.value = true;
    } catch (e) {
      log("Error fetching recipe: $e");

      recipe.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
