import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app/core/Server.dart';

class SearchProfileController extends GetxController {
  var searchResults = <dynamic>[].obs;
  var isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  void performSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading(true);
      Server server = Server();
      var allUsers = await server.api!.getUsers();

      searchResults.value = allUsers.where((u) {
        String name = (u['name'] ?? "${u['firstName']} ${u['lastName']}")
            .toString()
            .toLowerCase();
        String id = u['_id'].toString().toLowerCase();
        String search = query.toLowerCase();
        return name.contains(search) || id.contains(search);
      }).toList();
    } catch (e) {
      print("Search error: $e");
    } finally {
      isLoading(false);
    }
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchProfileController());
  }
}
