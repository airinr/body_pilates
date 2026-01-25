class ClassModel {
  final String idClass;
  final String title;
  final String date;
  final String time;
  final int price;
  
  // Ubah tipe data jadi Map<String, dynamic>
  final Map<String, dynamic> participants;
  final Map<String, dynamic> checkedIn; 

  ClassModel({
    required this.idClass,
    required this.title,
    required this.date,
    required this.time,
    required this.price,
    required this.participants, // Wajib diisi (walau kosong)
    required this.checkedIn,    // Wajib diisi (walau kosong)
  });

  // 🔥 UPDATE FACTORY INI AGAR ANTI-ERROR
  factory ClassModel.fromMap(String id, Map<dynamic, dynamic> data) {
    
    // 1. Helper Function: Parsing Map dengan Aman
    // Ini mengubah Map<dynamic, dynamic> -> Map<String, dynamic>
    // Kalau null, dia otomatis return {} (Map kosong)
    Map<String, dynamic> parseMap(dynamic mapData) {
      if (mapData == null) {
        return <String, dynamic>{}; // Return map kosong yang valid
      }
      
      if (mapData is Map) {
        // Lakukan konversi key satu per satu jadi String
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
      // Safety convert price
      price: (data['price'] is int) 
          ? data['price'] 
          : int.tryParse(data['price'].toString()) ?? 0,
      
      // ✅ PANGGIL HELPER PARSING TADI
      participants: parseMap(data['participants']),
      
      // ✅ INI BAGIAN YANG TADI ERROR
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

  // Helper UI
  bool isUserPresent(String userId) {
    return checkedIn.containsKey(userId);
  }
}