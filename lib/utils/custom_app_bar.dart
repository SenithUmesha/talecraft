import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'app_widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool? cantGoBack;

  const CustomAppBar({super.key, this.title, this.actions, this.cantGoBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.white,
      elevation: 4,
      leading: cantGoBack != null && cantGoBack!
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
      actions: actions,
      title: title == null
          ? null
          : AppWidgets.regularText(
              text: title,
              size: 20,
              color: AppColors.black,
              weight: FontWeight.w600,
            ),
      centerTitle: true,
    );
  }
}
