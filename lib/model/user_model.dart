// MODEL: This file defines the data structure for a User.
class User {
  final int id;
  final String username;
  final String role;

  User({required this.id, required this.username, required this.role});

  // Factory constructor to create a User instance from a JSON map.
  // This is used when decoding data from the API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], username: json['username'], role: json['role']);
  }
}
