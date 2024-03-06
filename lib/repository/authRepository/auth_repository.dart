// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/saved_progress.dart';

import '../../model/story.dart';
import '../../model/reader.dart';

enum ProgressState {
  DocDoesNotExist,
  Completed,
  IncompleteEmptyChoices,
  IncompleteNonEmptyChoices,
}

class AuthRepository extends GetxController {
  final db = FirebaseFirestore.instance;

  Future<void> createUser(Reader reader) async {
    await db
        .collection("users")
        .doc(reader.uid)
        .set(reader.toJson())
        .whenComplete(() => log("AuthRepository: Data Saved"))
        .catchError((onError) {
      log("AuthRepository: ${onError.toString()}");
    });
  }

  Future<Reader> fetchUser(String email) async {
    final snapshot =
        await db.collection("users").where("email", isEqualTo: email).get();
    final user = snapshot.docs.map((e) => Reader.fromFirestore(e)).single;
    return user;
  }

  Future<void> addIdToPublishedStories(Story story) async {
    final user = FirebaseAuth.instance.currentUser;
    await db
        .collection("users")
        .doc(user?.uid)
        .update({
          'publishedStories': FieldValue.arrayUnion([story.id]),
        })
        .then((_) => log("AuthRepository: Published Stories Updated"))
        .catchError((onError) {
          log("AuthRepository: ${onError.toString()}");
        });
  }

  Future<void> addIdToBookmarkedStories(Story story) async {
    final user = FirebaseAuth.instance.currentUser;
    await db
        .collection("users")
        .doc(user?.uid)
        .update({
          'bookmarkedStories': FieldValue.arrayUnion([story.id]),
        })
        .then((_) => log("AuthRepository: Bookmarked Stories Updated"))
        .catchError((onError) {
          log("AuthRepository: ${onError.toString()}");
        });
  }

  Future<void> createSavedProgress(SavedProgress savedProgress) async {
    final user = FirebaseAuth.instance.currentUser;
    final documentReference = db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .doc(savedProgress.id);

    final documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      await documentReference
          .set(savedProgress.toJson(), SetOptions(merge: true))
          .whenComplete(() => log("AuthRepository: Data Saved"))
          .catchError((onError) {
        log("AuthRepository: ${onError.toString()}");
      });
    }
  }

  Future<void> addChoiceIdToSavedProgress(
      String storyId, int pickedChoiceId) async {
    final user = FirebaseAuth.instance.currentUser;
    await db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .doc(storyId)
        .update({
          'picked_choices': FieldValue.arrayUnion([pickedChoiceId]),
        })
        .then((_) => log("AuthRepository: Choice ID added"))
        .catchError((onError) {
          log("AuthRepository: ${onError.toString()}");
        });
  }

  Future<void> addCompletedToSavedProgress(String storyId) async {
    final user = FirebaseAuth.instance.currentUser;
    await db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .doc(storyId)
        .update({
          'is_completed': true,
        })
        .then((_) => log("AuthRepository: Completed added"))
        .catchError((onError) {
          log("AuthRepository: ${onError.toString()}");
        });
  }

  Future<void> addAchievementToSavedProgress(String storyId) async {
    final user = FirebaseAuth.instance.currentUser;
    await db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .doc(storyId)
        .update({
          'achievement_done': true,
        })
        .then((_) => log("AuthRepository: Achievement added"))
        .catchError((onError) {
          log("AuthRepository: ${onError.toString()}");
        });
  }

  Future<ProgressState> checkSavedProgress(String storyId) async {
    final user = FirebaseAuth.instance.currentUser;
    final documentReference = db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .doc(storyId);

    final documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      return ProgressState.DocDoesNotExist;
    } else {
      final isCompleted = documentSnapshot['is_completed'] ?? false;
      final pickedChoices =
          List<int>.from(documentSnapshot['picked_choices'] ?? []);

      if (isCompleted) {
        return ProgressState.Completed;
      } else if (pickedChoices.isEmpty) {
        return ProgressState.IncompleteEmptyChoices;
      } else {
        return ProgressState.IncompleteNonEmptyChoices;
      }
    }
  }

  Future<SavedProgress?> getSavedProgress(String storyId) async {
    final user = FirebaseAuth.instance.currentUser;
    final documentReference = db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .doc(storyId);

    final documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      return SavedProgress.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<String>> getUncompletedStoryIds() async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await db
        .collection("users")
        .doc(user?.uid)
        .collection("reading_stories")
        .where('is_completed', isEqualTo: false)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> getCompletedStoryIds() async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionReference =
        db.collection("users").doc(user?.uid).collection("reading_stories");

    QuerySnapshot querySnapshot =
        await collectionReference.where('is_completed', isEqualTo: true).get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> getAchievementCompletedStoryIds() async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionReference =
        db.collection("users").doc(user?.uid).collection("reading_stories");

    QuerySnapshot querySnapshot = await collectionReference
        .where('achievement_done', isEqualTo: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }
}
