import 'userModel.dart';

class MemberModel extends UserModel {
  final List<String> enrolledClassIds;

  MemberModel({
    required String uid,
    required String email,
    required String name,
    required String username,
    required DateTime createdAt,
    List<String>? enrolledClassIds,
  }) : enrolledClassIds = enrolledClassIds ?? [],
       super(
         uid: uid,
         email: email,
         fullName: name, // disimpan ke fullName milik UserModel
         username: username,
         createdAt: createdAt,
       );

  bool isEnrolled(String idClass) {
    return enrolledClassIds.contains(idClass);
  }

  void addEnrolledClass(String idClass) {
    if (!enrolledClassIds.contains(idClass)) {
      enrolledClassIds.add(idClass);
    }
  }

  factory MemberModel.fromFirestore(Map<String, dynamic> data, String uid) {
    DateTime createdAt;
    final rawCreatedAt = data['createdAt'];

    if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is DateTime) {
      createdAt = rawCreatedAt;
    } else if (rawCreatedAt is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    } else {
      createdAt = DateTime.now();
    }

    return MemberModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '', // ✅ FIX UTAMA
      username: data['username'] ?? '',
      createdAt: createdAt,
      enrolledClassIds: List<String>.from(data['enrolledClassIds'] ?? []),
    );
  }
}
