import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart'; // For rootBundle
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

// Define the scope of the access token
const List<String> SCOPES = [
  'https://www.googleapis.com/auth/firebase.messaging'
];

Future<String> getAccessToken() async {
  try {
    // Load the service account JSON file as an asset
    final serviceAccountJson = await rootBundle.loadString(
        'assets/json/hunger-cbd8e-firebase-adminsdk-33yfc-c0834f5953.json');
    final serviceAccountMap = jsonDecode(serviceAccountJson);

    // Create credentials using the service account
    final credentials = ServiceAccountCredentials.fromJson(serviceAccountMap);

    // Create an authenticated HTTP client
    final client = http.Client();
    final authClient =
        await clientViaServiceAccount(credentials, SCOPES, baseClient: client);

    // Get the current access token
    final accessToken = authClient.credentials.accessToken;
    log('Access Token: ${accessToken.data}');
    return accessToken.data;
  } catch (e) {
    log('Error: $e');
    return Future.error('Failed to get access token: $e');
  }
}
