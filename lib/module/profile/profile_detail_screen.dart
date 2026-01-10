import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/profile/profile_detail_binding.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileDetailController>(
      builder: (controller) => Scaffold(
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
                      _buildBasicInfoSection(),
                      const SizedBox(height: 20),
                      _buildActionButtons(controller),
                      const SizedBox(height: 25),
                      const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Physical Attributes"),
                      _buildPhysicalAttributes(),
                      const Divider(),
                      _buildSectionTitle("Education & Career"),
                      _buildEducationCareer(),
                      const Divider(),
                      _buildSectionTitle("Family Background"),
                      _buildFamilyBackground(),
                      const Divider(),
                      _buildSectionTitle("Horoscope Details"),
                      _buildHoroscopeDetails(),
                      const Divider(),
                      _buildSectionTitle("Lifestyle & Hobbies"),
                      _buildLifestyle(),
                      const SizedBox(height: 80), // Space for bottom bar
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomAction(controller),
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, ProfileDetailController controller) {
    return SliverAppBar(
      expandedHeight: 400.0,
      pinned: true,
      backgroundColor: AppColors.theameColorRed,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Profile Image Placeholder
            Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
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
                  const Text(
                    "Priya Sharma",
                    style: TextStyle(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white54)),
                        child: const Text(
                          "ID: MM8769876",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Last Online: 2h ago",
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
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

  Widget _buildBasicInfoSection() {
    return Column(
      children: [
        _buildInfoRow(Icons.calendar_today, "26 Oct 1996 (27 Yrs)"),
        _buildInfoRow(CupertinoIcons.person_3_fill, "Never Married"),
        _buildInfoRow(Icons.temple_hindu, "Hindu, Maratha"),
        _buildInfoRow(Icons.location_on, "Pune, Maharashtra"),
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
        GestureDetector(
          onTap: controller.sendInterest,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isInterestSent
                      ? Colors.pink[100]
                      : Colors.grey[100],
                ),
                child: Icon(
                  controller.isInterestSent
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: controller.isInterestSent
                      ? AppColors.theameColorRed
                      : Colors.grey[700],
                  size: 26,
                ),
              ),
              const SizedBox(height: 5),
              Text(controller.isInterestSent ? "Sent" : "Send Interest",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
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

  Widget _buildPhysicalAttributes() {
    return Column(
      children: [
        _buildGridItem("Height", "5' 6\""),
        _buildGridItem("Weight", "55 kg"),
        _buildGridItem("Blood Group", "B+"),
        _buildGridItem("Complexion", "Fair"),
        _buildGridItem("Body Type", "Slim"),
        _buildGridItem("Physical Status", "Normal"),
      ],
    );
  }

  Widget _buildEducationCareer() {
    return Column(
      children: [
        _buildGridItem("Education", "B.Tech (Computer Science)"),
        _buildGridItem("Occupation", "Software Engineer"),
        _buildGridItem("Employed in", "Private Sector"),
        _buildGridItem("Income", "₹ 8 LPA - 10 LPA"),
        _buildGridItem("Work Location", "Pune, Maharashtra"),
      ],
    );
  }

  Widget _buildFamilyBackground() {
    return Column(
      children: [
        _buildGridItem("Father", "Ramesh Sharma (Business)"),
        _buildGridItem("Mother", "Sunita Sharma (Home Maker)"),
        _buildGridItem("Brothers", "1 (Married)"),
        _buildGridItem("Sisters", "1 (Unmarried)"),
        _buildGridItem("Native Place", "Satara, Maharashtra"),
        _buildGridItem("Parents Contact", "+91 9876543210"),
      ],
    );
  }

  Widget _buildHoroscopeDetails() {
    return Column(
      children: [
        _buildGridItem("Rashi", "Vrishabh (Taurus)"),
        _buildGridItem("Nakshatra", "Rohini"),
        _buildGridItem("Mangal", "No"),
        _buildGridItem("Nadi", "Madhya"),
        _buildGridItem("Gan", "Manushya"),
        _buildGridItem("Time of Birth", "10:30 AM"),
      ],
    );
  }

  Widget _buildLifestyle() {
    return Column(
      children: [
        _buildGridItem("Diet", "Vegetarian"),
        _buildGridItem("Drink", "No"),
        _buildGridItem("Smoke", "No"),
        _buildGridItem("Hobby", "Reading, Traveling, Music"),
      ],
    );
  }

  Widget _buildBottomAction(ProfileDetailController controller) {
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
              child: OutlinedButton(
                onPressed: controller.initiateChat,
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.theameColorRed),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text("Message",
                    style: TextStyle(
                        color: AppColors.theameColorRed,
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
                            color: Colors.white, fontWeight: FontWeight.bold)),
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
