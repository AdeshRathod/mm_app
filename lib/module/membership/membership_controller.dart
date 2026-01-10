import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/Server.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:app/common/constants/app_routes.dart';

class MembershipController extends GetxController {
  var subscriptions = <dynamic>[].obs;
  var userCurrentPlan = Rxn<dynamic>(); // Stores user's current plan info
  var selectedIndex = (-1).obs; // -1 means none selected
  var termsAccepted = false.obs;
  var isLoading = true.obs;
  var isProcessingPayment = false.obs;
  // late Razorpay _razorpay;

  @override
  void onInit() {
    super.onInit();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchSubscriptions();
  }

  @override
  void onClose() {
    // _razorpay.clear();
    super.onClose();
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

  void fetchSubscriptions() async {
    try {
      isLoading(true);
      Server server = Server();

      // 1. Fetch User Profile to get current plan price
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      double currentPrice = 0;

      if (userId != null) {
        var user = await server.api!.getUser(userId);
        // Find the price of the current plan
        String currentPlanName = user['subscriptionType'] ?? "Free";

        // If user is on a paid plan, we need to know its price to filter lower ones
        // We'll fetch all plans and find the one they are currently on
        var allPlans = await server.api!.getSubscriptions();
        for (var p in allPlans) {
          if (p['name'] == currentPlanName) {
            currentPrice = (p['price'] ?? 0).toDouble();
            userCurrentPlan.value = p; // Store the current plan full object
            break;
          }
        }

        // 2. Filter plans: only show plans with price > currentPrice
        // User said "lower plans should not be visible", implying they want to see upgrade paths.

        var filteredPlans = allPlans.where((p) {
          double pPrice = (p['price'] ?? 0).toDouble();
          return pPrice > currentPrice;
        }).toList();

        subscriptions.value = filteredPlans;
      } else {
        // Fallback if no user_id (should not happen in membership screen)
        var result = await server.api!.getSubscriptions();
        subscriptions.value = result;
      }
    } catch (e) {
      _showSnackBar("Error", "Failed to load subscriptions: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  void selectPlan(int index) {
    selectedIndex.value = index;
  }

  void toggleTerms(bool? value) {
    termsAccepted.value = value ?? false;
  }

  void proceedWithPlan() async {
    if (selectedIndex.value == -1) {
      _showSnackBar("Select Plan", "Please select a subscription plan.",
          backgroundColor: Colors.red);
      return;
    }
    if (!termsAccepted.value) {
      _showSnackBar("Terms", "Please accept terms and conditions.",
          backgroundColor: Colors.red);
      return;
    }

    var plan = subscriptions[selectedIndex.value];
    bool isFreeTrial = (plan['price'] == 0 ||
        plan['name'].toString().toLowerCase().contains('free'));

    if (isFreeTrial) {
      startFreeTrial();
    } else {
      // Mock Payment Flow
      _simulateMockPayment(plan);
    }
  }

  // Purely Mock Payment Simulation
  void _simulateMockPayment(var plan) async {
    try {
      isProcessingPayment.value = true;
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Securing Payment..."),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close dialog

      _showSnackBar("Success", "Mock Payment Successful!",
          backgroundColor: Colors.green);

      // Post Payment Logic (Update Backend)
      _finalizeSubscription(plan);
    } catch (e) {
      Get.back();
      _showSnackBar("Error", "Payment failed: $e", backgroundColor: Colors.red);
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void _finalizeSubscription(var plan) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();
        await server.api!.purchaseSubscription(plan['_id'], userId);

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.dashboard);
        });
      }
    } catch (e) {
      _showSnackBar("Error", "Subscription activation failed: $e",
          backgroundColor: Colors.red);
    }
  }

  /* 
  // Commented out Razorpay handlers as per user request to use Mock entirely
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // 3. Payment Successful -> Update Backend
    try {
      _showSnackBar("Success", "Payment Successful: ${response.paymentId}",
          backgroundColor: Colors.green);

      var plan = subscriptions[selectedIndex.value];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();
        await server.api!.purchaseSubscription(plan['_id'], userId);

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.dashboard);
        });
      }
    } catch (e) {
      _showSnackBar("Error", "Subscription activation failed: $e",
          backgroundColor: Colors.red);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showSnackBar("Payment Failed",
        "Code: ${response.code} | Message: ${response.message}",
        backgroundColor: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackBar("External Wallet", "Wallet: ${response.walletName}",
        backgroundColor: Colors.blue);
  }
  */

  void startFreeTrial() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Server server = Server();
        await server.api!.updateUser(userId, {'subscriptionStatus': 'trial'});
        _showSnackBar("Success", "Free Trial Started!",
            backgroundColor: Colors.green);
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.dashboard);
        });
      } else {
        _showSnackBar("Error", "User ID not found",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error", "Failed to start trial: $e",
          backgroundColor: Colors.red);
    }
  }
}
