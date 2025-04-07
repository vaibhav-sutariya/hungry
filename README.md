# 🍱 HUNGRY – Free Food Finder App

## 🚀 Introduction

**"Hungry"** is a socially impactful mobile application aimed at eliminating hunger by minimizing food wastage. The app bridges the gap between those who have surplus food (restaurants, individuals, and NGOs) and those who are in dire need of it. Built with Flutter and Firebase, Hungry offers real-time information on nearby free food locations such as shelters, community kitchens, and food banks.

💡 **Inspired by SDG Goal 2: Zero Hunger**, the app empowers communities to contribute actively to ending hunger, improving food security, and promoting sustainable practices.

---

## 🧩 Problem Statement

Millions of people go hungry every day while tons of food go to waste. There’s no centralized system for those in need to easily find free food resources or for donors to connect with the needy. "Hungry" addresses this issue with a smart and interactive mobile solution.

---

## 🌟 Key Features

- 🗺️ **Nearby Food Locator**: Locate free food spots using Google Maps.
- 🍲 **Donate Excess Food**: NGOs, restaurants, or individuals can list food donations.
- 🔔 **Push Notifications**: Instant alerts when new food becomes available.
- 🔐 **Google Sign-In**: Simple and secure Firebase-based login.
- 📝 **User Profiles**: Manage your donations and requests.
- 📍 **Real-time Tracking**: Get directions to food locations with built-in Maps.

---

## 🛠️ Technologies Used

| Tech Stack       | Description                           |
|------------------|----------------------------------------|
| Flutter          | UI toolkit for building native apps     |
| Dart             | Programming language for Flutter        |
| Firebase         | Authentication, Firestore, and more     |
| Google Maps API  | Location services and map rendering     |
| Firebase Cloud Messaging | For real-time notifications     |
| Gemini AI | For Generate the recipie based on donated ingrediants     |

---

## ⚙️ Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/vaibhav-sutariya/hungry.git
cd hungry
```

2. Open the project in your preferred Flutter development environment.

3. Get an API key at <https://cloud.google.com/maps-platform/>.

4. Paste an API Key according to below instruction.

### Android

Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

### iOS

Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```objectivec
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
Opt-in to the embedded views preview by adding a boolean property to the app's `Info.plist` file
with the key `io.flutter.embedded_views_preview` and the value `YES`.

5. Run the Flutter app using the following command:

```
flutter run
```

<br>

### 📽️ Demo Video
<a href="https://youtu.be/kiw9dwqDoqo?si=-nEj0u2ZIsi1Iu9u">▶️ Watch Demo on YouTube</a>

This video was submitted for the Google Solution Challenge 2025. It explains the motivation, tech stack, problem-solving approach, and a complete walkthrough of the application features.

---
<br>

### 🧾 Conclusion
"Hungry" bridges the gap between food wastage and hunger.

Aims to build a community-led solution for zero food wastage.

Acts as a digital NGO that empowers users to become both donors and seekers.

Fully aligned with the UN’s Sustainable Development Goal 2 – Zero Hunger.

Encourages youth, developers, and changemakers to participate in social good.

---
<br>

### 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---
<br>

### 🙌 Acknowledgements
Google Developers Groups

Firebase & Google Cloud Platforms

Open-source Flutter community





