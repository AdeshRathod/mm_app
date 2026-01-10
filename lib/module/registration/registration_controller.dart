import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/module/registration/models/registration_model.dart';

import '../profile/complete_profile_binding.dart';
import '../profile/complete_profile_screen.dart';
import 'package:app/core/Server.dart';
import 'package:dio/dio.dart';

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

  void registerUser() {
    if (validateForm()) {
      // Proceed with registration

      Server server = Server();

      // Format date from "dd - MM - yyyy" to "yyyy-MM-dd"
      String formattedDate = "";
      try {
        // Assuming format "dd - MM - yyyy" based on selectDate method
        // We need to parse strict to avoid errors if format changes or is manually edited (though readOnly)
        // The selectDate method sets: "${d.day} - ${d.month} - ${d.year}"
        // Note: d.day and d.month don't have leading zeros in the current implementation of selectDate

        List<String> parts = controllerBirthDate.text.split(' - ');
        if (parts.length == 3) {
          String day = parts[0].padLeft(2, '0');
          String month = parts[1].padLeft(2, '0');
          String year = parts[2];
          formattedDate = "$year-$month-$day";
        } else {
          // Fallback or error
          formattedDate = controllerBirthDate.text;
        }
      } catch (e) {
        debugPrint("Date Parse Error: $e");
        formattedDate = controllerBirthDate.text; // Send as is if fail
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
        server.api!.registerUser(body).then((response) {
          Get.snackbar("Success", "Registration Successful",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.to(() => const CompleteProfileScreen(),
              binding: CompleteProfileBinding());
        }).catchError((error) {
          String errorMessage = "Registration Failed";
          if (error is DioException) {
            errorMessage = error.response?.data['message'] ?? error.message;
          }
          Get.snackbar("Error", errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        });
      } catch (e) {
        Get.snackbar("Error", "Something went wrong",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }

      /*
      var registrationModel = RegistrationModel(
          firstName: controllerFirstName.text,
          lastName: controllerLastName.text,
          middleName: controllerMiddleName.text,
          gender: dropdownValueGender,
          birthdate: controllerBirthDate.text.toString(),
          subCaste: dropdownValueSubCaste,
          email: controllerEmail.text,
          mobile: controllerMobileNo.text,
          password: controllerPassword.text);

      try {
        // Firebase logic here
        // FirebaseFirestore.instance.collection('Registered').doc(registrationModel.mobile).set(registrationModel.registrationToJson());
        // setFieldToBlank();
        // Get.to(const CompleteProfileScreen(), binding: CompleteProfileBinding());
      } catch (e) {
        debugPrint("Registration Exception $e");
      }
      */
    } else {
      Get.snackbar("Error", "Please fill all fields correctly",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
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
