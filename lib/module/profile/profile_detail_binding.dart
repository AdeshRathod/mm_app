import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailController extends GetxController {
  var userData = {}.obs;
  var isLoading = false.obs;
  bool isShortlisted = false;
  bool isInterestSent = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      fetchUserProfile(Get.arguments);
    }
  }

  void fetchUserProfile(String userId) async {
    try {
      isLoading(true);
      Server server = Server();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString('user_id');

      if (currentUserId != null) {
        // Parallel fetch profile and social status
        final results = await Future.wait([
          server.api!.getUser(userId),
          server.api!.getSocialStatus(currentUserId, userId),
        ]);

        userData.value = results[0] as Map<String, dynamic>;
        var status = results[1] as Map<String, dynamic>;

        isShortlisted = status['isShortlisted'] ?? false;
        isInterestSent = status['interestStatus'] != null;
      } else {
        var user = await server.api!.getUser(userId);
        userData.value = user;
      }
      update();
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading(false);
    }
  }

  void _showSnackBar(String title, String message, {Color? backgroundColor}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("$title: $message",
              style: const TextStyle(color: Colors.white)),
          backgroundColor: backgroundColor ?? Colors.black,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void toggleShortlist() async {
    if (userData.isEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserId = prefs.getString('user_id');
    if (currentUserId == null) return;

    try {
      Server server = Server();
      var result = await server.api!.toggleShortlist(
          {"userId": currentUserId, "shortlistedUserId": userData['_id']});

      isShortlisted = result['status'] == 'added';
      _showSnackBar(
          "Success",
          result['status'] == 'added'
              ? "Added to shortlist"
              : "Removed from shortlist",
          backgroundColor: AppColors.theameColorRed);
      update();
    } catch (e) {
      _showSnackBar("Error", "Failed to update shortlist");
    }
  }

  void sendInterest() async {
    if (userData.isEmpty) return;
    if (isInterestSent) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserId = prefs.getString('user_id');
    if (currentUserId == null) return;

    try {
      Server server = Server();
      await server.api!.sendInterest({
        "senderId": currentUserId,
        "receiverId": userData['_id'],
        "status": "pending",
        "date": "" // Backend handles date
      });

      isInterestSent = true;
      _showSnackBar("Success", "Interest sent successfully!",
          backgroundColor: Colors.green);
      update();
    } catch (e) {
      _showSnackBar("Error", "Failed to send interest or already sent");
    }
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
