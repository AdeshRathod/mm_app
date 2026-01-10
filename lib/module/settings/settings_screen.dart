import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/dashboard/dashboard_screen.dart';
import 'package:app/module/settings/settings_binding.dart';
import 'package:app/module/settings/widgets/setting_menu_card.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<SettingsController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SettingMenuCard("About Us", 1),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("Membership", 2),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("Rules", 3),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("FAQ's", 4),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  //   child: Divider(
                  //     color: Colors.black,
                  //     thickness: 0.2,
                  //   ),
                  // ),
                  // SettingMenuCard("Contact Us", 5),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("Help Center", 6),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("Terms and Conditions", 7),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("Privacy Policy", 8)
                ],
              ),
            ),
          ),
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
            currentIndex: 3, // Settings is index 3
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
}
