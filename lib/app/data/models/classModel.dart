class ClassModel {
  final String idClass;
  final String title;
  final String date;
  final String time;
  final int price;
  
  final Map<String, dynamic> participants;
  final Map<String, dynamic> checkedIn; 

  ClassModel({
    required this.idClass,
    required this.title,
    required this.date,
    required this.time,
    required this.price,
    required this.participants, 
    required this.checkedIn,    
  });

  factory ClassModel.fromMap(String id, Map<dynamic, dynamic> data) {
    
    Map<String, dynamic> parseMap(dynamic mapData) {
      if (mapData == null) {
        return <String, dynamic>{}; 
      }
      
      if (mapData is Map) {
        return mapData.map((key, value) {
          return MapEntry(key.toString(), value);
        });
      }
      
      return <String, dynamic>{};
    }

    return ClassModel(
      idClass: id,
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      price: (data['price'] is int) 
          ? data['price'] 
          : int.tryParse(data['price'].toString()) ?? 0,
      participants: parseMap(data['participants']),
      checkedIn: parseMap(data['checkedIn']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title, 
      'date': date, 
      'time': time, 
      'price': price,
      'participants': participants,
      'checkedIn': checkedIn, 
    };
  }

  bool isUserPresent(String userId) {
    return checkedIn.containsKey(userId);
  }
}