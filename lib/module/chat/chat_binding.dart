import 'dart:async';
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

  var isPartnerTyping = false.obs;
  Timer? _typingTimer;
  bool _isSelfTyping = false;

  @override
  void onInit() {
    super.onInit();
    _socketService = SocketService();
    messageController.addListener(onTyping);
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
        String type = msg['type'] ?? 'text';

        if (type == 'typing') {
          if (msg['senderId'] == targetUserId) {
            isPartnerTyping.value = msg['isTyping'] ?? false;
            // Update status text temporarily if typing
            if (isPartnerTyping.value) {
              statusText.value = "Typing...";
            } else {
              fetchPartnerStatus(); // Revert to online/last active
            }
          }
        } else if (type == 'status_update') {
          int index = messages.indexWhere((m) => m['_id'] == msg['messageId']);
          if (index != -1) {
            var m = messages[index];
            m['status'] = msg['status'];
            m['isRead'] = (msg['status'] == 'read');
            messages[index] = m;
            messages.refresh();
          }
        } else if (msg['senderId'] == targetUserId ||
            msg['senderId'] == currentUserId) {
          int index = messages.indexWhere((m) => m['_id'] == msg['_id']);
          if (index == -1) {
            messages.add(msg);
          } else {
            messages[index] = msg;
            messages.refresh();
          }
          _scrollToBottom();

          // Mark as read if from partner
          if (msg['senderId'] == targetUserId) {
            _markAsRead(msg['_id']);
          }
        }
      });

      fetchHistory();
    }
  }

  void _markAsRead(String messageId) {
    _socketService.sendMessage({
      "type": "status_update",
      "messageId": messageId,
      "status": "read",
      "receiverId": targetUserId
    });
  }

  void onTyping() {
    if (messageController.text.trim().isEmpty) return;

    if (!_isSelfTyping) {
      _isSelfTyping = true;
      _sendTypingStatus(true);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _isSelfTyping = false;
      _sendTypingStatus(false);
    });
  }

  void _sendTypingStatus(bool isTyping) {
    _socketService.sendMessage(
        {"type": "typing", "receiverId": targetUserId, "isTyping": isTyping});
  }

  void fetchHistory() async {
    try {
      isLoading(true);
      final history =
          await Server().api.getChatHistory(currentUserId!, targetUserId);
      messages.value = history;
      _scrollToBottom();

      // Mark all unread from partner as read
      for (var msg in history) {
        if (msg['senderId'] == targetUserId && !(msg['isRead'] ?? false)) {
          _markAsRead(msg['_id']);
        }
      }
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
        // Fix: Python sends UTC isoformat without 'Z'.
        // Appending 'Z' tells Dart to treat it as UTC.
        if (!lastActiveIso.endsWith('Z')) {
          lastActiveIso += 'Z';
        }
        DateTime lastActive = DateTime.parse(lastActiveIso);
        Duration diff = DateTime.now().toUtc().difference(lastActive);

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
