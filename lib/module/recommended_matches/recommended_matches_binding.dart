import 'package:flutter/material.dart';
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
      List<dynamic> allUsers = [];
      String? targetGender;

      if (currentUserId != null) {
        try {
          var currentUser = await server.api.getUser(currentUserId);
          String gender = currentUser['gender'] ??
              currentUser['basicDetails']?['gender'] ??
              "";
          if (gender.isNotEmpty) {
            targetGender = gender.toLowerCase() == 'male' ? 'female' : 'male';
          }
        } catch (e) {
          print("Error getting current user: $e");
        }

        // Try filtered first if we have a target gender
        if (targetGender != null) {
          allUsers = await server.api.getFilteredUsers(gender: targetGender);
        } else {
          // Only fetch all if gender is unknown (which shouldn't happen usually if profile is complete)
          allUsers = await server.api.getUsers();
        }

        // Filter out current user and ensure distinct results
        users.value = allUsers
            .where((u) => u['_id'].toString() != currentUserId.toString())
            .toList();
      } else {
        users.value = await server.api.getUsers();
      }
    } catch (e) {
      print("Error fetching matches: $e");
    } finally {
      isLoading(false);
    }
  }

  void applyFilters({
    int? minAge,
    int? maxAge,
    String? city,
    String? maritalStatus,
    String? education,
  }) async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString('user_id');

      Server server = Server();
      String? targetGender;
      if (currentUserId != null) {
        var currentUser = await server.api.getUser(currentUserId);
        String gender = currentUser['gender'] ??
            currentUser['basicDetails']?['gender'] ??
            "";
        targetGender = gender.toLowerCase() == 'male' ? 'female' : 'male';
      }

      var filtered = await server.api.getFilteredUsers(
        gender: targetGender,
        minAge: minAge,
        maxAge: maxAge,
        city: city,
        maritalStatus: maritalStatus,
        education: education,
      );
      users.value = filtered
          .where((u) => u['_id'].toString() != currentUserId.toString())
          .toList();
    } catch (e) {
      print("Filter error: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleShortlist(String targetId) async {
    try {
      Server server = Server();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) return;

      await server.api.toggleShortlist({
        "userId": userId,
        "shortlistedUserId": targetId,
      });
    } catch (e) {
      print("Shortlist error: $e");
    }
  }

  void sendInterestRequest(String targetId) async {
    try {
      Server server = Server();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) return;

      await server.api.sendInterest({
        "senderId": userId,
        "receiverId": targetId,
        "status": "pending",
      });
      Get.snackbar("Success", "Interest request sent successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Notice", "Interest already sent or error occurred",
          snackPosition: SnackPosition.BOTTOM);
      print("Interest error: $e");
    }
  }

  String getOnlineStatus(String? lastActiveIso) {
    if (lastActiveIso == null) return "Offline";
    try {
      if (!lastActiveIso.endsWith('Z')) lastActiveIso += 'Z';
      DateTime lastActive = DateTime.parse(lastActiveIso);
      Duration diff = DateTime.now().toUtc().difference(lastActive);

      if (diff.inMinutes < 5) return "Online";
      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "${diff.inHours}h ago";
      return "${diff.inDays}d ago";
    } catch (e) {
      return "Offline";
    }
  }
}

class RecommendedMatchesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecommendedMatchesController());
  }
}
