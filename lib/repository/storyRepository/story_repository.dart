// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';
import 'package:talecraft/repository/authRepository/auth_repository.dart';

class StoryRepository extends GetxController {
  final db = FirebaseFirestore.instance;

  createStory(Story story) async {
    story.id = db.collection("stories").doc().id;

    await db
        .collection("stories")
        .doc(story.id)
        .set(story.toJson())
        .whenComplete(() async {
      await Get.put(AuthRepository()).addIdToPublishedStories(story);
      log("StoryRepository: Data Saved");
    }).catchError((onError) {
      log("StoryRepository: ${onError.toString()}");
    });
  }

  Future<String> uploadImage(String path) async {
    final file = File(path);
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final uploadPath = "story_covers/story_cover_${timestamp}.jpg";

    final ref = FirebaseStorage.instance.ref().child(uploadPath);
    UploadTask uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
