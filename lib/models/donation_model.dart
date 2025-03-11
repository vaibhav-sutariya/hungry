class DonationModel {
  final String id;
  final String title;
  final String description;
  final int timestamp;
  final String userId;

  DonationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.userId,
  });

  factory DonationModel.fromMap(
      Map<dynamic, dynamic> map, String id, String userId) {
    return DonationModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timestamp: map['timestamp'] ?? 0,
      userId: userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}
