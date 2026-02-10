import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../data/models/userModel.dart';
import '../services/firestore_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  var isLoading = false.obs;

  Future<void> register(UserModel user, String password) async {
    try {
      isLoading.value = true;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final newUser = UserModel(
        uid: credential.user!.uid,
        email: user.email,
        fullName: user.fullName,
        username: user.username,
        createdAt: DateTime.now(),
      );

      await _firestore.saveUser(newUser);

      Get.snackbar("Success", "Register berhasil");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
