import 'dart:async';
import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/Story.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

enum TtsState { playing, stopped, paused, ended }

class ReadStoryController extends GetxController {
  final scrollController = ScrollController();
  List<Widget> widgetList = [];
  late GraphNode<Block> root;
  late Story story;
  final confettiController = ConfettiController();
  String readText = "";
  late FlutterTts flutterTts;
  double volume = 0.7;
  double pitch = 1.0;
  double rate = 0.4;
  TtsState ttsState = TtsState.stopped;
  bool isListening = false;
  List<GraphNode>? currentChoiceList;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isEnded => ttsState == TtsState.ended;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {}
    });

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, text: AppStrings.addStory),
      isRoot: true,
    );

    story = Get.arguments[0];
    isListening = Get.arguments[1];

    jsonToGraph(root, story.storyJson!);
    isListening ? initTts() : (flutterTts = FlutterTts());
    addStoryBlock(root);
    isListening ? speak() : null;
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
      update();
      log("TTS State: " + ttsState.toString());
    });

    flutterTts.setCompletionHandler(() {
      if (currentChoiceList!.isEmpty) {
        ttsState = TtsState.ended;
        readText = "";
        update();
        log("TTS State: " + ttsState.toString());
      } else {
        ttsState = TtsState.stopped;
        readText = "";
        update();
        log("TTS State: " + ttsState.toString());

        Timer(const Duration(seconds: 2), () {
          resumeStory(0);
        });
      }
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
      update();
      log("TTS State: " + ttsState.toString());
    });

    flutterTts.setPauseHandler(() {
      ttsState = TtsState.paused;
      update();
      log("TTS State: " + ttsState.toString());
    });

    flutterTts.setErrorHandler((msg) {
      log("TTS Error: $msg");
      ttsState = TtsState.stopped;
      update();
      log("TTS State: " + ttsState.toString());
    });
  }

  Future speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (readText.isNotEmpty) {
      await flutterTts.speak(readText);
    }
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) ttsState = TtsState.paused;
    update();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  void setReadText(dynamic list, bool isChoice) {
    if (isChoice) {
      String choiceText = "";
      currentChoiceList = list;

      for (var i = 0; i < list.length; i++) {
        choiceText += "Choice ${i + 1} - ";
        choiceText += (list[i].data as Block).text;
        if (i != list.length - 1) choiceText += " or ";
      }

      readText += choiceText;
    } else {
      readText += list.data!.text;

      if (list.nextList.isEmpty) {
        readText += " The End.";
        currentChoiceList = [];
      }
    }
    update();

    if (!isChoice && list.nextList.isEmpty) {
      speak();
    } else {
      speak();
    }
  }

  void resumeStory(int index) {
    var width = MediaQuery.of(Get.context!).size.width;
    List<GraphNode> nextList = currentChoiceList!;

    (nextList[index].data as Block).updateChoice(true);
    widgetList.removeLast();
    widgetList.add(Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.black.withOpacity(0.1),
      ),
      child: Center(
        child: AppWidgets.regularText(
          text: (nextList[index].data as Block).text,
          alignment: TextAlign.center,
          size: 16,
          color: AppColors.black,
          weight: FontWeight.w500,
        ),
      ),
    ));
    if (nextList[index].nextList[0].nextList.isEmpty &&
        (nextList[index].data as Block).id == story.achievementEndingId) {
      confettiController.play();

      Timer(const Duration(seconds: 1), () {
        confettiController.stop();
        AppWidgets.showToast(AppStrings.secretEndingAchieved);
      });
    }
    addStoryBlock(nextList[index].nextList[0] as GraphNode<Block>);
  }

  void jsonToGraph(GraphNode<Block> block, Map<String, dynamic> json) {
    block.data = Block.fromJson(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        jsonToGraph(nextNode, nextNodeJson as Map<String, dynamic>);
        block.addNext(nextNode);
      }
    }
  }

  void addStoryBlock(GraphNode<Block> block) {
    var width = MediaQuery.of(Get.context!).size.width;
    widgetList.add(AppWidgets.regularText(
        text: block.data!.text,
        size: 17.0,
        alignment: TextAlign.justify,
        color: AppColors.black,
        weight: FontWeight.w500,
        height: 2.0));

    isListening ? setReadText(block, false) : null;

    if (!block.nextList.isEmpty) {
      addChoiceBlock(block.nextList);
    } else {
      widgetList.add(Container(
        width: width,
        margin: const EdgeInsets.only(top: 30, bottom: 15),
        child: Center(
          child: AppWidgets.regularText(
            text: AppStrings.theEnd,
            alignment: TextAlign.center,
            size: 14,
            color: AppColors.black,
            weight: FontWeight.w600,
          ),
        ),
      ));
    }

    update();
    scrollDown();
  }

  void addChoiceBlock(List<GraphNode> nextList) {
    var width = MediaQuery.of(Get.context!).size.width;

    isListening ? setReadText(nextList, true) : null;

    widgetList.add(
      Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.black.withOpacity(0.1),
        ),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          itemCount: nextList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: isListening
                  ? null
                  : () {
                      (nextList[index].data as Block).updateChoice(true);
                      widgetList.removeLast();
                      widgetList.add(Container(
                        width: width,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.black.withOpacity(0.1),
                        ),
                        child: Center(
                          child: AppWidgets.regularText(
                            text: (nextList[index].data as Block).text,
                            alignment: TextAlign.center,
                            size: 16,
                            color: AppColors.black,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ));
                      if (nextList[index].nextList[0].nextList.isEmpty &&
                          (nextList[index].data as Block).id ==
                              story.achievementEndingId) {
                        confettiController.play();

                        Timer(const Duration(seconds: 1), () {
                          confettiController.stop();
                          AppWidgets.showToast(AppStrings.secretEndingAchieved);
                        });
                      }
                      addStoryBlock(
                          nextList[index].nextList[0] as GraphNode<Block>);
                    },
              child: Container(
                width: width,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isListening
                      ? AppColors.black.withOpacity(0.5)
                      : AppColors.black,
                ),
                child: Center(
                  child: AppWidgets.regularText(
                    text: (nextList[index].data as Block).text,
                    alignment: TextAlign.center,
                    size: 16,
                    color: AppColors.white,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients)
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
    });
  }
}
