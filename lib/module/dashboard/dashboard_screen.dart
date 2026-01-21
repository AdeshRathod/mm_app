import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/module/dashboard/dashboard_binding.dart';
// import 'package:app/module/dashboard/widgets/dashboard_card.dart'; // Unused in new design
// import 'package:app/module/dashboard/widgets/profile_card.dart'; // Unused in new design
import '../recommended_matches/recommended_matches_screen.dart';
import '../recommended_matches/recommended_matches_binding.dart';
import '../profile/profile_detail_screen.dart';
import '../profile/profile_detail_binding.dart';
import '../social/social_binding.dart';
import '../social/shortlisted_profiles_screen.dart';
import '../social/interests_received_screen.dart';
import '../notification/notification_screen.dart';
import '../notification/notification_binding.dart';
import '../main/bottom_nav_controller.dart';
import 'package:app/module/login/login_screen.dart';
import 'package:app/module/login/login_binding.dart';

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
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.theameColorRed))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModernHeader(context, controller),
                      const SizedBox(height: 40),
                      _buildBannerCarousel(controller),
                      // const SizedBox(height: 10),
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
          onError: (exception, stackTrace) {
            debugPrint("Banner Image Error: $exception");
          },
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
    bool isGuest = controller.userData.isEmpty;
    String firstName = controller.userData['firstName'] ?? "";
    String lastName = controller.userData['lastName'] ?? "";
    String fullName = (firstName.isNotEmpty || lastName.isNotEmpty)
        ? "$firstName $lastName".trim()
        : controller.userData['name'] ?? "User";

    if (isGuest) {
      fullName = "Guest Access";
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB71C1C), Color(0xFFD32F2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!isGuest) {
                          Get.to(() => const ProfileDetailScreen(),
                              binding: ProfileDetailBinding());
                        } else {
                          Get.offAll(() => const LoginScreen(),
                              binding: LoginBinding());
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: const Icon(CupertinoIcons.person_fill,
                                  color: Colors.white, size: 35),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isGuest ? "Welcome," : "Welcome back,",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isGuest)
                      ElevatedButton(
                        onPressed: () {
                          Get.offAll(() => const LoginScreen(),
                              binding: LoginBinding());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFB71C1C),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("LOGIN"),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const NotificationScreen(),
                            binding: NotificationBinding(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.bell,
                              color: Colors.white, size: 22),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -28,
          left: 20,
          right: 20,
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (Get.find<DashboardController>().userData.isEmpty) {
                    Get.defaultDialog(
                      title: "Login Required",
                      middleText: "Please login to search for soulmates.",
                      textConfirm: "Login",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back();
                        Get.offAll(() => const LoginScreen(),
                            binding: LoginBinding());
                      },
                      textCancel: "Cancel",
                    );
                  } else {
                    Get.find<BottomNavController>().changeIndex(1);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.search,
                          color: Color(0xFFB71C1C), size: 24),
                      const SizedBox(width: 15),
                      Text(
                        "Find your soulmate here.",
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardController controller) {
    if (controller.userData.isEmpty) return const SizedBox.shrink();

    final statsData = controller.userStats;

    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Matches',
        'count': statsData['matches']?.toString() ?? '0',
        'icon': CupertinoIcons.person_2_fill,
        'color': const Color(0xFF42A5F5),
        'bg': const Color(0xFFE3F2FD)
      },
      {
        'title': 'Interests',
        'count': statsData['interests']?.toString() ?? '0',
        'icon': CupertinoIcons.heart_fill,
        'color': const Color(0xFFB71C1C),
        'bg': const Color(0xFFFFEBEE)
      },
      {
        'title': 'Shortlisted',
        'count': statsData['shortlisted']?.toString() ?? '0',
        'icon': CupertinoIcons.star_fill,
        'color': const Color(0xFFFFA000),
        'bg': const Color(0xFFFFF8E1)
      },
      {
        'title': 'Visitors',
        'count': statsData['visitors']?.toString() ?? '0',
        'icon': CupertinoIcons.eye_fill,
        'color': const Color(0xFF66BB6A),
        'bg': const Color(0xFFE8F5E9)
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
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
                  break;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: stats[index]['bg'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(stats[index]['icon'],
                        color: stats[index]['color'], size: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    stats[index]['count'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    stats[index]['title'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Roboto',
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
              fontFamily: 'Roboto',
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "View All",
                style: TextStyle(
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
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
    String name = user['name'] ??
        ((user['firstName'] != null || user['lastName'] != null)
            ? "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".trim()
            : "Unknown");
    String ageVal = user['age']?.toString() ?? "0";
    String age = (ageVal == "0" || ageVal == "N/A") ? "Age N/A" : "$ageVal Yrs";
    String height = user['physicalAttributes']?['height'] ?? "N/A";
    String occupation = user['educationDetails']?['occupationType'] ?? "N/A";
    String photoUrl = "";
    if (user['photos'] != null &&
        (user['photos'] as List).isNotEmpty &&
        user['photos'][0]['url'] != null) {
      photoUrl = user['photos'][0]['url'];
    }

    return GestureDetector(
        onTap: () {
          if (Get.find<DashboardController>().userData.isEmpty) {
            Get.defaultDialog(
              title: "Login Required",
              middleText: "Please login to view profile details.",
              textConfirm: "Login",
              confirmTextColor: Colors.white,
              onConfirm: () {
                Get.back();
                Get.offAll(() => const LoginScreen(), binding: LoginBinding());
              },
              textCancel: "Cancel",
            );
          } else {
            Get.to(const ProfileDetailScreen(),
                binding: ProfileDetailBinding(), arguments: user['_id']);
          }
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
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                            onError: (e, s) =>
                                debugPrint("Profile Image Error"),
                          )
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
