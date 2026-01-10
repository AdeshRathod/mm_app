import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:app/module/login/login_binding.dart';
import 'package:app/module/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/module/onboarding/onboarding_binding.dart';
import 'package:app/module/onboarding/onboarding_screen.dart';
import 'package:app/module/dashboard/dashboard_binding.dart';
import 'package:app/module/dashboard/dashboard_screen.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    animationInitilization();
    super.onInit();
    startTimer();
  }

  animationInitilization() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: false);
    animation = CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn)
        .obs
        .value;
    animation.addListener(() => update());
    animationController.forward();
  }

  //
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  //
  void startTimer() {
    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

      if (token != null && token.isNotEmpty) {
        Get.offAll(() => const DashboardScreen(), binding: DashboardBinding());
      } else if (seenOnboarding) {
        Get.offAll(() => const LoginScreen(), binding: LoginBinding());
      } else {
        Get.offAll(() => const OnboardingScreen(),
            binding: OnboardingBinding());
      }
    });
  }
}
