import 'package:app/core/Server.dart';
import 'package:app/module/profile/complete_profile_binding.dart';
import 'package:app/module/profile/complete_profile_screen.dart';
import 'package:app/module/main/bottom_nav.dart';
import 'package:app/module/main/bottom_nav_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController controllerUsername =
      TextEditingController(); // Email or Mobile
  final TextEditingController controllerPassword = TextEditingController();

  String errorUsernameText = "";
  String errorPasswordText = "";

  bool isLoading = false;

  void _showSnackBar(String title, String message, {Color? backgroundColor}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("$title: $message",
              style: const TextStyle(color: Colors.white)),
          backgroundColor: backgroundColor ?? Colors.black,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void loginUser() {
    if (validateForm()) {
      isLoading = true;
      update();

      Server server = Server();
      Map<String, dynamic> body = {
        "username": controllerUsername.text.trim(),
        "password": controllerPassword.text
      };

      try {
        server.api.loginUser(body).then((response) async {
          isLoading = false;
          update();

          _showSnackBar("Success", "Login Successful",
              backgroundColor: Colors.green);

          if (response['access_token'] != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('access_token', response['access_token']);
            if (response['user'] != null && response['user']['_id'] != null) {
              await prefs.setString('user_id', response['user']['_id']);
            }
          }
          if (response['user'] != null &&
              response['user']['status'] == 'pending_profile') {
            Get.offAll(() => const CompleteProfileScreen(),
                binding: CompleteProfileBinding());
          } else {
            Get.offAll(() => const BottomNavScreen(),
                binding: BottomNavBinding());
          }
        }).catchError((error) {
          isLoading = false;
          update();
          // Error handling is managed by Global Interceptor, but we stop loader here.
        });
      } catch (e) {
        isLoading = false;
        update();
        _showSnackBar("Error", "Something went wrong",
            backgroundColor: Colors.redAccent);
      }
    }
  }

  bool validateForm() {
    bool isValid = true;
    String input = controllerUsername.text.trim();
    if (input.isEmpty) {
      errorUsernameText = "Enter Email or Mobile";
      isValid = false;
    } else if (GetUtils.isNumericOnly(input)) {
      if (input.length != 10) {
        errorUsernameText = "Mobile number must be 10 digits";
        isValid = false;
      } else {
        errorUsernameText = "";
      }
    } else {
      if (!GetUtils.isEmail(input)) {
        errorUsernameText = "Enter valid Email";
        isValid = false;
      } else {
        errorUsernameText = "";
      }
    }

    if (controllerPassword.text.isEmpty) {
      errorPasswordText = "Enter Password";
      isValid = false;
    } else {
      errorPasswordText = "";
    }
    update();
    return isValid;
  }

  void clearError(String field) {
    if (field == 'username') {
      errorUsernameText = "";
    } else if (field == 'password') {
      errorPasswordText = "";
    }
    update();
  }
}
