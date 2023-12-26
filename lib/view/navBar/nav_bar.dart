import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/view/bookmarks/bookmarks.dart';
import 'package:talecraft/view/home/home.dart';
import 'package:talecraft/view/profile/profile.dart';
import 'package:talecraft/view/search/search.dart';

import '../../controller/nav_bar_controller.dart';
import '../createStory/create_story.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(
        init: NavBarController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: controller.bottomNavIndex == 0
                    ? const Home()
                    : controller.bottomNavIndex == 1
                        ? const Bookmarks()
                        : controller.bottomNavIndex == 2
                            ? const Search()
                            : controller.bottomNavIndex == 3
                                ? const Profile()
                                : const CreateStory()),
            floatingActionButton: FloatingActionButton(
              backgroundColor: controller.bottomNavIndex == 4
                  ? AppColors.black
                  : AppColors.red,
              child: Icon(
                Icons.add_rounded,
                color: AppColors.white,
              ),
              onPressed: () {
                controller.updateIndex(4);
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
                icons: controller.iconList,
                activeIndex: controller.bottomNavIndex,
                gapLocation: GapLocation.center,
                inactiveColor: AppColors.grey,
                activeColor: AppColors.black,
                notchSmoothness: NotchSmoothness.softEdge,
                shadow: BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 12,
                  spreadRadius: 0.5,
                  color: AppColors.grey.withOpacity(0.3),
                ),
                onTap: (index) => controller.updateIndex(index)),
          );
        });
  }
}
