// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/story.dart';
import '../../model/reader.dart';

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
}
