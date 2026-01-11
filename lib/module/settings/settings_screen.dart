import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/module/dashboard/dashboard_screen.dart';
import 'package:app/module/settings/settings_controller.dart';
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
                  SettingMenuCard("Privacy Policy", 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SettingMenuCard("Logout", 9)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
