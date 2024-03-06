import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import 'app_images.dart';

class NoItemsOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: width * 0.4,
            width: width * 0.4,
            child: Lottie.asset(
              AppImages.empty,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
