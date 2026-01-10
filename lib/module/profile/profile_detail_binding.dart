import 'package:get/get.dart';

class ProfileDetailController extends GetxController {
  // Mock data for UI state
  bool isShortlisted = false;
  bool isInterestSent = false;

  void toggleShortlist() {
    isShortlisted = !isShortlisted;
    update();
  }

  void sendInterest() {
    isInterestSent = true;
    update();
    Get.snackbar("Success", "Interest sent successfully!",
        snackPosition: SnackPosition.BOTTOM);
  }

  void initiateCall() {
    // Implement call logic or permission check
    print("Initiate Call");
  }

  void initiateChat() {
    // Implement chat logic
    print("Initiate Chat");
  }
}

class ProfileDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileDetailController());
  }
}
