import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../common/constants/app_colours.dart';

import '../../common/widgets/custom_message_layout.dart';
import '../../common/widgets/custom_text_button.dart';
import '../../common/widgets/custom_texts.dart';
import 'MenuDrawer.dart';
import 'homeUtils.dart';

Widget mobileHomeScreen(
    List<dynamic> users, Map<String, dynamic> stats, bool isLoading) {
  return Scaffold(
    appBar: AppBar(
        title: const CustomTextBold(
          text: "Maratha Mangal",
          textColour: AppColors.primaryWhite,
        ),
        backgroundColor: AppColors.primaryDark),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : LayoutBuilder(builder: (BuildContext context, constraint) {
            return contentPages(constraint.maxHeight * 0.2, users, stats);
          }),
    drawer: MenuDrawer(),
  );
}

Widget contentPages(
    imageHeight, List<dynamic> users, Map<String, dynamic> stats) {
  return LayoutBuilder(builder: (context, constraints) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.asset(
                "assets/images/ganpati.png",
                height: imageHeight,
                width: constraints.maxWidth,
                fit: BoxFit.fill,
              ),
              getProfileCarousel(constraints, context, users),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const CustomTextBold(
                        text: "How it Works?",
                        textColour: AppColors.primaryDark,
                        textSize: 16,
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                            text:
                                "फक्त तीन सोपी पावलं तुम्हाला तुमच्या अपेक्षेप्रमाणे स्थळे शोधण्यासाठी मदत करू शकतील.",
                            textColour: AppColors.primaryBlack,
                            textSize: 13,
                            textAlign: TextAlign.left),
                      ),
                      getOnboardLayout(context),
                    ],
                  ),
                ),
              ),
              getAdsLayout(constraints, context),
              Container(
                  width: constraints.maxWidth,
                  color: Colors.transparent,
                  alignment: Alignment.topLeft,
                  child: statusBars(constraints, stats)),
              Container(
                color: AppColors.primaryBlack,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    socialMediaLinks(),
                    bottomNavLayout(),
                  ],
                ),
              )
            ],
          ),
        ));
  });
}

// ... existing bottomNavLayout ...

Widget getProfileCarousel(constraints, context, List<dynamic> users) {
  if (users.isEmpty) return const SizedBox.shrink();

  return Container(
    margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
    width: constraints.maxWidth * 0.98,
    decoration: BoxDecoration(
        color: AppColors.lightOrange,
        border: Border.all(width: 1, color: AppColors.lightOrange),
        borderRadius: BorderRadius.circular(10)),
    child: CarouselSlider(
      options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 4.0,
          enlargeCenterPage: true,
          viewportFraction: 0.8,
          height: MediaQuery.of(context).size.height * 0.25),
      items: users.map((item) {
        // Construct full name
        String name = [item['firstName'], item['lasttName']]
            .where((s) => s != null)
            .join(" "); // typo in item map check
        // Using fallback for missing fields for now
        String dob = item['registrationDate'] != null
            ? item['registrationDate'].toString().split('T')[0]
            : "N/A";
        String location = item['location'] ?? "Unknown";
        String education =
            "Education"; // We don't have education in User model yet? Or check logic
        String profession = item['profession'] ?? "N/A";

        return Container(
            decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                border: Border.all(width: 1, color: AppColors.primaryWhite),
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.08,
                        backgroundColor: AppColors.lightestGrey,
                        child: ClipOval(
                            child: Icon(Icons.person_rounded,
                                size: MediaQuery.of(context).size.width * 0.1,
                                color: AppColors.primaryDark)),
                      ),
                    ),
                    Expanded(
                        child: CustomText(
                      text: name.isNotEmpty ? name : "User",
                      textSize: 14,
                    ))
                  ],
                ),
                Column(
                  children: [
                    // Using registration date as DOB proxy or just label it joined
                    // Expanded(child: labelValueRow("DOB", dob)),
                    // Let's use Age if available
                    Expanded(
                        child: labelValueRow(
                            "Age", item['age']?.toString() ?? "N/A")),
                    Expanded(
                        child: labelValueRow(
                            "Gender",
                            item['gender'] ??
                                "N/A")), // Height not in User model?
                    Expanded(child: labelValueRow("Occ. ", profession)),
                    // Expanded(child: labelValueRow("Edu. ", education)),
                    Expanded(child: labelValueRow("Loc. ", location)),
                  ],
                ),
              ],
            ));
      }).toList(),
    ),
  );
}

Widget statusBars(constraint, Map<String, dynamic> stats) {
  return Column(children: [
    CustomText(
      text: "Current Status:",
      textColour: AppColors.primaryDark,
      textSize: 16,
    ),
    Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20, bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            circularPercentage(
                30.0,
                4.0,
                (stats['registrations_this_week']?.toString() ?? "0"),
                "Registration this week",
                AppColors.primaryDarkLight,
                AppColors.primaryBlack,
                0.8,
                constraint.maxHeight * 0.15,
                constraint.maxWidth * 0.3),
            circularPercentage(
                30.0,
                4.0,
                (stats['subscriptions_this_week']?.toString() ?? "0"),
                "Subscription this week",
                AppColors.errorRed,
                AppColors.primaryBlack,
                0.8,
                constraint.maxHeight * 0.15,
                constraint.maxWidth * 0.3),
            circularPercentage(
                30.0,
                4.0,
                (stats['total_grooms']?.toString() ?? "0"),
                "Total Grooms",
                AppColors.lightBlack,
                AppColors.primaryBlack,
                0.8,
                constraint.maxHeight * 0.15,
                constraint.maxWidth * 0.3),
            circularPercentage(
                30.0,
                4.0,
                (stats['total_brides']?.toString() ?? "0"),
                "Total Brides",
                Colors.green,
                AppColors.primaryBlack,
                0.8,
                constraint.maxHeight * 0.15,
                constraint.maxWidth * 0.3),
          ],
        ),
      ),
    ),
  ]);
}

Widget bottomNavLayout() {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage("assets/images/footer_logo.png"),
                width: 100,
                height: 100,
              ),
              SizedBox(
                  width: 200,
                  child: CustomText(
                      textAlign: TextAlign.left,
                      textSize: 12,
                      text:
                          "Maratha Mangal, the leading Marathi Matrimony service provider for the Marathi community has the network in all over Maharashtra with a well mannered and traditional associates to assist you in search for a partner."))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 200,
                child: CustomTextBold(
                  textAlign: TextAlign.left,
                  textSize: 12,
                  text: "Contact Us",
                  textColour: AppColors.primaryWhite,
                ),
              ),
              SizedBox(
                  width: 200,
                  child: CustomText(
                      textAlign: TextAlign.left,
                      textSize: 12,
                      text: "Bibwewadi, Pune 411037")),
              SizedBox(
                  width: 200,
                  child: CustomText(
                    textAlign: TextAlign.left,
                    textSize: 12,
                    text: "+91 7888036366",
                    textColour: AppColors.errorRed,
                  )),
              SizedBox(
                  width: 200,
                  child: CustomText(
                      textAlign: TextAlign.left,
                      textSize: 12,
                      text: "info@marathamangal.com",
                      textColour: AppColors.errorRed)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(10.0),
                  child: const CustomTextBold(
                    textAlign: TextAlign.left,
                    textSize: 12,
                    text: "Information",
                    textColour: AppColors.primaryWhite,
                  ),
                ),
                showMenuAndroidOptions()
              ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: const CustomTextBold(
                    textAlign: TextAlign.left,
                    textSize: 12,
                    text: "Free Membership for a Year",
                    textColour: AppColors.primaryWhite,
                  ),
                ),
                Container(
                  width: 200,
                  child: CustomText(
                    textAlign: TextAlign.left,
                    textSize: 12,
                    text: "Not a Member Yet?",
                  ),
                ),
                CustomTextButton(
                    onPressed: () {},
                    ButtonTextValue: " Register Now (Free)",
                    isButtonDisable: false)
              ]),
        )
      ],
    ),
  );
}

Widget getOnboardLayout(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CustomMessageLayout(
          animationString: "assets/images/onboarding_one.jpg",
          data_heading: 'Register',
          data_body:
              'आपल्या संपूर्ण माहितीसह मंगल मराठा वर आपले प्रोफाईल तयार करा.',
          imageType: 'JPEG',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          titleFontSize: 14),
      CustomMessageLayout(
          animationString: "assets/images/onboarding_two.jpg",
          data_heading: 'Find Your Best Match',
          data_body:
              "आपल्या अपेक्षेप्रमाणे स्थळे शोधण्यासाठी उपलब्ध असलेले विविध सर्च पर्याय वापरा.",
          imageType: 'JPEG',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          titleFontSize: 14),
      CustomMessageLayout(
          animationString: "assets/images/onboarding_three.jpg",
          data_heading: "Send Response",
          data_body: "योग्य वाटणाऱ्या स्थळांना फोन किंवा ई-मेल ने संपर्क करा.",
          imageType: 'JPEG',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          titleFontSize: 14),
    ],
  );
}

Widget getAdsLayout(
  constraints,
  context,
) {
  return Container(
    width: constraints.maxWidth,
    color: AppColors.searchGrey,
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        const CustomTextBold(
          text: "Wants to know about us a little more?",
          textColour: AppColors.primaryDark,
          textSize: 14,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            text: "Check out the below articles",
            textColour: AppColors.primaryBlack,
            textSize: 13,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailsCard(
                    constraints,
                    "Enroll",
                    "Description long body jnjknkjbkbkb b knknknnkbhjbhjbjhn",
                    context,
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.3),
                detailsCard(
                    constraints,
                    "Success Stories",
                    "You can add/update your photo instantly through this option very easily. Your photo will be added/updated on website instantly after submission of photo. For this option you need only your registered email ID & registration ID.",
                    context,
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.3),
                detailsCard(
                    constraints,
                    "Magazine",
                    "This is listing of grooms & brides who are happily married through us & enjoying their married life. Due to our private guidelines, we have not given their photograph & contact details online. Around 24000 weddings are settled through us as yet.",
                    context,
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.3),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  //   Column(
  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   children: [
  //     SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           detailsCard(constraints, "Enroll", "Description long body jnjknkjbkbkb b knknknnkbhjbhjbjhn", context,MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5),
  //           detailsCard( constraints ,"Success Stories", "You can add/update your photo instantly through this option very easily. Your photo will be added/updated on website instantly after submission of photo. For this option you need only your registered email ID & registration ID." ,context,MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5),
  //           detailsCard(constraints, "Magazine" ,"This is listing of grooms & brides who are happily married through us & enjoying their married life. Due to our private guidelines, we have not given their photograph & contact details online. Around 24000 weddings are settled through us as yet." ,context,MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5),
  //         ],
  //       ),
  //     ),
  //   ],
  // );
}

// Widget getAdsLayout(constraints, context) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           detailsCard(constraints, "Enroll", "Description long body jnjknkjbkbkb b knknknnkbhjbhjbjhn", context,MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5),
//           detailsCard( constraints ,"Success Stories", "You can add/update your photo instantly through this option very easily. Your photo will be added/updated on website instantly after submission of photo. For this option you need only your registered email ID & registration ID." ,context,MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5),
//           detailsCard(constraints, "Magazine" ,"This is listing of grooms & brides who are happily married through us & enjoying their married life. Due to our private guidelines, we have not given their photograph & contact details online. Around 24000 weddings are settled through us as yet." ,context,MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5),
//         ],
//       ),
//     ],
//   );
// }
