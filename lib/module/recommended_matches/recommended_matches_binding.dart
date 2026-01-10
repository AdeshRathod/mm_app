import 'package:get/get.dart';

class RecommendedMatchesController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }
}

class RecommendedMatchesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecommendedMatchesController());
  }
}
