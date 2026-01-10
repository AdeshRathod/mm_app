import 'package:app/common/constants/app_colours.dart';
import 'package:app/common/widgets/mm_custome_text_field.dart';
import 'package:app/module/login/login_controller.dart';
import 'package:app/module/registration/registration_binding.dart';
import 'package:app/module/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MmCustomTextField(
                "Email or Mobile",
                controller.controllerUsername,
                errorText: controller.errorUsernameText,
                onChanged: (val) => controller.clearError('username'),
                fontSize: 16.0,
              ),
              MmCustomTextField(
                "Password",
                controller.controllerPassword,
                isPassword: true,
                errorText: controller.errorPasswordText,
                onChanged: (val) => controller.clearError('password'),
                fontSize: 16.0,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.theameColorRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          controller.loginUser();
                        },
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.to(() => RegistrationScreen(),
                      binding: RegistrationBinding());
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
