import 'package:app/core/Server.dart';
import 'package:app/module/chat/chat_binding.dart';
import 'package:app/module/chat/chat_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ChatListController extends GetxController {
  var conversations = <dynamic>[].obs;
  var filteredConversations = <dynamic>[].obs;
  var isLoading = true.obs;
  String? currentUserId;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  void fetchConversations() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      currentUserId = prefs.getString('user_id');
      if (currentUserId != null) {
        var list = await Server().api.getConversations(currentUserId!);
        conversations.value = list;
        filteredConversations.value = list;
      }
    } catch (e) {
      print("Error fetching conversations: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterConversations(String query) {
    if (query.isEmpty) {
      filteredConversations.value = conversations;
    } else {
      filteredConversations.value = conversations.where((item) {
        String name = item['partnerName'] ??
            "${item['partnerFirstName']} ${item['partnerLastName']}";
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<List<dynamic>> getAcceptedConnections() async {
    if (currentUserId == null) return [];
    try {
      return await Server().api.getAcceptedConnections(currentUserId!);
    } catch (e) {
      print("Error fetching accepted connections: $e");
      return [];
    }
  }

  void openChat(Map<String, dynamic> conversation) {
    Get.to(() => const ChatScreen(), binding: ChatBinding(), arguments: {
      "userId": conversation['partnerId'],
      "userName": conversation['partnerName'] ??
          "${conversation['partnerFirstName']} ${conversation['partnerLastName']}"
    });
  }
}
