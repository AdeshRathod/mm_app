import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/profile/profile_detail_binding.dart';
import 'package:app/module/profile/complete_profile_screen.dart';
import 'package:app/module/profile/complete_profile_binding.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileDetailController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Scaffold(
            body: Center(
                child:
                    CircularProgressIndicator(color: AppColors.theameColorRed)),
          );
        }

        var user = controller.userData;
        if (user.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Profile not found")),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, controller),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildBasicInfoSection(user),
                        const SizedBox(height: 20),
                        _buildActionButtons(controller),
                        const SizedBox(height: 25),
                        const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                        const SizedBox(height: 20),
                        _buildSectionTitle("Physical Attributes"),
                        _buildPhysicalAttributes(user),
                        const Divider(),
                        _buildSectionTitle("Education & Career"),
                        _buildEducationCareer(user),
                        const Divider(),
                        _buildSectionTitle("Family Background"),
                        _buildFamilyBackground(user),
                        const Divider(),
                        _buildSectionTitle("Horoscope Details"),
                        _buildHoroscopeDetails(user),
                        const Divider(),
                        _buildSectionTitle("Lifestyle & Hobbies"),
                        _buildLifestyle(user),
                        const SizedBox(height: 80), // Space for bottom bar
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          bottomNavigationBar:
              controller.isOwnProfile ? null : _buildBottomAction(controller),
        );
      },
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, ProfileDetailController controller) {
    var user = controller.userData;
    String name = user['name'] ?? "${user['firstName']} ${user['lastName']}";
    String photoUrl = (user['photos'] != null && user['photos'].isNotEmpty)
        ? user['photos'][0]['url']
        : "";

    return SliverAppBar(
      expandedHeight: 400.0,
      pinned: true,
      backgroundColor: AppColors.theameColorRed,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Profile Image
            Container(
              color: Colors.grey[300],
              child: photoUrl.isNotEmpty
                  ? Image.network(photoUrl, fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik-bold',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: controller
                                        .getOnlineStatus(user['lastActive']) ==
                                    "Online"
                                ? Colors.greenAccent
                                : Colors.grey,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.getOnlineStatus(user['lastActive']),
                        style: TextStyle(
                            color: controller
                                        .getOnlineStatus(user['lastActive']) ==
                                    "Online"
                                ? Colors.greenAccent
                                : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        if (controller.isOwnProfile)
          IconButton(
            icon: const Icon(CupertinoIcons.pencil, color: Colors.white),
            onPressed: () {
              Get.to(() => const CompleteProfileScreen(),
                  binding: CompleteProfileBinding());
            },
          ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(Map<dynamic, dynamic> user) {
    String age = user['age']?.toString() ?? "N/A";
    String birthdate = user['birthdate'] ?? "N/A";
    String maritalStatus = user['basicDetails']?['maritalStatus'] ?? "N/A";
    String city = user['basicDetails']?['city'] ?? "N/A";

    return Column(
      children: [
        _buildInfoRow(Icons.calendar_today, "$birthdate ($age Yrs)"),
        _buildInfoRow(CupertinoIcons.person_3_fill, maritalStatus),
        _buildInfoRow(Icons.temple_hindu, "Hindu, Maratha"),
        _buildInfoRow(Icons.location_on, city),
        _buildInfoRow(Icons.language, "Mother Tongue: Marathi"),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 18),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontFamily: 'Rubik-normal')),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ProfileDetailController controller) {
    if (controller.isOwnProfile) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: controller.toggleShortlist,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isShortlisted
                      ? Colors.orange[100]
                      : Colors.grey[100],
                ),
                child: Icon(
                  controller.isShortlisted ? Icons.star : Icons.star_border,
                  color: controller.isShortlisted
                      ? Colors.orange
                      : Colors.grey[700],
                  size: 26,
                ),
              ),
              const SizedBox(height: 5),
              Text(controller.isShortlisted ? "Shortlisted" : "Shortlist",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Obx(() {
          String status = controller.interestStatus.value;
          bool isAccepted = status == "accepted";
          bool isReceivedPending = status == "received_pending";
          bool isSentPending = status == "sent_pending";

          return GestureDetector(
            onTap: () {
              if (isAccepted) {
                controller.initiateChat();
              } else if (isReceivedPending) {
                controller.acceptInterest();
              } else if (!isSentPending) {
                controller.sendInterest();
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAccepted
                        ? Colors.green[100]
                        : (isSentPending || isReceivedPending)
                            ? Colors.pink[100]
                            : Colors.grey[100],
                  ),
                  child: Icon(
                    isAccepted
                        ? CupertinoIcons.chat_bubble_fill
                        : (isSentPending || isReceivedPending)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                    color: isAccepted
                        ? Colors.green
                        : (isSentPending || isReceivedPending)
                            ? AppColors.theameColorRed
                            : Colors.grey[700],
                    size: 26,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isAccepted
                      ? "Message"
                      : isReceivedPending
                          ? "Accept"
                          : isSentPending
                              ? "Pending"
                              : "Interest",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.theameColorRed,
            fontFamily: 'Rubik-bold',
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontFamily: 'Rubik-normal'),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik-normal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalAttributes(Map<dynamic, dynamic> user) {
    var phys = user['physicalAttributes'] ?? {};
    return Column(
      children: [
        _buildGridItem("Height", phys['height'] ?? "N/A"),
        _buildGridItem("Weight", phys['weight'] ?? "N/A"),
        _buildGridItem("Blood Group", phys['bloodGroup'] ?? "N/A"),
        _buildGridItem("Complexion", phys['complexion'] ?? "N/A"),
        _buildGridItem("Personality", phys['personality'] ?? "N/A"),
        _buildGridItem("Physical Status",
            phys['physicalDisabilities'] == true ? "Disability" : "Normal"),
      ],
    );
  }

  Widget _buildEducationCareer(Map<dynamic, dynamic> user) {
    var edu = user['educationDetails'] ?? {};
    return Column(
      children: [
        _buildGridItem("Education", edu['education'] ?? "N/A"),
        _buildGridItem("Occupation", edu['occupationType'] ?? "N/A"),
        _buildGridItem("Income", edu['incomePerMonth'] ?? "N/A"),
        _buildGridItem("Area", edu['educationArea'] ?? "N/A"),
      ],
    );
  }

  Widget _buildFamilyBackground(Map<dynamic, dynamic> user) {
    var fam = user['familyBackground'] ?? {};
    return Column(
      children: [
        _buildGridItem("Father Alive", fam['father'] ?? "N/A"),
        _buildGridItem("Mother Alive", fam['mother'] ?? "N/A"),
        _buildGridItem("Brothers", fam['brotherCount']?.toString() ?? "0"),
        _buildGridItem("Sisters", fam['sisterCount']?.toString() ?? "0"),
        _buildGridItem("City", fam['city'] ?? "N/A"),
        _buildGridItem("Family Wealth", fam['familyWealth'] ?? "N/A"),
      ],
    );
  }

  Widget _buildHoroscopeDetails(Map<dynamic, dynamic> user) {
    var hero = user['horoscopeDetails'] ?? {};
    return Column(
      children: [
        _buildGridItem("Rashi", hero['rashi'] ?? "N/A"),
        _buildGridItem("Nakshatra", hero['nakshatra'] ?? "N/A"),
        _buildGridItem("Mangal", hero['mangal'] ?? "N/A"),
        _buildGridItem("Nadi", hero['nadi'] ?? "N/A"),
        _buildGridItem("Gan", hero['gan'] ?? "N/A"),
        _buildGridItem("Charan", hero['charan'] ?? "N/A"),
      ],
    );
  }

  Widget _buildLifestyle(Map<dynamic, dynamic> user) {
    var phys = user['physicalAttributes'] ?? {};
    return Column(
      children: [
        _buildGridItem("Diet", phys['diet'] ?? "N/A"),
        _buildGridItem("Drink", phys['drink'] == true ? "Yes" : "No"),
        _buildGridItem("Smoke", phys['smoke'] == true ? "Yes" : "No"),
        _buildGridItem("Personality", phys['personality'] ?? "N/A"),
      ],
    );
  }

  Widget _buildBottomAction(ProfileDetailController controller) {
    return Obx(() {
      String status = controller.interestStatus.value;
      bool isAccepted = status == "accepted";
      bool isReceivedPending = status == "received_pending";

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: isReceivedPending
                    ? ElevatedButton(
                        onPressed: controller.acceptInterest,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text("Accept Interest",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                    : OutlinedButton(
                        onPressed: controller.initiateChat,
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: isAccepted
                                    ? AppColors.theameColorRed
                                    : Colors.grey),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: Text("Message",
                            style: TextStyle(
                                color: isAccepted
                                    ? AppColors.theameColorRed
                                    : Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.initiateCall,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.call, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text("Call Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), // SafeArea
      ); // Container
    }); // Obx
  }
}
