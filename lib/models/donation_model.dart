class DonationModel {
  final String id;
  final String title;
  final String description;
  final String userId;
  // Add other properties as needed

  DonationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
  });

  factory DonationModel.fromMap(Map<String, dynamic> map, String id) {
    return DonationModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
    };
  }
}
