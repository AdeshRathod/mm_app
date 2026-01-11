import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:app/core/SocketService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  final String targetUserId = Get.arguments['userId'];
  final String targetUserName = Get.arguments['userName'];

  var messages = <dynamic>[].obs;
  var isLoading = true.obs;
  var statusText = "".obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String? currentUserId;
  late final SocketService _socketService;

  @override
  void onInit() {
    super.onInit();
    _socketService = SocketService();
    _initChat();
  }

  void _initChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('user_id');

    if (currentUserId != null) {
      _socketService.connect(currentUserId!);
      fetchPartnerStatus();

      // Listen for incoming messages
      _socketService.messages.listen((msg) {
        if (msg['senderId'] == targetUserId ||
            msg['senderId'] == currentUserId) {
          messages.add(msg);
          _scrollToBottom();
        }
      });

      fetchHistory();
    }
  }

  void fetchHistory() async {
    try {
      isLoading(true);
      final history =
          await Server().api.getChatHistory(currentUserId!, targetUserId);
      messages.value = history;
      _scrollToBottom();
    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchPartnerStatus() async {
    try {
      var user = await Server().api.getUser(targetUserId);
      String? lastActiveIso = user['lastActive'];

      if (lastActiveIso == null) {
        statusText.value = "Offline";
        return;
      }

      try {
        DateTime lastActive = DateTime.parse(lastActiveIso);
        Duration diff = DateTime.now().toUtc().difference(lastActive.toUtc());

        if (diff.inMinutes < 5) {
          statusText.value = "Online";
        } else if (diff.inMinutes < 60) {
          statusText.value = "Active ${diff.inMinutes}m ago";
        } else if (diff.inHours < 24) {
          statusText.value = "Active ${diff.inHours}h ago";
        } else {
          statusText.value = "Active ${diff.inDays}d ago";
        }
      } catch (e) {
        statusText.value = "Offline";
      }
    } catch (e) {
      print("Error fetching status: $e");
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final msg = {
      "receiverId": targetUserId,
      "content": messageController.text.trim(),
      "type": "text"
    };

    _socketService.sendMessage(msg);
    messageController.clear();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}
