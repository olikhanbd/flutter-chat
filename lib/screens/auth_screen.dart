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
    return SafeArea(
        child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.lightGreen, Colors.green])),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      height: 80,
                      child: Image.asset(loginLogo)),
                  Text(
                    "Login".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16.0),
                        prefixIcon: Container(
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          margin: EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(10.0))),
                          child: Icon(Icons.person),
                        ),
                        hintText: "enter your email",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1)),
                  ),
                  RaisedButton(
                    child: Text("Login".toUpperCase()),
                    onPressed: () {},
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text("create account".toLowerCase()),
                        onPressed: () {},
                      ),
                      VerticalDivider(),
                      FlatButton(
                        child: Text("Forgot password".toLowerCase()),
                        onPressed: () {},
                      )
                    ],
                  )
                ],
              ),
            )));
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
