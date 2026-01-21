import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/module/onboarding/onboarding_binding.dart';
import 'package:app/module/onboarding/onboarding_screen.dart';
import 'package:app/module/main/bottom_nav.dart';
import 'package:app/module/main/bottom_nav_binding.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationInitilization();
    startTimer();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  animationInitilization() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    animationController.forward();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

      if (token != null && token.isNotEmpty) {
        Get.offAll(() => const BottomNavScreen(), binding: BottomNavBinding());
      } else if (seenOnboarding) {
        // Guest Mode - Show profiles before login
        Get.offAll(() => const BottomNavScreen(), binding: BottomNavBinding());
      } else {
        Get.offAll(() => const OnboardingScreen(),
            binding: OnboardingBinding());
      }
    });
  }
}
