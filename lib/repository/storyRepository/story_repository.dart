import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';
import 'package:talecraft/repository/authRepository/auth_repository.dart';

class StoryRepository extends GetxController {
  final db = FirebaseFirestore.instance;

  Future<void> createStory(Story story) async {
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

  Future<dynamic> getStories(String type) async {
    final user = FirebaseAuth.instance.currentUser;
    final reader = await Get.put(AuthRepository()).fetchUser(user!.email!);

    try {
      CollectionReference storiesCollection =
          FirebaseFirestore.instance.collection('stories');
      QuerySnapshot querySnapshot = await storiesCollection
          .where('id',
              whereIn: type == "publish"
                  ? reader.publishedStories
                  : reader.readingStories)
          .get();
      return querySnapshot.docs
          .map((doc) => Story.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      log("StoryRepository: ${e.toString()}");
      return [];
    }
  }
}
