import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:talecraft/view/login/login.dart';

class ProfileController extends GetxController {
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => Login());
  }
}
