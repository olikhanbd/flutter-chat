import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/utils/app_constants.dart';

class UserManagement {
  storeNewUser(context, FirebaseUser user, name) {
    Firestore.instance.collection("/users").add(
        {"name": name, "uid": user.uid, "email": user.email}).then((value) {
      //navigate to homepage
      Navigator.pushNamed(context, AppConstants.ROUTEHOME);
    }).catchError((e) {
      print(e);
    });
  }
}
