import 'package:app/module/membership/membership_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app/common/constants/app_routes.dart';

class MembershipScreen extends GetView<MembershipController> {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: 'Welcome to '),
                            TextSpan(
                              text: 'MM Matrimony',
                              style: TextStyle(color: Color(0xFFE50202)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Find your perfect match with us!",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      // Placeholder for Image
                      Image.asset('assets/images/footer_logo.png'),

                      const SizedBox(height: 20),
                      _buildBulletPoint(
                          "The free trial offers limited access to view basic profile details and express interest."),
                      _buildBulletPoint(
                          "The paid subscription unlocks full profile access, contact details, and unlimited chat."),
                      _buildBulletPoint(
                          "Verified profiles and advanced search filters are fully available in the paid plan."),
                      const SizedBox(height: 30),

                      // Current Plan Section
                      if (controller.userCurrentPlan.value != null) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Current Plan",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSubscriptionCard(
                            controller.userCurrentPlan.value, -2, false),
                        const SizedBox(height: 20),
                      ],

                      // Upgrades Section
                      if (controller.subscriptions.isNotEmpty) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Available Upgrades",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE50202)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.subscriptions.length,
                          itemBuilder: (context, index) {
                            var plan = controller.subscriptions[index];
                            bool isSelected =
                                controller.selectedIndex.value == index;
                            return _buildSubscriptionCard(
                                plan, index, isSelected);
                          },
                        ),
                      ] else if (controller.userCurrentPlan.value != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "You are already on our highest tier plan! Enjoy all premium features.",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                      if (controller.subscriptions.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: controller.termsAccepted.value,
                              activeColor: const Color(0xFFE50202),
                              onChanged: controller.toggleTerms,
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                children: [
                                  const TextSpan(text: "I agree to the "),
                                  TextSpan(
                                    text: "Terms & conditions",
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(
                                            AppRoutes.termsAndConditions);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (controller.subscriptions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.proceedWithPlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50202),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _getButtonText(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1.4),
                children: _parseBoldText(text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to parse bold text marked with simplistic logic if needed,
  // but for now, hardcoding bold logic based on the user prompt logic isn't dynamic.
  // The screenshot shows "free trial", "basic lessons", "paid subscription", "all levels" in bold.
  // Since the text is static in the code but dynamic in logic, I'll just manually bold specific phrases if I can.
  // For standard dynamic text, I'll just return normal text.
  // But wait, the bullet points ARE static in the designs. So I can hardcode the styling.

  List<TextSpan> _parseBoldText(String text) {
    // Quick and dirty manual bolding for the specific strings found in user request image
    List<TextSpan> spans = [];
    if (text.contains("free trial")) {
      var parts = text.split("free trial");
      spans.add(TextSpan(text: parts[0]));
      spans.add(const TextSpan(
          text: "free trial", style: TextStyle(fontWeight: FontWeight.bold)));
      if (parts.length > 1) {
        if (parts[1].contains("basic profile")) {
          var subParts = parts[1].split("basic profile");
          spans.add(TextSpan(text: subParts[0]));
          spans.add(const TextSpan(
              text: "basic profile",
              style: TextStyle(fontWeight: FontWeight.bold)));
          if (subParts.length > 1) spans.add(TextSpan(text: subParts[1]));
        } else {
          spans.add(TextSpan(text: parts[1]));
        }
      }
    } else if (text.contains("paid subscription")) {
      var parts = text.split("paid subscription");
      spans.add(TextSpan(text: parts[0]));
      spans.add(const TextSpan(
          text: "paid subscription",
          style: TextStyle(fontWeight: FontWeight.bold)));
      if (parts.length > 1) {
        if (parts[1].contains("full profile access")) {
          var subParts = parts[1].split("full profile access");
          spans.add(TextSpan(text: subParts[0]));
          spans.add(const TextSpan(
              text: "full profile access",
              style: TextStyle(fontWeight: FontWeight.bold)));
          if (subParts.length > 1) spans.add(TextSpan(text: subParts[1]));
        } else {
          spans.add(TextSpan(text: parts[1]));
        }
      }
    } else {
      spans.add(TextSpan(text: text));
    }
    return spans;
  }

  Widget _buildSubscriptionCard(dynamic plan, int index, bool isSelected) {
    String name = plan['name'] ?? '';
    double price = double.tryParse(plan['price'].toString()) ?? 0.0;
    // bool isBestValue = name.toLowerCase().contains('annual');
    // Logic for best value can be complex. Assuming Highest price or specific name.
    bool isBestValue =
        price > 400; // Arbitrary based on screenshot 499 is best value

    Color borderColor =
        isSelected ? const Color(0xFFE50202) : Colors.grey.shade300;
    Color bgColor = isSelected ? Colors.white : const Color(0xFFF9FAFB);

    bool isCurrentPlan = index == -2;

    return GestureDetector(
      onTap: isCurrentPlan ? null : () => controller.selectPlan(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrentPlan ? Colors.grey.shade50 : bgColor,
          border: Border.all(
              color: isCurrentPlan ? Colors.grey.shade300 : borderColor,
              width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCurrentPlan ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (price == 0)
                    const Text(
                      "Explore free, upgrade anytime later",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  else
                    Text(
                      isCurrentPlan
                          ? "Current active subscription"
                          : "Unlimited features for ₹ $price/- total",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
            if (isCurrentPlan)
              const Icon(Icons.check_circle_outline, color: Colors.grey)
            else if (isBestValue)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE50202),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Best Value",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    if (controller.selectedIndex.value == -1) return "Select a Plan";
    var plan = controller.subscriptions[controller.selectedIndex.value];
    bool isFree = (plan['price'] == 0 ||
        plan['name'].toString().toLowerCase().contains('free'));
    return isFree ? "Continue with free trial" : "Buy Subscription";
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(height: 30, width: 200, color: Colors.white),
            const SizedBox(height: 20),
            Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
