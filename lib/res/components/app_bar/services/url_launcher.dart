import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackController extends GetxController {
  final String feedbackUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLScwD_Bbj022AZa53E2GLj6njmveK0p4nqBXO_r9eaZYg6eVHQ/viewform';

  Future<void> launchFeedbackForm() async {
    try {
      final Uri url = Uri.parse(feedbackUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar('Error', 'Could not open the feedback form');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to launch URL: $e');
    }
  }
}
