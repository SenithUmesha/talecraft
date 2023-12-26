import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarController extends GetxController with GetTickerProviderStateMixin {
  int bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.bookmark_rounded,
    Icons.search_rounded,
    Icons.person_rounded,
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void updateIndex(int index) {
    bottomNavIndex = index;
    update();
  }
}
