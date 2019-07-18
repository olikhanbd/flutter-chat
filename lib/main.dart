import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/flutter_chat_home.dart';
import 'package:flutter_chat/screens/auth_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Chat",
      theme: ThemeData(
        primaryColor: Color(0xff075e54),
        accentColor: Color(0xff25d366)
      ),
      home: AuthScreen(),
    );
  }
}
