import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/social/social_binding.dart';
import 'package:app/module/profile/profile_detail_screen.dart';
import 'package:app/module/profile/profile_detail_binding.dart';
import 'package:app/module/chat/chat_list_screen.dart';

class InterestsReceivedScreen extends StatefulWidget {
  const InterestsReceivedScreen({Key? key}) : super(key: key);

  @override
  _InterestsReceivedScreenState createState() =>
      _InterestsReceivedScreenState();
}

class _InterestsReceivedScreenState extends State<InterestsReceivedScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        _RequestsBody(onChatPressed: () {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }),
        ChatListScreen(onBack: () {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }),
      ],
    );
  }
}

class _RequestsBody extends StatelessWidget {
  final VoidCallback onChatPressed;
  const _RequestsBody({required this.onChatPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SocialController>(
      builder: (controller) => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Interests",
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'Rubik-bold',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                onPressed: onChatPressed,
                icon: const Icon(CupertinoIcons.chat_bubble_text,
                    color: Colors.black87, size: 30),
              ),
              const SizedBox(width: 8),
            ],
            bottom: const TabBar(
              labelColor: AppColors.theameColorRed,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.theameColorRed,
              tabs: [
                Tab(text: "Received"),
                Tab(text: "Sent"),
              ],
            ),
          ),
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.theameColorRed))
              : TabBarView(
                  children: [
                    _buildList(controller.receivedInterests, false),
                    _buildList(controller.sentInterests, true),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, bool isSent) {
    if (items.isEmpty) {
      return Center(
          child: Text(isSent ? "No interests sent" : "No interests received"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildInterestCard(items[index], isSent);
      },
    );
  }

  Widget _buildInterestCard(dynamic user, bool isSent) {
    String name = user['name'] ?? "${user['firstName']} ${user['lastName']}";
    String date = user['interestDate']?.split('T')[0] ?? "N/A";
    String photoUrl = (user['photos'] != null && user['photos'].isNotEmpty)
        ? user['photos'][0]['url']
        : "";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (user['_id'] != null) {
                Get.to(() => const ProfileDetailScreen(),
                    binding: ProfileDetailBinding(), arguments: user['_id']);
              }
            },
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
              child: photoUrl.isEmpty
                  ? const Icon(Icons.person, size: 35, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubik-bold',
                  ),
                ),
                const SizedBox(height: 4),
                Text((isSent ? "Sent on: " : "Received on: ") + date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (!isSent && user['interestStatus'] == 'pending') ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (user['interestId'] != null) {
                              Get.find<SocialController>()
                                  .acceptInterest(user['interestId']);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Accept",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (user['interestId'] != null) {
                              Get.find<SocialController>()
                                  .declineInterest(user['interestId']);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Decline",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(user['interestStatus']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(user['interestStatus']),
                          style: TextStyle(
                            color: _getStatusTextColor(user['interestStatus']),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == 'accepted') return Colors.green[50]!;
    if (status == 'declined') return Colors.red[50]!;
    return Colors.orange[50]!;
  }

  Color _getStatusTextColor(String? status) {
    if (status == 'accepted') return Colors.green;
    if (status == 'declined') return Colors.red;
    return Colors.orange;
  }

  String _getStatusText(String? status) {
    if (status == 'accepted') return "Accepted";
    if (status == 'declined') return "Declined";
    return "Pending";
  }
}
