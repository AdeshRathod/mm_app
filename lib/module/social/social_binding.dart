import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialController extends GetxController {
  var shortlistedUsers = <dynamic>[].obs;
  var receivedInterests = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSocialData();
  }

  void fetchSocialData() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();
        final results = await Future.wait([
          server.api!.getShortlistedUsers(userId),
          server.api!.getReceivedInterests(userId),
        ]);

        shortlistedUsers.value = results[0];
        receivedInterests.value = results[1];
      }
    } catch (e) {
      print("Error fetching social data: $e");
    } finally {
      isLoading(false);
    }
  }
}

class SocialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SocialController());
  }
}
