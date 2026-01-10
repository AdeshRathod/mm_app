import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:app/common/constants/app_colours.dart';
import 'package:app/common/constants/app_constants.dart';
import 'package:app/common/constants/app_images.dart';
import 'package:app/common/widgets/custom_circular_button.dart';
import 'package:app/common/widgets/custom_elevated_button.dart';
import 'package:app/common/widgets/custom_text_button.dart';
import 'package:app/common/widgets/custom_texts.dart';
import 'package:app/module/home/mobile_home_screen.dart';
import 'package:app/module/home/web_home_screen.dart';

import 'MenuDrawer.dart';

import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> users = [];
  Map<String, dynamic> stats = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var dio = Dio();
      // Replace with your actual deployed URL
      final baseUrl = "https://arclen-mm-backend.hf.space/api/v1";

      // Fetch Stats
      var statsResponse = await dio.get('$baseUrl/dashboard/stats');

      // Fetch Users
      var usersResponse = await dio.get('$baseUrl/users/');

      if (mounted) {
        setState(() {
          stats = statsResponse.data;
          users = usersResponse.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: LayoutBuilder(builder: (BuildContext context, constraint) {
        if (constraint.maxWidth < 600) {
          return mobileHomeScreen(users, stats, isLoading);
        } else {
          return webHomeScreen();
        }
      }),
    );
  }
}
