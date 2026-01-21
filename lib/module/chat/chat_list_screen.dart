import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/chat/chat_list_controller.dart';
import 'package:app/module/chat/chat_screen.dart';
import 'package:app/module/chat/chat_binding.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const ChatListScreen({Key? key, this.onBack}) : super(key: key);

  String _formatTime(String? iso) {
    if (iso == null) return "";
    try {
      if (!iso.endsWith('Z')) iso += 'Z';
      DateTime dt = DateTime.parse(iso).toLocal();
      DateTime now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat('hh:mm a').format(dt);
      }
      return DateFormat('dd/MM/yy').format(dt);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatListController controller = Get.put(ChatListController());
    controller.fetchConversations();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik-bold',
          ),
        ),
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black87, size: 22),
                onPressed: onBack,
              )
            : null,
        actions: [
          IconButton(
            onPressed: () => _showNewChatDialog(context, controller),
            icon: const Icon(Icons.add, color: Colors.black87, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.filterConversations,
              decoration: InputDecoration(
                hintText: "Search conversations...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.theameColorRed));
              }

              if (controller.filteredConversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 60, color: Colors.grey[200]),
                      const SizedBox(height: 16),
                      Text("No conversations found",
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredConversations.length,
                separatorBuilder: (c, i) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  var item = controller.filteredConversations[index];
                  String name = item['partnerName'] ??
                      "${item['partnerFirstName']} ${item['partnerLastName']}";

                  return InkWell(
                    onTap: () => controller.openChat(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: item['partnerPhoto'] != null &&
                                    item['partnerPhoto'].isNotEmpty
                                ? NetworkImage(item['partnerPhoto'])
                                : null,
                            child: item['partnerPhoto'] == null ||
                                    item['partnerPhoto'].isEmpty
                                ? Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: 18))
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: 'Rubik'),
                                    ),
                                    Text(
                                      _formatTime(item['lastMessageTimestamp']),
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['lastMessageContent'] ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog(BuildContext context, ChatListController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: Get.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "New Conversation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rubik-bold',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: controller.getAcceptedConnections(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.theameColorRed));
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No accepted connections found.\nStart matching to chat!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      );
                    }

                    var users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        String name = user['firstName'] ?? "User";
                        String photo =
                            user['photos'] != null && user['photos'].isNotEmpty
                                ? user['photos'][0]['url']
                                : "";

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage:
                                photo.isNotEmpty ? NetworkImage(photo) : null,
                            child: photo.isEmpty
                                ? Text(name[0].toUpperCase())
                                : null,
                          ),
                          title: Text(name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            Get.back(); // Close sheet
                            Get.to(() => const ChatScreen(),
                                binding: ChatBinding(),
                                arguments: {
                                  "userId": user['_id'],
                                  "userName": name
                                });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
