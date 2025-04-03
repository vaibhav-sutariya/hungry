import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungry/firebase_options.dart';
import 'package:hungry/res/routes/routes.dart';
import 'package:hungry/view/splash_screen.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroudHandler);
  runApp(const MyApp());
}

// for background notifications
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroudHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log(message.notification!.title.toString());
  log(message.notification!.body.toString());
  log(message.data.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hungry',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: GoogleFonts.mulish().fontFamily,
      ),
      home: const SplashScreen(),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
