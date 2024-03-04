// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/reader.dart';

class AuthRepository extends GetxController {
  final db = FirebaseFirestore.instance;

  createUser(Reader reader) async {
    await db
        .collection("users")
        .add(reader.toJson())
        .whenComplete(() => log("AuthRepository: Data Saved"))
        .catchError((onError) {
      log("AuthRepository: ${onError.toString()}");
    });
  }

  fetchUser(String email) async {
    final snapshot =
        await db.collection("users").where("email", isEqualTo: email).get();
    final user = snapshot.docs.map((e) => Reader.fromFirestore(e)).single;
    return user;
  }
}
