import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talecraft/view/login/login.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    box.erase();
    Get.offAll(() => Login());
  }
}
