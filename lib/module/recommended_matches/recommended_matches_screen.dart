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
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back,
                color: Colors.black87, size: 22),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text(
            "Recommended Matches",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Rubik-bold',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.slider_horizontal_3,
                  color: Colors.black87, size: 20),
              onPressed: () => _showFilterBottomSheet(context, controller),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          if (controller.users.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              return _buildPremiumGridCard(controller.users[index], controller);
            },
          );
        }),
      ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, RecommendedMatchesController controller) {
    String? city;
    int? minAge;
    int? maxAge;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Filter Matches",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik-bold')),
              const SizedBox(height: 25),
              const Text("City",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              TextField(
                onChanged: (v) => city = v,
                decoration: const InputDecoration(hintText: "Enter city name"),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Min Age",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (v) => minAge = int.tryParse(v),
                          decoration:
                              const InputDecoration(hintText: "e.g. 18"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Max Age",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (v) => maxAge = int.tryParse(v),
                          decoration:
                              const InputDecoration(hintText: "e.g. 35"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters(
                        city: city, minAge: minAge, maxAge: maxAge);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.theameColorRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Apply Filters",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumGridCard(
      dynamic user, RecommendedMatchesController controller) {
    String name = user['name'] ??
        ((user['firstName'] != null || user['lastName'] != null)
            ? "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".trim()
            : "Unknown");
    String ageVal = user['age']?.toString() ?? "0";
    String age = (ageVal == "0" || ageVal == "N/A") ? "N/A" : ageVal;
    String city = user['basicDetails']?['city'] ?? "N/A";
    String photoUrl = "";
    if (user['photos'] != null &&
        (user['photos'] as List).isNotEmpty &&
        user['photos'][0]['url'] != null) {
      photoUrl = user['photos'][0]['url'];
    }

    String onlineStatus = controller.getOnlineStatus(user['lastActive']);

    return GestureDetector(
      onTap: () {
        Get.to(const ProfileDetailScreen(),
            binding: ProfileDetailBinding(), arguments: user['_id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: photoUrl.isNotEmpty
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => controller.toggleShortlist(user['_id']),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.heart,
                            size: 16, color: AppColors.theameColorRed),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: onlineStatus == "Online"
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.location_solid,
                            color: Colors.white, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          city,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik-bold',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.theameColorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "$age Yrs",
                          style: const TextStyle(
                            color: AppColors.theameColorRed,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          user['educationDetails']?['occupationType'] ?? "N/A",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                            fontFamily: 'Rubik-regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child:
            Icon(CupertinoIcons.person_alt, size: 40, color: Colors.grey[300]),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.theameColorRed,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(CupertinoIcons.person_2,
                size: 60, color: Colors.grey[300]),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Recommended Matches",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Check back later or try updating your profile preferences to find better matches.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
