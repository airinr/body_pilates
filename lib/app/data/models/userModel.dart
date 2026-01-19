import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String username;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.username,
    required this.createdAt,
  });

  // Convert ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Method logout
  Future<void> Logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Convert dari Firestore ke Object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      username: map['username'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
