import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/social/social_binding.dart';
import 'package:app/module/profile/profile_detail_screen.dart';
import 'package:app/module/profile/profile_detail_binding.dart';

class InterestsReceivedScreen extends StatelessWidget {
  const InterestsReceivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SocialController>(
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Colors.black87, size: 20),
            onPressed: () => Get.back(),
          ),
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Accept logic
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
                          // TODO: Decline logic
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Decline",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                    ),
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
