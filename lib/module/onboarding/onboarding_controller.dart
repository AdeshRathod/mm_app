import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/module/onboarding/onboarding_screen.dart';
import 'package:app/module/main/bottom_nav.dart';
import 'package:app/module/main/bottom_nav_binding.dart';

class OnboardingController extends GetxController {
  final introKey = GlobalKey<OnboardingScreenState>();

  void onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    // Guest Mode - Show profiles before login
    Get.offAll(() => const BottomNavScreen(), binding: BottomNavBinding());
  }

  Widget buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(assetName, width: 350.0),
    );
  }
}
