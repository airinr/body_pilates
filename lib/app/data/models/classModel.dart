class ClassModel {
  final String idClass;
  final String title;
  final String date;
  final String time;
  final int price;

  ClassModel({
    required this.idClass,
    required this.title,
    required this.date,
    required this.time,
    required this.price,
  });

  factory ClassModel.fromMap(String id, Map data) {
    return ClassModel(
      idClass: id,
      title: data['title'],
      date: data['date'],
      time: data['time'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date, 'time': time, 'price': price};
  }
}
