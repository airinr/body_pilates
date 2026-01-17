import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/userModel.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }
}
