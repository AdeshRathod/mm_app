import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/module/main/bottom_nav.dart';
import 'package:app/module/main/bottom_nav_binding.dart';

class RegistrationController extends GetxController {
  // final formKey = GlobalKey<FormState>();

  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerMiddleName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerMobileNo = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();
  final TextEditingController controllerBirthDate = TextEditingController();

  String? firstNameText,
      middleNameText,
      lastNameText,
      genderText,
      subCasteText,
      emailText,
      mobileNoText,
      passwordText,
      confirmPasswordText;

  String errorFirstNameText = "",
      errorMiddleNameText = "",
      errorLastNameText = "",
      errorGenderText = "",
      errorBirthdateText = "",
      errorSubCasteText = "",
      errorEmailText = "",
      errorMobileNoText = "",
      errorPasswordText = "",
      errorConfirmPasswordText = "";

  String dropdownValueGender = 'Gender';
  String dropdownValueSubCaste = 'Sub Caste';

  setGender(newValue) {
    dropdownValueGender = newValue;
    errorGenderText = ""; // clear error on select
    update();
  }

  setSubCaste(newValue) {
    dropdownValueSubCaste = newValue;
    errorSubCasteText = ""; // clear error on select
    update();
  }

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

  void registerUser() {
    if (validateForm()) {
      // Proceed with registration

      Server server = Server();

      // Format date from "dd - MM - yyyy" to "yyyy-MM-dd"
      String formattedDate = "";
      try {
        List<String> parts = controllerBirthDate.text.split(' - ');
        if (parts.length == 3) {
          String day = parts[0].padLeft(2, '0');
          String month = parts[1].padLeft(2, '0');
          String year = parts[2];
          formattedDate = "$year-$month-$day";
        } else {
          formattedDate = controllerBirthDate.text;
        }
      } catch (e) {
        debugPrint("Date Parse Error: $e");
        formattedDate = controllerBirthDate.text;
      }

      Map<String, dynamic> body = {
        "firstName": controllerFirstName.text.trim(),
        "middleName": controllerMiddleName.text.trim(),
        "lastName": controllerLastName.text.trim(),
        "email": controllerEmail.text.trim(),
        "mobile": controllerMobileNo.text.trim(),
        "birthdate": formattedDate,
        "password": controllerPassword.text,
        "confirmPassword": controllerConfirmPassword.text,
        "gender": dropdownValueGender,
        "subCaste": dropdownValueSubCaste,
      };

      try {
        server.api.registerUser(body).then((response) async {
          _showSnackBar("Success", "Registration Successful",
              backgroundColor: Colors.green);

          if (response['access_token'] != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('access_token', response['access_token']);
            if (response['user'] != null && response['user']['_id'] != null) {
              await prefs.setString('user_id', response['user']['_id']);
            }
          }

          Get.offAll(() => const BottomNavScreen(),
              binding: BottomNavBinding());
        }).catchError((error) {
          String errorMessage = "Registration Failed";
          if (error is DioException) {
            errorMessage = error.response?.data['message'] ?? error.message;
          }
          _showSnackBar("Error", errorMessage,
              backgroundColor: Colors.redAccent);
        });
      } catch (e) {
        _showSnackBar("Error", "Something went wrong",
            backgroundColor: Colors.redAccent);
      }
    } else {
      _showSnackBar("Error", "Please fill all fields correctly",
          backgroundColor: Colors.redAccent);
    }
  }

  bool validateForm() {
    bool isValid = true;

    if (controllerFirstName.text.trim().isEmpty) {
      errorFirstNameText = "Enter First Name";
      isValid = false;
    } else {
      errorFirstNameText = "";
    }

    if (controllerMiddleName.text.trim().isEmpty) {
      errorMiddleNameText = "Enter Middle Name";
      isValid = false;
    } else {
      errorMiddleNameText = "";
    }

    if (controllerLastName.text.trim().isEmpty) {
      errorLastNameText = "Enter Last Name";
      isValid = false;
    } else {
      errorLastNameText = "";
    }

    if (dropdownValueGender == "Gender") {
      errorGenderText = "Select Gender";
      isValid = false;
    } else {
      errorGenderText = "";
    }

    if (controllerBirthDate.text.isEmpty) {
      // Assuming we need to show error on UI somewhere, but currently MmCustomTextField handles text field errors.
      // For custom widgets like DatePicker, we might need a separate error variable or a Toast.
      // We'll set a local error string, but might need to reflect it in UI.
      // For now, consistent with others:
      errorBirthdateText = "Select Birthdate";
      isValid = false;
    } else {
      errorBirthdateText = "";
    }

    if (dropdownValueSubCaste == "Sub Caste") {
      errorSubCasteText = "Select Sub Caste";
      isValid = false;
    } else {
      errorSubCasteText = "";
    }

    if (controllerEmail.text.trim().isEmpty ||
        !GetUtils.isEmail(controllerEmail.text.trim())) {
      errorEmailText = "Enter valid Email";
      isValid = false;
    } else {
      errorEmailText = "";
    }

    if (controllerMobileNo.text.trim().isEmpty ||
        !RegExp(r'^[0-9]{10}$').hasMatch(controllerMobileNo.text.trim())) {
      errorMobileNoText = "Enter valid 10-digit Mobile";
      isValid = false;
    } else {
      errorMobileNoText = "";
    }

    if (controllerPassword.text.isEmpty || controllerPassword.text.length < 6) {
      errorPasswordText = "Password must be at least 6 chars";
      isValid = false;
    } else {
      errorPasswordText = "";
    }

    if (controllerConfirmPassword.text != controllerPassword.text) {
      errorConfirmPasswordText = "Passwords do not match";
      isValid = false;
    } else {
      errorConfirmPasswordText = "";
    }

    update(); // Update UI with error messages
    return isValid;
  }

  // Clear specific error when user types
  void clearError(String field) {
    switch (field) {
      case 'firstName':
        errorFirstNameText = "";
        break;
      case 'middleName':
        errorMiddleNameText = "";
        break;
      case 'lastName':
        errorLastNameText = "";
        break;
      case 'email':
        errorEmailText = "";
        break;
      case 'mobile':
        errorMobileNoText = "";
        break;
      case 'password':
        errorPasswordText = "";
        break;
      case 'confirmPassword':
        errorConfirmPasswordText = "";
        break;
    }
    update();
  }

  setFieldToBlank() {
    controllerFirstName.text = "";
    controllerLastName.text = "";
    controllerEmail.text = "";
    dropdownValueGender = "Gender";
    controllerMobileNo.text = "";
    controllerBirthDate.text = "";
    dropdownValueSubCaste = "Sub Caste";
    controllerPassword.text = "";
    controllerConfirmPassword.text = "";

    errorFirstNameText = "";
    errorMiddleNameText = "";
    errorLastNameText = "";
    errorGenderText = "";
    errorBirthdateText = "";
    errorSubCasteText = "";
    errorEmailText = "";
    errorMobileNoText = "";
    errorPasswordText = "";
    errorConfirmPasswordText = "";
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (d != null) {
      // Format: dd - MM - yyyy
      controllerBirthDate.text = "${d.day} - ${d.month} - ${d.year}";
      errorBirthdateText = "";
      update();
    }
  }
}
