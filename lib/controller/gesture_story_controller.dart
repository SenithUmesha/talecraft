import 'dart:async';
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
import 'package:tflite/tflite.dart';

import '../main.dart';
import '../model/block.dart';
import '../repository/authRepository/auth_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

enum TtsState { playing, stopped, paused, ended, yetToPlay }

enum CameraState { recording, done }

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
  String answer = "";
  CameraImage? cameraImage;

  TtsState ttsState = TtsState.yetToPlay;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isEnded => ttsState == TtsState.ended;
  get isyetToPlay => ttsState == TtsState.yetToPlay;

  CameraState cameraState = CameraState.done;
  get isRecording => cameraState == CameraState.recording;
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
    loadmodel();
    flutterTts = FlutterTts();
    initTts();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    startStoryProcess();
  }

  loadmodel() async {
    Tflite.loadModel(
      model: "assets/model/detect.tflite",
      labels: "assets/model/labels.txt",
    );
  }

  initCamera() {
    cameraController.initialize().then((_) {
      if (!Get.context!.mounted) {
        return;
      }
      cameraController.startImageStream(
        (image) => {
          if (true)
            {
              cameraImage = image,
              applyModelOnImages(),
            }
        },
      );
      update();
    }).catchError((Object e) async {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            await [Permission.camera].request();
            break;
          default:
            break;
        }
      }
    });
  }

  applyModelOnImages() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map(
            (plane) {
              return plane.bytes;
            },
          ).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 3,
          threshold: 0.1,
          asynch: true);

      answer = '';

      predictions!.forEach(
        (prediction) {
          answer +=
              prediction['label'].toString().substring(0, 1).toUpperCase() +
                  prediction['label'].toString().substring(1) +
                  " " +
                  (prediction['confidence'] as double).toStringAsFixed(3) +
                  '\n';
        },
      );

      answer = answer;
      update();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
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
          if (!cameraController.value.isInitialized &&
              await checkCameraPermission()) {
            record();
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

  @override
  Future<void> onClose() async {
    flutterTts.stop();
    await Tflite.close();
    cameraController.dispose();
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

  record() {
    cameraState = CameraState.recording;
    update();

    if (!cameraController.value.isInitialized) {
      initCamera();
    }

    Timer(const Duration(seconds: 2), () {
      stopRecord();
      resumeStory(0);
    });
  }

  stopRecord() {
    cameraState = CameraState.done;
    cameraController.dispose();
    update();
  }
}
