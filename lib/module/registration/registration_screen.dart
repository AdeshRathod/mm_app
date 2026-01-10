import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/common/constants/app_strings.dart';
import 'package:app/common/widgets/custom_dropdown.dart';
import 'package:app/common/widgets/mm_custome_text_field.dart';
import 'package:app/module/profile/ConstantStrings.dart';
import 'package:app/module/profile/complete_profile_binding.dart';
import 'package:app/module/profile/complete_profile_screen.dart';
import 'package:app/module/registration/registration_controller.dart';
import 'package:app/module/registration/widgets/mm_text_field.dart';

import 'models/registration_model.dart';

class RegistrationScreen extends StatefulWidget {
  var mobileNumber;
  RegistrationScreen({Key? key, this.mobileNumber}) : super(key: key);

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
        builder: (controller) => Scaffold(
              appBar: AppBar(title: const Text('Register')),
              body: SingleChildScrollView(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Form(
                    child: Column(
                      children: [
                        MmCustomTextField(
                            "First Name", controller.controllerFirstName,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            errorText: controller.errorFirstNameText,
                            onChanged: (val) {
                          controller.clearError('firstName');
                        }, fontSize: 16.0),
                        MmCustomTextField(
                            "Middle Name", controller.controllerMiddleName,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            errorText: controller.errorMiddleNameText,
                            onChanged: (val) {
                          controller.clearError('middleName');
                        }, fontSize: 16.0),
                        MmCustomTextField(
                            "Last Name", controller.controllerLastName,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            errorText: controller.errorLastNameText,
                            onChanged: (val) {
                          controller.clearError('lastName');
                        }, fontSize: 16.0),
                        CustomDropDown(
                          dropdownValue: controller.dropdownValueGender,
                          errorText: controller.errorGenderText,
                          dropdownList: ConstantStrings.listGender,
                          onChangedClick: (val) {
                            controller.setGender(val);
                          },
                        ),
                        MmCustomTextField(
                          "Birthdate",
                          controller.controllerBirthDate,
                          readOnly: true,
                          onTap: () {
                            controller.selectDate(context);
                          },
                          errorText: controller.errorBirthdateText,
                          fontSize: 16.0,
                        ),
                        CustomDropDown(
                          dropdownValue: controller.dropdownValueSubCaste,
                          errorText: controller.errorSubCasteText,
                          dropdownList: ConstantStrings.listSubCaste,
                          onChangedClick: (val) {
                            controller.setSubCaste(val);
                          },
                        ),
                        MmCustomTextField("Email", controller.controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            errorText: controller.errorEmailText,
                            onChanged: (val) {
                          controller.clearError('email');
                        }, fontSize: 16.0),
                        MmCustomTextField(
                            "Mobile", controller.controllerMobileNo,
                            keyboardType: TextInputType.phone,
                            errorText: controller.errorMobileNoText,
                            onChanged: (val) {
                          controller.clearError('mobile');
                        }, fontSize: 16.0),
                        MmCustomTextField(
                            "Password", controller.controllerPassword,
                            isPassword: true,
                            errorText: controller.errorPasswordText,
                            onChanged: (val) {
                          controller.clearError('password');
                        }, fontSize: 16.0),
                        MmCustomTextField("Confirm Password",
                            controller.controllerConfirmPassword,
                            isPassword: true,
                            errorText: controller.errorConfirmPasswordText,
                            onChanged: (val) {
                          controller.clearError('confirmPassword');
                        }, fontSize: 16.0),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.theameColorRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              controller.registerUser();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )),
            ));
  }
}
