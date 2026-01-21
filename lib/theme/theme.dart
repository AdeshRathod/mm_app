import 'package:app/theme/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: const Color(0xFFB71C1C), // Deep Red
  scaffoldBackgroundColor:
      const Color(0xFFF9FAFB), // Very light grey, premium feel

  // Font Family
  fontFamily: 'Roboto', // Fallback to Roboto/System

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Color(0xFF2D3436), size: 22),
    titleTextStyle: TextStyle(
      color: Color(0xFF2D3436),
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  ),

  // Bottom Navigation
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFFB71C1C),
    unselectedItemColor: Color(0xFF9E9E9E),
    type: BottomNavigationBarType.fixed,
    elevation: 10,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  ),

  // Divider
  dividerTheme: const DividerThemeData(
    color: Color(0xFFEEEEEE),
    thickness: 1,
  ),

  // Elevated Button - Premium gradient style needs to be handled in widget, but default style:
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB71C1C),
      foregroundColor: Colors.white,
      elevation: 5,
      shadowColor: const Color(0xFFB71C1C).withOpacity(0.4),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Input Decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    hintStyle: TextStyle(
      color: Colors.grey.shade400,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
  ),

  // Tab Bar
  tabBarTheme: const TabBarThemeData(
    labelColor: Color(0xFFB71C1C),
    unselectedLabelColor: Color(0xFF757575),
    indicatorColor: Color(0xFFB71C1C),
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  ),

  extensions: [
    CustomThemeExtension(
        gradientProgressLoaderCustomTheme: GradientProgressLoaderCustomTheme(
            loaderRadius: 40,
            gradientLoaderColors: const [
              Color(0xFFB71C1C),
              Color(0xFFFFD700), // Gold
            ],
            strokeWidth: 8),
        toastSuccessColor: const Color(0xFF4CAF50),
        toastErrorColor: const Color(0xFFE53935),
        sendInviteContainerBgColor: const Color(0xFFFFF8E1), // Light Gold

        homeServicesSvgIcon: const Color(0xFFB71C1C),
        homeServicesSvgBg: const Color(0xFFFFEBEE),
        homeTransitionSvgIcon: const Color(0xFFB71C1C),
        downloadSvgIcon: const Color(0xFFB71C1C),
        levelTwoSvgIcon: const Color(0xFFB71C1C),
        customButtonTheme: CustomButtonTheme(
            enableButtonColor: const Color(0xFFB71C1C),
            disableButtonColor: const Color(0xFFE0E0E0),
            enableBtnTextColor: Colors.white,
            disableBtnTextColor: const Color(0xFF9E9E9E),
            enableBtnBorderColor: const Color(0xFFB71C1C),
            disableBtnBorderColor: const Color(0xFFE0E0E0),
            circularProgressIndicatorColor: Colors.white),
        customLinearGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB71C1C), // Deep Red
            Color(0xFFE53935), // Lighter Red
          ],
        ),
        customLinearGradientHalfScreen: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFB71C1C),
            const Color(0xFFB71C1C).withOpacity(0.8),
          ],
        ),
        customLinearGradientFullScreen: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8E0000), // Darker Red
            Color(0xFFB71C1C), // Red
            Color(0xFFE53935), // Light Red
          ],
        ),
        downloadBtnDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFB71C1C)),
          borderRadius: BorderRadius.circular(12),
        ),
        shareBtnDecoration: BoxDecoration(
          color: const Color(0xFFB71C1C),
          border: Border.all(color: const Color(0xFFB71C1C)),
          borderRadius: BorderRadius.circular(12),
        ),
        qrCodeDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFB71C1C))),
        circularBgForUserInitial: const BoxDecoration(
          color: Color(0xFFFFD700), // Gold
          shape: BoxShape.circle,
        ),
        customLoading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                  child: SizedBox(
                width: 30,
                height: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.circleStrokeSpin,
                  colors: [Color(0xFFB71C1C)],
                ),
              )),
            )),
        appColorTheme: AppColorTheme(
            textPrimaryColor: const Color(0xFF2D3436),
            textSecondaryColor: const Color(0xFF636E72),
            textTitleColor: const Color(0xFF2D3436),
            textSubTitleColor: const Color(0xFFB2BEC3),
            textHintColor: const Color(0xFFB2BEC3),
            textNeutralColor: Colors.white,
            textSuccessColor: const Color(0xFF00B894),
            textFailureColor: const Color(0xFFD63031),
            textBackgroundColor: const Color(0xFFF9FAFB),
            textBlackColor: Colors.black,
            iconWarningColor: const Color(0xFFFFCC00),
            textSubtitleLightColor: const Color(0xFFDFE6E9)))
  ],
);
