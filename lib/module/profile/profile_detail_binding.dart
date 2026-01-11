import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/module/chat/chat_screen.dart';
import 'package:app/module/chat/chat_binding.dart';

class ProfileDetailController extends GetxController {
  var userData = {}.obs;
  var isLoading = false.obs;
  bool isShortlisted = false;
  bool isInterestSent = false;
  bool isOwnProfile = false;
  var interestStatus = "".obs;
  String? interestId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      fetchUserProfile(Get.arguments);
    } else {
      _fetchOwnProfile();
    }
  }

  void _fetchOwnProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId != null) {
      fetchUserProfile(userId);
    }
  }

  void fetchUserProfile(String userId) async {
    try {
      isLoading(true);
      Server server = Server();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString('user_id');

      if (currentUserId != null) {
        isOwnProfile = (userId == currentUserId);
        // Parallel fetch profile and social status
        final results = await Future.wait([
          server.api.getUser(userId),
          isOwnProfile
              ? Future.value({"isShortlisted": false})
              : server.api.getSocialStatus(currentUserId, userId),
        ]);

        userData.value = results[0] as Map<String, dynamic>;
        var status = results[1] as Map<String, dynamic>;

        isShortlisted = status['isShortlisted'] ?? false;
        isInterestSent = status['interestStatus'] != null;
        String dir = status['direction'] ?? "";
        String s = status['interestStatus']?['status'] ?? "";

        if (dir == "sent") {
          interestStatus.value = s == "pending" ? "sent_pending" : "accepted";
        } else if (dir == "received") {
          interestStatus.value =
              s == "pending" ? "received_pending" : "accepted";
        } else {
          interestStatus.value = "";
        }

        interestId = status['interestStatus']?['_id'];
      } else {
        var user = await server.api.getUser(userId);
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
      var result = await server.api.toggleShortlist(
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
      await server.api.sendInterest({
        "senderId": currentUserId,
        "receiverId": userData['_id'],
        "status": "pending",
        "date": ""
      });

      isInterestSent = true;
      interestStatus.value = "pending";
      _showSnackBar("Success", "Interest sent successfully!",
          backgroundColor: Colors.green);
      update();
    } catch (e) {
      _showSnackBar("Error", "Failed to send interest or already sent");
    }
  }

  void acceptInterest() async {
    if (interestId == null) return;
    try {
      await Server().api.acceptInterest(interestId!);
      interestStatus.value = "accepted";
      _showSnackBar("Success", "Interest accepted!",
          backgroundColor: Colors.green);
      update();
    } catch (e) {
      _showSnackBar("Error", "Failed to accept interest");
    }
  }

  void initiateCall() {
    // Implement call logic
    print("Initiate Call");
  }

  void initiateChat() {
    if (userData.isEmpty) return;

    // Check if interest is accepted
    if (interestStatus.value != "accepted" && !isOwnProfile) {
      _showSnackBar(
          "Notification", "You can only chat after your interest is accepted.");
      return;
    }

    String firstName = userData['firstName'] ?? "";
    String lastName = userData['lastName'] ?? "";
    String fullName = (firstName.isNotEmpty || lastName.isNotEmpty)
        ? "$firstName $lastName"
        : userData['name'] ?? "User";

    Get.to(() => const ChatScreen(),
        binding: ChatBinding(),
        arguments: {"userId": userData['_id'], "userName": fullName});
  }

  String getOnlineStatus(String? lastActiveIso) {
    if (lastActiveIso == null) return "Offline";
    try {
      DateTime lastActive = DateTime.parse(lastActiveIso);
      Duration diff = DateTime.now().toUtc().difference(lastActive.toUtc());

      if (diff.inMinutes < 5) return "Online";
      if (diff.inMinutes < 60) return "Active ${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "Active ${diff.inHours}h ago";
      return "Active ${diff.inDays}d ago";
    } catch (e) {
      return "Offline";
    }
  }
}

class ProfileDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileDetailController());
  }
}
