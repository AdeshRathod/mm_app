import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendedMatchesController extends GetxController {
  var users = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
  }

  void fetchMatches() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString('user_id');

      Server server = Server();
      if (currentUserId != null) {
        var currentUser = await server.api!.getUser(currentUserId);
        String gender = currentUser['gender'] ??
            currentUser['basicDetails']?['gender'] ??
            "";
        String targetGender =
            gender.toLowerCase() == 'male' ? 'female' : 'male';

        // Use export endpoint with gender filter to get all users of target gender
        // Or better, just get all and filter locally for now if no specific "search/match" endpoint
        var allUsers = await server.api!.getUsers();
        users.value = allUsers.where((u) {
          String uGender = u['gender'] ?? u['basicDetails']?['gender'] ?? "";
          return uGender.toLowerCase() == targetGender.toLowerCase() &&
              u['_id'] != currentUserId;
        }).toList();
      } else {
        users.value = await server.api!.getUsers();
      }
    } catch (e) {
      print("Error fetching matches: $e");
    } finally {
      isLoading(false);
    }
  }
}

class RecommendedMatchesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecommendedMatchesController());
  }
}
