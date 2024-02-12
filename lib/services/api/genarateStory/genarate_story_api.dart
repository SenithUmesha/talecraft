import 'package:dio/dio.dart';

import '../../network/api_client.dart';

class GenarateStoryAPI {
  final Dio apiClient = ApiClient().client;

  Future<Response> genarateStory(String context) async {
    try {
      Response response = await apiClient.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer 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',
          },
        ),
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You're a storyteller, follow these rules when generating stories.\n- always at least 2 choice blocks should be attached to a story block\n- all branches should end with a story block\n- should have at least 2 branches\n- provide a small description for shortDescription for both story and choice blocks\n- the whole answer should be a single JSON\n- use a JSON format like this\n{\n   \"id\":0,\n   \"type\":\"BlockType.story\",\n   \"shortDescription\":\"\",\n   \"text\":\"\",\n   \"nextList\":[\n      {\n         \"id\":1,\n         \"type\":\"BlockType.choice\",\n         \"shortDescription\":\"\",\n         \"text\":\"\",\n         \"nextList\":[\n            {\n               \"id\":3,\n               \"type\":\"BlockType.story\",\n               \"shortDescription\":\"\",\n               \"text\":\"\",\n               \"nextList\":[\n                  {\n                     \"id\":7,\n                     \"type\":\"BlockType.choice\",\n                     \"shortDescription\":\"\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":9,\n                           \"type\":\"BlockType.story\",\n                           \"shortDescription\":\"\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  },\n                  {\n                     \"id\":8,\n                     \"type\":\"BlockType.choice\",\n                     \"shortDescription\":\"\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":10,\n                           \"type\":\"BlockType.story\",\n                           \"shortDescription\":\"\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  }\n               ]\n            }\n         ]\n      },\n      {\n         \"id\":2,\n         \"type\":\"BlockType.choice\",\n         \"shortDescription\":\"\",\n         \"text\":\"\",\n         \"nextList\":[\n            {\n               \"id\":4,\n               \"type\":\"BlockType.story\",\n               \"shortDescription\":\"\",\n               \"text\":\"\",\n               \"nextList\":[\n                  {\n                     \"id\":11,\n                     \"type\":\"BlockType.choice\",\n                     \"shortDescription\":\"\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":12,\n                           \"type\":\"BlockType.story\",\n                           \"shortDescription\":\"\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  },\n                  {\n                     \"id\":1,\n                     \"type\":\"BlockType.choice\",\n                     \"shortDescription\":\"\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":2,\n                           \"type\":\"BlockType.story\",\n                           \"shortDescription\":\"\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  }\n               ]\n            }\n         ]\n      },\n      {\n         \"id\":5,\n         \"type\":\"BlockType.choice\",\n         \"shortDescription\":\"\",\n         \"text\":\"\",\n         \"nextList\":[\n            {\n               \"id\":6,\n               \"type\":\"BlockType.story\",\n               \"shortDescription\":\"\",\n               \"text\":\"\",\n               \"nextList\":[\n                  \n               ]\n            }\n         ]\n      }\n   ]\n}"
            },
            {
              "role": "user",
              "content": "Generate a story for this context, ${context}"
            }
          ],
          "temperature": 1,
          "max_tokens": 2000,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0,
        },
      );

      return response;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
