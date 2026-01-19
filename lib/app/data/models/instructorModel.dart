import 'userModel.dart';

class InstructorModel extends UserModel {
  InstructorModel({
    required String uid,
    required String email,
    required String fullName,
    required String username,
    required dynamic createdAt,
  }) : super(
          uid: uid,
          email: email,
          fullName: fullName,
          username: username,
          createdAt: createdAt,
        );

  // Sesuai Class Diagram
  void broadcastMessage(String message) {
    print("Broadcasting: $message");
  }

  void manageClass(String action, String idClass) {
    print("Action $action on class $idClass");
  }

  void showQR(String idClass) {
    print("Showing QR for $idClass");
  }

  factory InstructorModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return InstructorModel(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      // Logic safety check tanggal dipindah ke sini biar rapi
      createdAt: data['createdAt'], 
    );
  }
}