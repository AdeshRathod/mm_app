import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/search/search_binding.dart';
import 'package:app/module/profile/profile_detail_screen.dart';
import 'package:app/module/profile/profile_detail_binding.dart';

class SearchScreen extends GetView<SearchProfileController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.theameColorRed,
                      strokeWidth: 2,
                    ),
                  );
                }

                if (controller.searchResults.isEmpty &&
                    controller.searchController.text.isNotEmpty) {
                  return _buildNoResults();
                }

                if (controller.searchResults.isEmpty) {
                  return _buildRecentSearches();
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    return _buildModernResultCard(
                        controller.searchResults[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik-bold',
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Find your perfect partner",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Rubik-regular',
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.bell,
                      color: Colors.black54, size: 22),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.performSearch,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Search by Name, Caste...",
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: const Icon(CupertinoIcons.search,
                          color: AppColors.theameColorRed, size: 22),
                      suffixIcon:
                          Obx(() => controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      size: 18, color: Colors.grey),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.performSearch("");
                                  },
                                )
                              : const SizedBox.shrink()),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showFilterBottomSheet(context),
                child: Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.theameColorRed, Color(0xFFFF5252)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.theameColorRed.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: const Icon(CupertinoIcons.slider_horizontal_3,
                      color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
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
              const Text("Filter Profiles",
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

  Widget _buildModernResultCard(dynamic user) {
    String name = user['name'] ??
        ((user['firstName'] != null || user['lastName'] != null)
            ? "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".trim()
            : "Unknown");
    String age = user['age']?.toString() ?? "N/A";
    String city = user['basicDetails']?['city'] ?? "N/A";
    String bio = user['aboutMe'] ??
        "Looking for a soulmate who shares similar values and life goals.";
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
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: photoUrl.isNotEmpty
                      ? Image.network(
                          photoUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildCardPlaceholder(),
                        )
                      : _buildCardPlaceholder(),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () => controller.toggleShortlist(user['_id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.heart,
                            size: 20, color: AppColors.theameColorRed),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: onlineStatus == "Online"
                          ? Colors.green.withOpacity(0.9)
                          : Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          onlineStatus,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.location_solid,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          city,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubik-bold',
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.theameColorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          age == "0" || age == "N/A" ? "Age N/A" : "$age Yrs",
                          style: const TextStyle(
                              color: AppColors.theameColorRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Rubik-regular',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              controller.sendInterestRequest(user['_id']),
                          icon: const Icon(CupertinoIcons.paperplane, size: 18),
                          label: const Text("Connect"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.theameColorRed,
                            side: const BorderSide(
                                color: AppColors.theameColorRed),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const ProfileDetailScreen(),
                                binding: ProfileDetailBinding(),
                                arguments: user['_id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.theameColorRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("View Details"),
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

  Widget _buildCardPlaceholder() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey[100],
      child: Center(
        child: Icon(Icons.person, size: 80, color: Colors.grey[300]),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(CupertinoIcons.sparkles,
                size: 60, color: Colors.blue.withOpacity(0.3)),
          ),
          const SizedBox(height: 25),
          const Text(
            "Start exploring",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rubik-bold',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Browse all profiles or use the search bar to find someone specific.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 15,
                height: 1.5,
                fontFamily: 'Rubik-regular'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.theameColorRed.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(CupertinoIcons.search_circle,
                size: 60, color: AppColors.theameColorRed.withOpacity(0.3)),
          ),
          const SizedBox(height: 25),
          const Text(
            "No results found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rubik-bold',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We couldn't find anyone matching your search. Try different keywords or check out the full list.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 15,
                height: 1.5,
                fontFamily: 'Rubik-regular'),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                controller.searchController.clear();
                controller.performSearch("");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.theameColorRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text("Clear Search",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
