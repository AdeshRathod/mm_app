import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProfileController extends GetxController {
  var searchResults = <dynamic>[].obs;
  var allUsersCache = <dynamic>[];
  var isLoading = false.obs;
  var searchQuery = "".obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  void fetchAllUsers() async {
    try {
      isLoading(true);
      Server server = Server();
      var users = await server.api.getUsers();
      allUsersCache = users;
      searchResults.value = users;
    } catch (e) {
      print("Error fetching initial users: $e");
    } finally {
      isLoading(false);
    }
  }

  void performSearch(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.value = allUsersCache;
      return;
    }

    // Filter from cache for instant results
    searchResults.value = allUsersCache.where((u) {
      String name =
          (u['name'] ?? "${u['firstName'] ?? ''} ${u['lastName'] ?? ''}")
              .toString()
              .toLowerCase();
      String search = query.toLowerCase();
      return name.contains(search);
    }).toList();
  }

  void applyFilters({
    int? minAge,
    int? maxAge,
    String? city,
    String? maritalStatus,
    String? caste,
    String? education,
  }) async {
    try {
      isLoading(true);
      Server server = Server();
      var filtered = await server.api.getFilteredUsers(
        minAge: minAge,
        maxAge: maxAge,
        city: city,
        maritalStatus: maritalStatus,
        caste: caste,
        education: education,
      );
      searchResults.value = filtered;
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
      DateTime lastActive = DateTime.parse(lastActiveIso);
      Duration diff = DateTime.now().toUtc().difference(lastActive.toUtc());

      if (diff.inMinutes < 5) return "Online";
      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "${diff.inHours}h ago";
      return "${diff.inDays}d ago";
    } catch (e) {
      return "Offline";
    }
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchProfileController());
  }
}
