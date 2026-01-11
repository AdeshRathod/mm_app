import 'dart:async';
import 'package:get/get.dart';
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
  Timer? _heartbeatTimer;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    _startHeartbeat();
  }

  @override
  void onClose() {
    _heartbeatTimer?.cancel();
    super.onClose();
  }

  void _startHeartbeat() async {
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 2), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId != null) {
        Server().api.sendHeartbeat(userId);
      }
    });

    // Initial heartbeat
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId != null) Server().api.sendHeartbeat(userId);
  }

  void fetchDashboardData({bool silent = false}) async {
    try {
      if (!silent) isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();

        // Parallel fetching
        // 1. Fetch user profile first
        var user = await server.api.getUser(userId);
        userData.value = user;

        String gender = user['gender'] ?? user['basicDetails']?['gender'] ?? "";
        String targetGender = "";
        if (gender.isNotEmpty) {
          targetGender = (gender.toLowerCase() == 'male') ? 'female' : 'male';
        }

        // 2. Parallel fetch other data
        final results = await Future.wait([
          server.api.getBanners(),
          server.api.getUserStats(userId),
          targetGender.isNotEmpty
              ? server.api.getFilteredUsers(gender: targetGender)
              : server.api.getUsers(),
        ]);

        banners.value = results[0] as List<dynamic>;
        userStats.value = results[1] as Map<String, dynamic>;

        List<dynamic> users = results[2] as List<dynamic>;

        // Filter out self and ensure unique
        var filteredUsers =
            users.where((u) => u['_id'] != userId).toSet().toList();

        recommendedUsers.value = filteredUsers.take(5).toList();
        newUsers.value = filteredUsers.reversed.take(5).toList();

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
        var user = await server.api.getUser(userId);

        // Check if subscriptionStatus is active or trial
        String? status = user['subscriptionStatus'];

        bool hasAccess = (status == 'active' || status == 'trial');

        if (!hasAccess) {
          Get.offAll(() => const MembershipScreen(),
              binding: MembershipBinding());
        }
      } catch (e) {
        print("Error checking subscription: $e");
      }
    }
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
