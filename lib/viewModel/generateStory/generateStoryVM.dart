import 'package:dio/dio.dart';

import '../../services/api/generateStory/generate_story_api.dart';

class GenerateStoryVM {
  GenerateStoryAPI genarateStoryAPI = new GenerateStoryAPI();

  Future<dynamic> getGeneratedStory(String context) async {
    try {
      Response response = await genarateStoryAPI.genarateStory(context);
      var content = response.data["choices"]?[0]["message"]["content"];
      return content;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
