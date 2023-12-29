import 'package:get/get.dart';

class StoryboardController extends GetxController {
  final List blocks = [];

  void updateBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String tile = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, tile);
    update();
  }
}
