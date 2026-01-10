import 'package:app/module/login/login_binding.dart';
import 'package:app/module/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/module/onboarding/onboarding_screen.dart';

class OnboardingController extends GetxController {
  final introKey = GlobalKey<OnboardingScreenState>();

  void onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Get.offAll(() => const LoginScreen(), binding: LoginBinding());
  }

  Widget buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(assetName, width: 350.0),
    );
  }
}
