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
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Interests Received",
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
        ),
        body: controller.isLoading.value
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppColors.theameColorRed))
            : controller.receivedInterests.isEmpty
                ? const Center(child: Text("No interests received yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.receivedInterests.length,
                    itemBuilder: (context, index) {
                      return _buildInterestCard(
                          controller.receivedInterests[index]);
                    },
                  ),
      ),
    );
  }

  Widget _buildInterestCard(dynamic user) {
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
              Get.to(const ProfileDetailScreen(),
                  binding: ProfileDetailBinding(), arguments: user['_id']);
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
                Text("Received on: $date",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (user['interestStatus'] == 'pending') ...[
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
                          color: user['interestStatus'] == 'accepted'
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user['interestStatus'] == 'accepted'
                              ? "Accepted"
                              : "Declined",
                          style: TextStyle(
                            color: user['interestStatus'] == 'accepted'
                                ? Colors.green
                                : Colors.red,
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
}
