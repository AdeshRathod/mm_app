import 'package:get/get.dart';
import 'package:app/module/main/bottom_nav_controller.dart';
import 'package:app/module/dashboard/dashboard_binding.dart';
import 'package:app/module/search/search_binding.dart';
import 'package:app/module/recommended_matches/recommended_matches_binding.dart';
import 'package:app/module/settings/settings_controller.dart';
import 'package:app/module/social/social_binding.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => SearchProfileController(), fenix: true);
    Get.lazyPut(() => RecommendedMatchesController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => SocialController(), fenix: true);
  }
}
