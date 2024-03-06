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

  Future<List<Story>> getPublishedStories() async {
    final user = FirebaseAuth.instance.currentUser;
    final reader = await Get.put(AuthRepository()).fetchUser(user!.email!);

    try {
      CollectionReference storiesCollection =
          FirebaseFirestore.instance.collection('stories');
      QuerySnapshot querySnapshot = await storiesCollection
          .where('id', whereIn: reader.publishedStories)
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

  Future<List<Story>> getMoreStories(String authorId) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection("stories")
          .where("author_id", isEqualTo: authorId)
          .get();

      List<Story> stories = querySnapshot.docs.map((docSnapshot) {
        return Story.fromFirestore(
            docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();

      return stories;
    } catch (e) {
      print("StoryRepository: $e");
      return [];
    }
  }

  Future<List<Story>> getReadingStories() async {
    final list = await Get.put(AuthRepository()).getUncompletedStoryIds();

    try {
      CollectionReference storiesCollection =
          FirebaseFirestore.instance.collection('stories');
      QuerySnapshot querySnapshot =
          await storiesCollection.where('id', whereIn: list).get();
      return querySnapshot.docs
          .map((doc) => Story.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      log("StoryRepository: ${e.toString()}");
      return [];
    }
  }

  Future<void> updateStoryRatings(double newRating, Story story) async {
    await db
        .collection("stories")
        .doc(story.id)
        .update({'rating': newRating, 'no_of_ratings': story.noOfRatings! + 1})
        .then((_) => log("StoryRepository: Rated"))
        .catchError((onError) {
          log("StoryRepository: ${onError.toString()}");
        });
  }

  Future<Story?> getCurrentStory(String storyId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await db.collection("stories").doc(storyId).get();

      if (snapshot.exists) {
        return Story.fromFirestore(snapshot);
      } else {
        return null;
      }
    } catch (e) {
      log("StoryRepository: $e");
      return null;
    }
  }
}
