import 'package:dio/dio.dart';

import '../../network/api_client.dart';

class GenerateStoryAPI {
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
                  "You're a storyteller, follow these rules when generating stories. Story blocks are represented by BlockType.story and choice blocks are represented by BlockType.choice. The story block should contain the story including the question, and then the reader needs to pick a choice from the available choices in choice blocks. Always have multiple choices readers can choose from. Choices should be short. Choice blocks can only connect with story blocks as story blocks with choice blocks. Should have at least 2 branches. All branches should end with a story block. The whole answer should be a single JSON. Use a JSON format like this.\n{\n   \"id\":0,\n   \"type\":\"BlockType.story\",\n   \"text\":\"\",\n   \"nextList\":[\n      {\n         \"id\":1,\n         \"type\":\"BlockType.choice\",\n         \"text\":\"\",\n         \"nextList\":[\n            {\n               \"id\":3,\n               \"type\":\"BlockType.story\",\n               \"text\":\"\",\n               \"nextList\":[\n                  {\n                     \"id\":7,\n                     \"type\":\"BlockType.choice\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":9,\n                           \"type\":\"BlockType.story\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  },\n                  {\n                     \"id\":8,\n                     \"type\":\"BlockType.choice\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":10,\n                           \"type\":\"BlockType.story\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  }\n               ]\n            }\n         ]\n      },\n      {\n         \"id\":2,\n         \"type\":\"BlockType.choice\",\n         \"text\":\"\",\n         \"nextList\":[\n            {\n               \"id\":4,\n               \"type\":\"BlockType.story\",\n               \"text\":\"\",\n               \"nextList\":[\n                  {\n                     \"id\":11,\n                     \"type\":\"BlockType.choice\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":12,\n                           \"type\":\"BlockType.story\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  },\n                  {\n                     \"id\":1,\n                     \"type\":\"BlockType.choice\",\n                     \"text\":\"\",\n                     \"nextList\":[\n                        {\n                           \"id\":2,\n                           \"type\":\"BlockType.story\",\n                           \"text\":\"\",\n                           \"nextList\":[\n                              \n                           ]\n                        }\n                     ]\n                  }\n               ]\n            }\n         ]\n      },\n      {\n         \"id\":5,\n         \"type\":\"BlockType.choice\",\n         \"text\":\"\",\n         \"nextList\":[\n            {\n               \"id\":6,\n               \"type\":\"BlockType.story\",\n               \"text\":\"\",\n               \"nextList\":[\n                  \n               ]\n            }\n         ]\n      }\n   ]\n}"
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
