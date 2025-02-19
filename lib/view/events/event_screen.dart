import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/events/components/event_card_widget.dart';
import 'package:hungry/view/events/components/past_event_widget.dart';

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
                  child: const Text(
                    "View all >",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

            /// Carousel Slider for Live Events
            CarouselSlider(
              items:
                  liveEvents.map((event) => buildLiveEventCard(event)).toList(),
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
              children:
                  pastEvents.map((event) => buildPastEventCard(event)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
