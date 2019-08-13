import 'package:flutter/material.dart';
import 'package:flutter_chat/services/route_generator.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Chat",
      theme: ThemeData(
          primaryColor: Colors.green, accentColor: Color(0xffffffff)),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
