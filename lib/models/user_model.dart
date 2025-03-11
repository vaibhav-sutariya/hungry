class UserModel {
  final String id;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final String? phoneNumber;

  UserModel({
    required this.id,
    this.displayName,
    this.email,
    this.photoURL,
    this.phoneNumber,
  });
}
