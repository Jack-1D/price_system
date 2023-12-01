import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

class FireDB {
  Future<String?> addUser(
      {required String gmail,
      required String username,
      required String password,
      required String name,
      required String company,
      required String character}) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
      CollectionReference userDb =
          FirebaseFirestore.instance.collection("user");
      await userDb
          .doc(username)
          .set({'username': username, 'gmail': gmail, 'password': password, 'name': name, 'company': company, 'character': character});
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getUser(String username) async {
    try {
      await Firebase.initializeApp();
      CollectionReference userDb =
          FirebaseFirestore.instance.collection("user");
      final snapshot = await userDb.doc(username).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['gmail'];
    } catch (e) {
      return "Error fetch user";
    }
  }
}
