class ClassModel {
  final String idClass;
  final String title;
  final String date;
  final String time;
  final int price;
  final Map<String, dynamic> participants;

  ClassModel({
    required this.idClass,
    required this.title,
    required this.date,
    required this.time,
    required this.price,
    Map<String, dynamic>? participants,
  }) : participants = participants ?? {};

  factory ClassModel.fromMap(String id, Map data) {
    return ClassModel(
      idClass: id,
      title: data['title'],
      date: data['date'],
      time: data['time'],
      price: data['price'],
      participants: Map<String, dynamic>.from(data['participants'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date, 'time': time, 'price': price};
  }
}
