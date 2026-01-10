import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/module/recommended_matches/recommended_matches_binding.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/profile/profile_detail_screen.dart';
import 'package:app/module/profile/profile_detail_binding.dart';

class RecommendedMatchesScreen extends StatelessWidget {
  const RecommendedMatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendedMatchesController>(
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
            "Recommended Matches",
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Rubik-bold',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.theameColorRed));
          }
          if (controller.users.isEmpty) {
            return const Center(child: Text("No matches found"));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // Taller for profile cards
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              return _buildGridProfileCard(controller.users[index]);
            },
          );
        }),
      ),
    );
  }

  Widget _buildGridProfileCard(dynamic user) {
    String name = user['name'] ?? "${user['firstName']} ${user['lastName']}";
    String age = user['age']?.toString() ?? "N/A";
    String height = user['physicalAttributes']?['height'] ?? "N/A";
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  image: photoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(photoUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: photoUrl.isEmpty
                    ? Stack(
                        children: [
                          Center(
                            child: Icon(Icons.person,
                                size: 50, color: Colors.grey[400]),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: const Icon(CupertinoIcons.heart,
                                  size: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik-bold',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$age Yrs, $height",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      occupation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
