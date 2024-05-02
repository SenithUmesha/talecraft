import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talecraft/model/saved_progress.dart';
import 'package:talecraft/model/story.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/block.dart';
import '../repository/authRepository/auth_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

enum TtsState { playing, stopped, paused, ended, yetToPlay }

enum CameraState { recording, done, sending }

class GestureStoryController extends FullLifeCycleController {
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
  List<GraphNode>? currentChoiceList;
  final authRepo = Get.put(AuthRepository());
  ProgressState status = ProgressState.DocDoesNotExist;
  SavedProgress? progress;
  late CameraController cameraController;

  TtsState ttsState = TtsState.yetToPlay;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isEnded => ttsState == TtsState.ended;
  get isyetToPlay => ttsState == TtsState.yetToPlay;

  CameraState cameraState = CameraState.done;
  get isRecording => cameraState == CameraState.recording;
  get isSending => cameraState == CameraState.sending;
  get isDone => cameraState == CameraState.done;

  @override
  void onInit() {
    super.onInit();
    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, text: AppStrings.addStory),
      isRoot: true,
    );

    story = Get.arguments[0];
    jsonToGraph(root, story.storyJson!);
    flutterTts = FlutterTts();
    initTts();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    startStoryProcess();
  }

  Future<void> initCamera() async {
    if (!cameraController.value.isInitialized) {
      await cameraController.initialize().then((value) {
        cameraState = CameraState.recording;
        update();
      });
    } else {
      cameraState = CameraState.recording;
      update();
    }
  }

  Future<void> captureAndSendImage() async {
    await initCamera();

    try {
      if (!cameraController.value.isTakingPicture) {
        XFile imageFile = await cameraController.takePicture();
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        Map<String, String> requestBody = {'image': base64Image};
        String jsonBody = jsonEncode(requestBody);

        var response = await http.post(
          Uri.parse('http://192.168.1.100:5000/process_image'),
          headers: {'Content-Type': 'application/json'},
          body: jsonBody,
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          String gesture = data['gesture'];
          int? number = int.tryParse(gesture);
          log('Image successfully processed! ${number.toString()}');

          if (number! <= currentChoiceList!.length) {
            cameraState = CameraState.done;
            update();
            showConfirmationDialog(number - 1);
          } else {
            AppWidgets.showToast(AppStrings.invalidChoiceNo);
            await Future.delayed(Duration(milliseconds: 500));
            captureAndSendImage();
          }
        } else {
          log('Failed to process image: ${response.statusCode}');
          await Future.delayed(Duration(seconds: 1));
          captureAndSendImage();
        }
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        captureAndSendImage();
      }
    } catch (e) {
      log('Error capturing or sending image: $e');
      await Future.delayed(Duration(seconds: 1));
      captureAndSendImage();
    }
  }

  showConfirmationDialog(int number) {
    int countdown = 5;
    bool isCountdownCompleted = false;

    void startCountdown(BuildContext context, StateSetter setState) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (countdown != 0) {
          if (context.mounted) {
            setState(() {
              countdown--;
            });
          }
        } else {
          timer.cancel();
          if (!isCountdownCompleted) {
            isCountdownCompleted = true;
            Get.back();
            resumeStory(number);
          }
        }
      });
    }

    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          startCountdown(context, setState);

          return AlertDialog(
            title: AppWidgets.regularText(
              text: AppStrings.confirmation,
              size: 20.0,
              color: AppColors.black,
              weight: FontWeight.w600,
            ),
            content: AppWidgets.regularText(
              text: "Was it ${number + 1} you picked?",
              size: 16.0,
              color: AppColors.black,
              weight: FontWeight.w400,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (!isCountdownCompleted) {
                    cameraState = CameraState.recording;
                    update();
                    Get.back();
                    captureAndSendImage();
                  }
                },
                child: AppWidgets.regularText(
                  text: AppStrings.no,
                  size: 16.0,
                  color: AppColors.black,
                  weight: FontWeight.w400,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.black)),
                onPressed: () {
                  if (!isCountdownCompleted) {
                    isCountdownCompleted = true;
                    Get.back();
                    resumeStory(number);
                  }
                },
                child: AppWidgets.regularText(
                  text: 'Yes ($countdown)',
                  size: 16.0,
                  color: AppColors.white,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Future<void> onClose() async {
    await flutterTts.stop();
    await cameraController.dispose();
    super.onClose();
  }

  Future<bool> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      Map<Permission, PermissionStatus> statusMap =
          await [Permission.camera].request();
      if (statusMap[Permission.camera] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void rateStory() {
    Timer(const Duration(seconds: 1), () {
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (context) => AppWidgets.showRatingDialog(story),
      );
    });
  }

  Future<void> startStoryProcess() async {
    status = await authRepo.checkSavedProgress(story.id!);
    progress = await authRepo.getSavedProgress(story.id!);
    addStoryBlock(root);
    status == ProgressState.DocDoesNotExist ? createSaveProgress() : null;
    log("Progress State: ${status.toString()}");
  }

  Future<void> createSaveProgress() async {
    await authRepo.createSavedProgress(SavedProgress(
        id: story.id,
        pickedChoices: [],
        isCompleted: false,
        achievementDone: false));
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
        await cameraController.dispose();
        log("TTS State: " + ttsState.toString());
      } else {
        ttsState = TtsState.stopped;
        readText = "";
        update();
        log("TTS State: " + ttsState.toString());
        int id = progress != null ? hasMatchingChoices(currentChoiceList!) : -1;

        if (progress != null && id != -1) {
          resumeStory(id);
        } else {
          if (await checkCameraPermission()) {
            await captureAndSendImage();
          } else {
            AppWidgets.showSnackBar(
                AppStrings.error, AppStrings.permissionNotGranted);
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

    if (!isChoice &&
        list.nextList.isEmpty &&
        status != ProgressState.Completed &&
        status != ProgressState.IncompleteNonEmptyChoices) {
      // End of the story
      speak();
    } else {
      if (isChoice &&
          !list[0].prevList[0].prevList.isEmpty &&
          status != ProgressState.Completed &&
          status != ProgressState.IncompleteNonEmptyChoices) {
        // Not the first choice block of the story
        speak();
      }
    }
  }

  Future<void> resumeStory(int index) async {
    var width = MediaQuery.of(Get.context!).size.width;
    List<GraphNode> nextList = currentChoiceList!;
    int id = progress != null ? hasMatchingChoices(nextList) : -1;

    if (progress != null && id != -1) {
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
        await authRepo.addAchievementToSavedProgress(story.id!);

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

    setReadText(block, false);

    if (!block.nextList.isEmpty) {
      addChoiceBlock(block.nextList);
    } else {
      if (status != ProgressState.Completed) {
        await authRepo.addCompletedToSavedProgress(story.id!);
        rateStory();
      }

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
    int id = progress != null ? hasMatchingChoices(nextList) : -1;

    if (progress != null && id != -1) {
      setReadText([nextList[id]], true);

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
      setReadText(nextList, true);

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
              return Container(
                width: width,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.black.withOpacity(0.5),
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
