import 'userModel.dart';

class MemberModel extends UserModel {
  // Atribut spesifik sesuai diagram
  final List<String> enrolledClassIds;

  MemberModel({
    required String uid,
    required String email,
    required String fullName,
    required String username,
    required DateTime createdAt,
    this.enrolledClassIds = const [], // Default list kosong
  }) : super(
          uid: uid,
          email: email,
          fullName: fullName,
          username: username,
          createdAt: createdAt,
        );

  // Method isEnrolled(idClass): boolean
  bool isEnrolled(String idClass) {
    return enrolledClassIds.contains(idClass);
  }

  // Method enrollClass(idClass): void
  // Note: Ini biasanya cuma buat update lokal, aslinya nanti update ke Firebase
  void enrollClass(String idClass) {
    if (!enrolledClassIds.contains(idClass)) {
      enrolledClassIds.add(idClass);
    }
  }

  // Factory untuk mapping dari Firestore (Termasuk data UserModel)
  factory MemberModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return MemberModel(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      createdAt: data['createdAt'] ?? '',
      // Ambil list ID kelas yang diikuti dari Firestore
      enrolledClassIds: List<String>.from(data['enrolledClassIds'] ?? []),
    );
  }
}