import 'package:app/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app/common/app_pages.dart';
import 'package:app/module/splash/splash_binding.dart';
import 'package:app/module/splash/splash_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Get.put(ThemeController());
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ThemeController controller = Get.find();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maratha Mangal',
      theme: controller.currentTheme,
      // initialBinding: CompleteProfileBinding(),
      // home: CompleteProfileScreen(),
      initialBinding: SplashBinding(),
      home: SplashScreen(),
      getPages: AppPages.pages,
    );
  }

  // Get.to(const HomeScreen(), binding: HomeBinding());
}
