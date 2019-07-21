import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String appBarTitle = "Login";
  bool isLogin = true;

  final String loginLogo = "images/placeholder.png";
  final String regLogo = "images/placeholder.png";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE7DE),
      body: WillPopScope(
        child: isLogin ? buildLogin() : buildRegistration(),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildLogin() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.asset(loginLogo),
          Text("Login".toUpperCase()),
          TextField(
            decoration: InputDecoration(
              hintText: "enter your email",
            ),
          ),
          RaisedButton(
            child: Text("Login".toUpperCase()),
            onPressed: (){},
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text("create account".toLowerCase()),
                onPressed: (){},
              ),
              VerticalDivider(),
              FlatButton(
                child: Text("Forgot password".toLowerCase()),
                onPressed: (){},
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildRegistration() {
    return Center(child: Text("Registration"));
  }

  void gotoRegistration() {
    setState(() {
      appBarTitle = "Registration";
      isLogin = false;
    });
  }

  void gotoLogin() {
    setState(() {
      appBarTitle = "Login";
      isLogin = true;
    });
  }

  Future<bool> onBackPress() {
    if (!isLogin) {
      gotoLogin();
    } else {
      return Future.value(true);
    }
  }
}
