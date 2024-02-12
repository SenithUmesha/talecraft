import 'package:dio/dio.dart';

import '../../services/api/genarateStory/genarate_story_api.dart';

class GenarateStoryVM {
  GenarateStoryAPI genarateStoryAPI = new GenarateStoryAPI();

  Future<dynamic> getGenaratedStory(String context) async {
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
