import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/social/social_binding.dart';
import 'package:app/module/profile/profile_detail_screen.dart';
import 'package:app/module/profile/profile_detail_binding.dart';

class ShortlistedProfilesScreen extends StatelessWidget {
  const ShortlistedProfilesScreen({Key? key}) : super(key: key);

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
            "Shortlisted Profiles",
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
            : controller.shortlistedUsers.isEmpty
                ? const Center(child: Text("No shortlisted profiles yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.shortlistedUsers.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(controller.shortlistedUsers[index]);
                    },
                  ),
      ),
    );
  }

  Widget _buildUserCard(dynamic user) {
    String name = user['name'] ?? "${user['firstName']} ${user['lastName']}";
    String age = user['age']?.toString() ?? "N/A";
    String city = user['basicDetails']?['city'] ?? "N/A";
    String occupation = user['educationDetails']?['occupationType'] ?? "N/A";
    String photoUrl = (user['photos'] != null && user['photos'].isNotEmpty)
        ? user['photos'][0]['url']
        : "";

    return GestureDetector(
      onTap: () {
        Get.to(const ProfileDetailScreen(),
            binding: ProfileDetailBinding(), arguments: user['_id']);
      },
      child: Container(
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
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
              child: photoUrl.isEmpty
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
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
                  Text("$age Yrs • $city",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(occupation,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
