import 'dart:async';
import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/saved_progress.dart';
import 'package:talecraft/model/story.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../model/block.dart';
import '../repository/authRepository/auth_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

enum TtsState { playing, stopped, paused, ended, yetToPlay }

class ReadStoryController extends GetxController {
  bool isLoading = false;
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
  TtsState ttsState = TtsState.yetToPlay;
  bool isListeningMode = false;
  List<GraphNode>? currentChoiceList;
  late stt.SpeechToText speech;
  bool isListening = false;
  bool canRetry = false;
  final authRepo = Get.put(AuthRepository());
  ProgressState status = ProgressState.DocDoesNotExist;
  SavedProgress? progress;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isEnded => ttsState == TtsState.ended;
  get isyetToPlay => ttsState == TtsState.yetToPlay;

  @override
  void onInit() {
    super.onInit();

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, text: AppStrings.addStory),
      isRoot: true,
    );

    story = Get.arguments[0];
    isListeningMode = Get.arguments[1];

    jsonToGraph(root, story.storyJson!);
    isListeningMode ? initTts() : (flutterTts = FlutterTts());
    speech = stt.SpeechToText();

    startStoryProcess();
  }

  Future<void> startStoryProcess() async {
    status = await authRepo.checkSavedProgress(story.id!);
    progress = await authRepo.getSavedProgress(story.id!);
    addStoryBlock(root);
    createSavedProgress();
  }

  Future<void> createSavedProgress() async {
    await authRepo.createSavedProgress(
        SavedProgress(id: story.id, pickedChoices: [], isCompleted: false));
  }

  Future<void> startListening() async {
    if (!isListening) {
      bool available = await speech.initialize(
        finalTimeout: Duration(minutes: 5),
        onStatus: (val) {
          log('STT Status: $val');
          if (val.toString() == "notListening" ||
              val.toString() == "done" && isListening) {
            stopListening();
          }
        },
        onError: (val) {
          log('STT Status: $val');
          stopListening();
        },
      );
      if (available) {
        isListening = true;
        canRetry = false;
        update();

        speech.listen(
          listenOptions: stt.SpeechListenOptions(enableHapticFeedback: true),
          listenFor: Duration(minutes: 5),
          onResult: (result) {
            String spokenWord = result.recognizedWords;
            List<String> wordList = generateWordList(currentChoiceList!.length);

            if (spokenWord != "") {
              log('Spoken Words: $spokenWord');

              String matchingPortion = wordList.firstWhere(
                (word) => spokenWord
                    .toLowerCase()
                    .split(' ')
                    .any((spokenWordPart) => spokenWordPart.contains(word)),
                orElse: () => '',
              );

              if (matchingPortion.isNotEmpty &&
                  wordToNumber(matchingPortion) != 0) {
                log('Picked choice: $matchingPortion - ${wordToNumber(matchingPortion)}');
                speech.stop();
                isListening = false;
                update();
                resumeStory(wordToNumber(matchingPortion) - 1);
              } else {
                stopListening();
              }
            } else {
              stopListening();
            }
          },
        );
      } else {
        AppWidgets.showSnackBar(
            AppStrings.error, AppStrings.speechRecognitionNotAvailable);
        stopListening();
      }
    } else {
      stopListening();
    }
  }

  void stopListening() {
    speech.stop();
    isListening = false;
    canRetry = true;
    update();
  }

  List<String> generateWordList(int length) {
    List<String> wordList = [];
    for (int i = 1; i <= length; i++) {
      wordList.add(i.toString());
      wordList.addAll(numberToWord(i));
    }
    return wordList;
  }

  List<String> numberToWord(int number) {
    switch (number) {
      case 1:
        return ['one'];
      case 2:
        return ['two', 'to'];
      case 3:
        return ['three'];
      case 4:
        return ['four', 'for'];
      case 5:
        return ['five'];
      case 6:
        return ['six'];
      case 7:
        return ['seven'];
      case 8:
        return ['eight'];
      case 9:
        return ['nine'];
      case 10:
        return ['ten'];
      default:
        return [''];
    }
  }

  int wordToNumber(String word) {
    switch (word.toLowerCase()) {
      case 'one':
        return 1;
      case 'two':
      case 'to':
        return 2;
      case 'three':
        return 3;
      case 'four':
      case 'for':
        return 4;
      case 'five':
        return 5;
      case 'six':
        return 6;
      case 'seven':
        return 7;
      case 'eight':
        return 8;
      case 'nine':
        return 9;
      case 'ten':
        return 10;
      default:
        return 0;
    }
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
      update();
      log("TTS State: " + ttsState.toString());
    });

    flutterTts.setCompletionHandler(() async {
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

        if (progress != null && hasMatchingChoices(currentChoiceList!) != -1) {
          int id = hasMatchingChoices(currentChoiceList!);
          resumeStory(id);
        } else {
          if (await speech.hasPermission) {
            startListening();
          } else {
            AppWidgets.showSnackBar(
                AppStrings.error, AppStrings.permissionNotGranted);
            stopListening();
          }
        }
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

    flutterTts.setContinueHandler(() {
      ttsState = TtsState.playing;
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

      if (list!.length > 1) {
        for (var i = 0; i < list.length; i++) {
          choiceText += "Choice ${i + 1} - ";
          choiceText += (list[i].data as Block).text;
          if (i != list.length - 1) choiceText += " or ";
        }
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
      if (isChoice && !list[0].prevList[0].prevList.isEmpty) {
        speak();
      }
    }
  }

  Future<void> resumeStory(int index) async {
    var width = MediaQuery.of(Get.context!).size.width;
    List<GraphNode> nextList = currentChoiceList!;

    if (progress != null && hasMatchingChoices(nextList) != -1) {
      int id = hasMatchingChoices(nextList);

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
            text: (nextList[id].data as Block).text,
            alignment: TextAlign.center,
            size: 16,
            color: AppColors.black,
            weight: FontWeight.w500,
          ),
        ),
      ));

      addStoryBlock(nextList[id].nextList[0] as GraphNode<Block>);
    } else {
      await authRepo.addChoiceIdToSavedProgress(
          story.id!, (nextList[index].data as Block).id);
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
          (nextList[index].nextList[0].data as Block).id ==
              story.achievementEndingId) {
        confettiController.play();

        Timer(const Duration(seconds: 1), () {
          confettiController.stop();
          AppWidgets.showToast(AppStrings.secretEndingAchieved);
        });
      }
      addStoryBlock(nextList[index].nextList[0] as GraphNode<Block>);
    }
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

  Future<void> addStoryBlock(GraphNode<Block> block) async {
    var width = MediaQuery.of(Get.context!).size.width;
    widgetList.add(AppWidgets.regularText(
        text: block.data!.text,
        size: 17.0,
        alignment: TextAlign.justify,
        color: AppColors.black,
        weight: FontWeight.w500,
        height: 2.0));

    isListeningMode ? setReadText(block, false) : null;

    if (!block.nextList.isEmpty) {
      addChoiceBlock(block.nextList);
    } else {
      await authRepo.addCompletedToSavedProgress(story.id!);

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

  int hasMatchingChoices(List<GraphNode> nextList) {
    for (int i = 0; i < progress!.pickedChoices!.length; i++) {
      int pickedChoiceId = progress!.pickedChoices![i];
      for (int j = 0; j < nextList.length; j++) {
        if ((nextList[j].data as Block).id == pickedChoiceId) {
          return j;
        }
      }
    }
    return -1;
  }

  void addChoiceBlock(List<GraphNode> nextList) {
    var width = MediaQuery.of(Get.context!).size.width;

    if (progress != null && hasMatchingChoices(nextList) != -1) {
      int id = hasMatchingChoices(nextList);
      isListeningMode ? setReadText([nextList[id]], true) : null;

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
            text: (nextList[id].data as Block).text,
            alignment: TextAlign.center,
            size: 16,
            color: AppColors.black,
            weight: FontWeight.w500,
          ),
        ),
      ));

      addStoryBlock(nextList[id].nextList[0] as GraphNode<Block>);
    } else {
      isListeningMode ? setReadText(nextList, true) : null;

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
                onTap: isListeningMode
                    ? null
                    : () async {
                        await authRepo.addChoiceIdToSavedProgress(
                            story.id!, (nextList[index].data as Block).id);
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
                            (nextList[index].nextList[0].data as Block).id ==
                                story.achievementEndingId) {
                          confettiController.play();

                          Timer(const Duration(seconds: 1), () {
                            confettiController.stop();
                            AppWidgets.showToast(
                                AppStrings.secretEndingAchieved);
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
                    color: isListeningMode
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

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
