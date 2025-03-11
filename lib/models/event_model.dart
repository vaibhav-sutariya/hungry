class EventModel {
  final String title;
  final String date;
  final String? time;
  final String imageUrl;
  final bool isLive;

  EventModel({
    required this.title,
    required this.date,
    this.time,
    required this.imageUrl,
    this.isLive = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'],
      date: json['date'],
      time: json['time'],
      imageUrl: json['image'],
      isLive: json['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'image': imageUrl,
      'isLive': isLive,
    };
  }
}
