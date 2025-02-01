import 'package:url_launcher/url_launcher.dart';

void launchFeedbackForm() async {
  const url =
      'https://docs.google.com/forms/d/e/1FAIpQLScwD_Bbj022AZa53E2GLj6njmveK0p4nqBXO_r9eaZYg6eVHQ/viewform';
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching URL: $e');
  }
}
