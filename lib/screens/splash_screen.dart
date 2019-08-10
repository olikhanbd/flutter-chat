import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
import 'package:flutter_chat/screens/flutter_chat_home.dart';
import 'package:flutter_chat/services/shared_prefs_manager.dart';
import 'package:flutter_chat/utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String appLogo = "images/chat.png";

  @override
  void initState() {
    super.initState();
    print(AppConstants.TAG + " splash");

    checkLoginStatus().then((isLoggedIn) {
      print(AppConstants.TAG + isLoggedIn.toString());
      if (isLoggedIn) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return FlutterChatHome();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return AuthScreen();
        }));
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.lightGreen, Colors.green])),
      child: Center(
        child: Image.asset(appLogo),
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPrefsManager spManager = SharedPrefsManager();
    User user = await spManager.getUser();
    print("user " + user.toString());
    if (user != null)
      return true;
    else
      return false;
  }
}
