import 'package:get/get.dart';
import 'package:app/module/search/search_binding.dart';
import 'package:app/module/search/search_screen.dart';
import 'package:app/module/settings/settings_binding.dart';
import 'package:app/module/settings/settings_screen.dart';
import 'package:app/module/recommended_matches/recommended_matches_binding.dart';
import 'package:app/module/recommended_matches/recommended_matches_screen.dart';
import 'package:app/core/Server.dart';
import 'package:app/module/membership/membership_binding.dart';
import 'package:app/module/membership/membership_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  int selectedIndex = 0;
  var banners = <dynamic>[].obs;
  var userStats = {}.obs;
  var userData = {}.obs;
  var recommendedUsers = <dynamic>[].obs;
  var newUsers = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();

        // Parallel fetching
        final results = await Future.wait([
          server.api!.getBanners(),
          server.api!.getUserStats(userId),
          server.api!.getUser(userId),
          server.api!.getUsers(),
        ]);

        banners.value = results[0] as List<dynamic>;
        userStats.value = results[1] as Map<String, dynamic>;
        userData.value = results[2] as Map<String, dynamic>;

        List<dynamic> allUsers = results[3] as List<dynamic>;
        recommendedUsers.value = allUsers.take(5).toList();
        newUsers.value = allUsers.reversed.take(5).toList();

        // Check subscription
        String? status = userData['subscriptionStatus'];
        bool hasAccess = (status == 'active' || status == 'trial');
        if (!hasAccess) {
          Get.offAll(() => const MembershipScreen(),
              binding: MembershipBinding());
        }
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
    } finally {
      isLoading(false);
      update();
    }
  }

  void checkSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      try {
        Server server = Server();
        var user = await server.api!.getUser(userId);

        // Check if subscriptionStatus is active or trial
        String? status = user['subscriptionStatus'];
        // String? type = user['subscriptionType'];

        bool hasAccess = (status == 'active' || status == 'trial');

        if (!hasAccess) {
          // Redirect to Subscription/Membership Screen
          // Using Get.offAll might be too aggressive if we want them to be able to go back/close?
          // User said "if subscription is not there or expired then the subscription screen should be there"
          // Likely replacing dashboard or blocking access.
          Get.offAll(() => const MembershipScreen(),
              binding: MembershipBinding());
        }
      } catch (e) {
        print("Error checking subscription: $e");
        // Verify what to do on error. Fallback? Or Block?
        // For security/business logic, fail closed?
      }
    }
  }

  void onBottomBarItemTap(int value) {
    selectedIndex = value;
    update();
    switch (value) {
      case 0:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ActivityHomeScreen()),
        // );
        break;
      case 1:
        Get.to(const SearchScreen(), binding: SearchBinding());
        break;
      case 2:
        Get.to(const RecommendedMatchesScreen(),
            binding: RecommendedMatchesBinding());
        break;
      case 3:
        Get.to(SettingsScreen(), binding: SettingsBinding());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ActivitySettingsScreen()),
        // );
        break;
    }
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
