import 'package:get/get.dart';
import 'package:app/module/dashboard/dashboard_screen.dart';
import 'package:app/module/dashboard/dashboard_binding.dart';
import 'package:app/module/search/search_screen.dart';
import 'package:app/module/recommended_matches/recommended_matches_screen.dart';
import 'package:app/module/settings/settings_screen.dart';
import 'package:app/module/social/interests_received_screen.dart';
import 'package:app/core/Server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<dynamic> screens = [
    const DashboardScreen(),
    const SearchScreen(),
    const InterestsReceivedScreen(),
    const RecommendedMatchesScreen(),
    SettingsScreen(),
  ];

  var interestCount = 0.obs;
  var matchCount = 0.obs;
  int totalMatchCount = 0;

  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }

  void fetchCounts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId != null) {
        Server server = Server();

        // 1. Fetch Interests
        var interests = await server.api.getReceivedInterests(userId);
        interestCount.value =
            interests.where((i) => i['interestStatus'] == 'pending').length;

        // 2. Fetch Matches Count
        var user = await server.api.getUser(userId);
        String gender = user['gender'] ?? user['basicDetails']?['gender'] ?? "";
        String targetGender = "";
        if (gender.isNotEmpty) {
          targetGender = (gender.toLowerCase() == 'male') ? 'female' : 'male';
        }

        if (targetGender.isNotEmpty) {
          var matches = await server.api.getFilteredUsers(gender: targetGender);
          var filtered = matches.where((u) => u['_id'] != userId).toList();
          totalMatchCount = filtered.length;

          // Use server-side tracking
          int seenCount = (user['lastViewedMatchCount'] ?? 0);

          if (totalMatchCount > seenCount) {
            matchCount.value = totalMatchCount - seenCount;
          } else {
            matchCount.value = 0;
          }
        }
      } else {
        // Guest mode - no counts
        interestCount.value = 0;
        matchCount.value = 0;
      }
    } catch (e) {
      print("Error fetching counts: $e");
    }
  }

  void changeIndex(int index) async {
    selectedIndex.value = index;
    if (index == 0) {
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().fetchDashboardData(silent: true);
      }
    }
    // Index 3 is Matches/RecommendedMatches
    if (index == 3) {
      matchCount.value = 0;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId != null) {
        await Server()
            .api
            .updateUser(userId, {'lastViewedMatchCount': totalMatchCount});
      }
    }
  }
}
