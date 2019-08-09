import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/screens/flutter_chat_home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagement {
  storeNewUser(context, FirebaseUser user, name) {
    Firestore.instance.collection("/users").add(
        {"name": name, "uid": user.uid, "email": user.email}).then((value) {
      //navigate to homepage
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterChatHome();
      }));
    }).catchError((e) {
      print(e);
    });
  }
}
