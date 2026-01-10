import 'package:get/get.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/module/dashboard/dashboard_binding.dart';
import 'package:app/module/dashboard/dashboard_screen.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  //
  void onBottomBarItemTap(int value) {
    switch (value) {
      case 0:
        Get.offAll(const DashboardScreen(), binding: DashboardBinding());
        break;
      case 1:
        // Get.to(const SearchScreen(), binding: SearchBinding());
        break;
      case 2:
        // Navigate to Matches
        break;
      case 3:
        // Already on Settings
        break;
    }
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
