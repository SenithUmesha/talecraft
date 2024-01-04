import 'package:flutter/material.dart';
import 'package:talecraft/utils/app_colors.dart';

class FinalizeStory extends StatefulWidget {
  const FinalizeStory({super.key});

  @override
  State<FinalizeStory> createState() => _FinalizeStoryState();
}

class _FinalizeStoryState extends State<FinalizeStory> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white, child: SafeArea(child: Scaffold()));
  }
}
