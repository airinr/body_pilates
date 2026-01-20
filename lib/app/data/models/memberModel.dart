import 'userModel.dart';

class MemberModel extends UserModel {
  // 🔹 List kelas yang diikuti (mutable)
  final List<String> enrolledClassIds;

  MemberModel({
    required String uid,
    required String email,
    required String fullName,
    required String username,
    required DateTime createdAt,
    List<String>? enrolledClassIds,
  }) : enrolledClassIds = enrolledClassIds ?? [],
       super(
         uid: uid,
         email: email,
         fullName: fullName,
         username: username,
         createdAt: createdAt,
       );

  // ===============================
  // CEK SUDAH ENROLL ATAU BELUM
  // ===============================
  bool isEnrolled(String idClass) {
    return enrolledClassIds.contains(idClass);
  }

  // ===============================
  // TAMBAH KELAS
  // ===============================
  void addEnrolledClass(String idClass) {
    if (!enrolledClassIds.contains(idClass)) {
      enrolledClassIds.add(idClass);
    }
  }

  // ===============================
  // FACTORY DARI FIREBASE (FIXED)
  // ===============================
  factory MemberModel.fromFirestore(Map<String, dynamic> data, String uid) {
    DateTime createdAt;

    final rawCreatedAt = data['createdAt'];

    if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is DateTime) {
      createdAt = rawCreatedAt;
    } else if (rawCreatedAt is int) {
      // jaga-jaga kalau timestamp
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    } else {
      createdAt = DateTime.now();
    }

    return MemberModel(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      createdAt: createdAt,
      enrolledClassIds: List<String>.from(data['enrolledClassIds'] ?? []),
    );
  }
}
