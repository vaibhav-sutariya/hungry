class DonationModel {
  final String id;
  final List<String> items;
  final int timestamp;
  final String userId;

  DonationModel({
    required this.id,
    required this.items,
    required this.timestamp,
    required this.userId,
  });

  factory DonationModel.fromMap(
      Map<dynamic, dynamic> map, String id, String userId) {
    return DonationModel(
      id: id,
      items: (map['donations'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      timestamp: map['timestamp'] ?? 0,
      userId: userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donations': items,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}
