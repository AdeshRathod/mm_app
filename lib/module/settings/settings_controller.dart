import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/module/membership/membership_binding.dart';
import 'package:app/module/membership/membership_screen.dart';

class SettingsController extends GetxController {
  var userData = {}.obs;
  var currentPlan = "".obs;
  var planExpiry = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();
        var user = await server.api.getUser(userId);
        userData.value = user;
        currentPlan.value = user['subscriptionType'] ?? "Free";
        planExpiry.value = user['subscriptionExpiry'] ?? "N/A";
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading(false);
    }
  }

  void navigateToMembership() {
    Get.to(() => const MembershipScreen(), binding: MembershipBinding());
  }
}
