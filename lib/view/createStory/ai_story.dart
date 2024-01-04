import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/custom_app_bar.dart';

class AiStory extends StatelessWidget {
  const AiStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        child: SafeArea(
            child: Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.aiGenaratedStory,
          ),
        )));
  }
}
