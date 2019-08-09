import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/app_constants.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
import 'dart:async';

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
    
    Future.delayed(
        Duration(seconds: 1),(){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
         return AuthScreen();
       }));
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
}
