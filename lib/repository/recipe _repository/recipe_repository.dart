import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RecipeRepository extends GetxController {
  final String geminiApiKey = dotenv.env['GEMINI_API_KEY']!; // Store securely

  // Fetch recipe using ingredients
  Future<String> fetchRecipe(List<String> ingredients) async {
    try {
      // Check if the API key is null or empty
      if (geminiApiKey.isEmpty) {
        throw Exception("Gemini API key is missing or invalid.");
      }

      final url = Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey");

      // Adjusted request body format based on possible API expectations
      final requestBody = {
        "textInput": {
          // Changed to `textInput` instead of `prompt`
          "content":
              "Generate a simple recipe using the following ingredients: ${ingredients.join(', ')}."
        }
      };

      // Sending POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      // Debugging: Log the response status and body
      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");
      // Handling the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']; // Extract recipe
        } else {
          throw Exception("No recipe candidates found in response.");
        }
      } else {
        throw Exception(
            "Failed to fetch recipe. Status Code: ${response.statusCode}. Response: ${response.body}");
      }
    } catch (e) {
      // Handling any errors
      if (e is Exception) {
        // Log and throw the error for debugging purposes
        log("Error fetching recipe: $e");
        return "Error: ${e.toString()}";
      } else {
        print("Unexpected error: $e");
        return "Unexpected error occurred.";
      }
    }
  }
}
