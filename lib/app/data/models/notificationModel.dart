// file: data/models/notificationModel.dart
class NotificationModel {
  final String id;
  final String classId; // ID Kelas terkait
  final String title;
  final String message;
  final int timestamp; // Kita pakai int (epoch) biar gampang sorting

  NotificationModel({
    required this.id,
    required this.classId,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'title': title,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      classId: map['classId'] ?? '',
      title: map['title'] ?? 'Tidak Berjudul',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }
}