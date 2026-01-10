import 'package:get/get.dart';
import 'package:app/module/search/search_binding.dart';
import 'package:app/module/search/search_screen.dart';
import 'package:app/module/settings/settings_binding.dart';
import 'package:app/module/settings/settings_screen.dart';

class DashboardController extends GetxController {
  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void onBottomBarItemTap(int value) {
    selectedIndex = value;
    update();
    switch (value) {
      case 0:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ActivityHomeScreen()),
        // );
        break;
      case 1:
        Get.to(const SearchScreen(), binding: SearchBinding());
        break;
      case 2:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ActivityHomeScreen()),
        // );
        break;
      case 3:
        Get.to(SettingsScreen(), binding: SettingsBinding());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ActivitySettingsScreen()),
        // );
        break;
    }
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
