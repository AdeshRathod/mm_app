import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/module/dashboard/dashboard_binding.dart';
// import 'package:app/module/dashboard/widgets/dashboard_card.dart'; // Unused in new design
// import 'package:app/module/dashboard/widgets/profile_card.dart'; // Unused in new design
import '../search/search_binding.dart';
import '../search/search_screen.dart';
import '../recommended_matches/recommended_matches_screen.dart';
import '../recommended_matches/recommended_matches_binding.dart';
import '../profile/profile_detail_screen.dart';
import '../profile/profile_detail_binding.dart';
import '../social/social_binding.dart';
import '../social/shortlisted_profiles_screen.dart';
import '../social/interests_received_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // Light grey background
        body: SafeArea(
          top: false,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.theameColorRed));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModernHeader(context, controller),
                  const SizedBox(height: 20),
                  _buildBannerCarousel(controller),
                  const SizedBox(height: 30),
                  _buildStatsGrid(controller),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Recommended Matches", () {
                    Get.to(const RecommendedMatchesScreen(),
                        binding: RecommendedMatchesBinding());
                  }),
                  _buildProfileList(controller.recommendedUsers),
                  const SizedBox(height: 20),
                  _buildSectionHeader("New Profiles", () {}),
                  _buildProfileList(controller.newUsers),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: BottomNavigationBar(
            onTap: controller.onBottomBarItemTap,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: controller.selectedIndex,
            iconSize: 18.0,
            selectedIconTheme: const IconThemeData(size: 18.0),
            unselectedIconTheme: const IconThemeData(size: 18.0),
            selectedFontSize: 11.0,
            unselectedFontSize: 11.0,
            selectedItemColor: AppColors.theameColorRed,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart), label: 'Matches'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.gear), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(DashboardController controller) {
    if (controller.banners.isEmpty) {
      // Mock banners if none from API
      return CarouselSlider(
        options: CarouselOptions(
          height: 150.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.85,
        ),
        items: [
          _buildBannerItem(
              "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2069&auto=format&fit=crop"),
          _buildBannerItem(
              "https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?q=80&w=2070&auto=format&fit=crop"),
        ],
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.85,
      ),
      items: controller.banners.map((banner) {
        return _buildBannerItem(banner['imageUrl']);
      }).toList(),
    );
  }

  Widget _buildBannerItem(String imageUrl) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(
      BuildContext context, DashboardController controller) {
    String name = controller.userData['firstName'] ?? "User";
    String profileId =
        controller.userData['id']?.toString().substring(0, 8) ?? "MM123456";

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height:
              180, // Reduced height since membership strip is moved to settings
          decoration: const BoxDecoration(
            color: AppColors.theameColorRed,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Profile Image with Camera Icon
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.person,
                                    color: Colors.white, size: 30),
                                // backgroundImage: NetworkImage("URL"), // Add image here later
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // Open gallery/camera option
                                  print("Open Camera/Gallery");
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 10,
                                    color: AppColors.theameColorRed,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18, // Smaller size
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rubik-bold',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "ID: $profileId",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'Rubik-normal',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(CupertinoIcons.bell, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        // Search Bar overlap
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: TextField(
              readOnly: true,
              onTap: () {
                Get.to(const SearchScreen(), binding: SearchBinding());
              },
              decoration: const InputDecoration(
                hintText: "Search by ID, Name or Caste...",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(CupertinoIcons.search,
                    color: AppColors.theameColorRed),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardController controller) {
    // A clean grid of stats (Matches, Interests, etc.)
    final statsData = controller.userStats;

    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Matches',
        'count': statsData['matches']?.toString() ?? '0',
        'icon': CupertinoIcons.person_2_fill,
        'color': Colors.blueAccent
      },
      {
        'title': 'Interests',
        'count': statsData['interests']?.toString() ?? '0',
        'icon': CupertinoIcons.heart_fill,
        'color': AppColors.theameColorRed
      },
      {
        'title': 'Shortlisted',
        'count': statsData['shortlisted']?.toString() ?? '0',
        'icon': CupertinoIcons.star_fill,
        'color': Colors.orangeAccent
      },
      {
        'title': 'Visitors',
        'count': statsData['visitors']?.toString() ?? '0',
        'icon': CupertinoIcons.eye_fill,
        'color': Colors.green
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.6, // Wider format
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Get.to(const RecommendedMatchesScreen(),
                      binding: RecommendedMatchesBinding());
                  break;
                case 1:
                  Get.to(const InterestsReceivedScreen(),
                      binding: SocialBinding());
                  break;
                case 2:
                  Get.to(const ShortlistedProfilesScreen(),
                      binding: SocialBinding());
                  break;
                case 3:
                  // Visitors - maybe just refresh or toast
                  break;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(stats[index]['icon'],
                      color: stats[index]['color'], size: 28),
                  const SizedBox(height: 8),
                  Text(
                    stats[index]['count'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik-bold',
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    stats[index]['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: 'Rubik-normal',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rubik-bold',
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              "See All",
              style: TextStyle(
                color: AppColors.theameColorRed,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileList(List<dynamic> users) {
    if (users.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No profiles found")),
      );
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16),
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _buildPremiumProfileCard(users[index]);
        },
      ),
    );
  }

  Widget _buildPremiumProfileCard(dynamic user) {
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
          width: 170,
          margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
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
              // Image placeholder - 60% of card height
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
        ));
  }
}
