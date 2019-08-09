import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/flutter_chat_home.dart';
import 'package:flutter_chat/screens/splash_screen.dart';
import 'package:flutter_chat/utils/app_constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case AppConstants.LAUNCHER:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppConstants.ROUTEHOME:
        return MaterialPageRoute(builder: (_) => FlutterChatHome());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
