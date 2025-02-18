import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> liveEvents = [
    {
      "title": "Maninagar Evening Katha",
      "date": "Sat 14th May",
      "time": "7.45pm IST",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
    },
    {
      "title": "Temple Morning Aarti",
      "date": "Sun 15th May",
      "time": "6.00am IST",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
    }
  ];

  final List<Map<String, String>> pastEvents = [
    {
      "title": "Charity Food Drive",
      "date": "Fri 10th May",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
    },
    {
      "title": "Community Gathering",
      "date": "Wed 8th May",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
    },
    {
      "title": "Community Gathering",
      "date": "Wed 8th May",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxayvVBVrSvFSO2nfVrnJaNNC6QLTwG70fw&s"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LIVE BROADCAST SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "LIVE BROADCAST",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all >"),
                ),
              ],
            ),

            /// Carousel Slider for Live Events
            CarouselSlider(
              items: liveEvents
                  .map((event) => _buildLiveEventCard(event))
                  .toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),

            /// Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: liveEvents.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.orange
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// PAST EVENTS SECTION
            const Text(
              "PAST EVENTS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// List of Past Events
            Column(
              children: pastEvents
                  .map((event) => _buildPastEventCard(event))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a Card for Live Events (Carousel)
  Widget _buildLiveEventCard(Map<String, String> event) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            event["image"]!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event["title"]!,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "${event["date"]} | ${event["time"]}",
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const Icon(Icons.play_circle_fill,
                color: Colors.orange, size: 30),
          ),
        ),
      ],
    );
  }

  /// Builds a Card for Past Events
  Widget _buildPastEventCard(Map<String, String> event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(event["image"]!,
              width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(event["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(event["date"]!),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
