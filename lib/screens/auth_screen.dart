import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/flutter_chat_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/services/user_management.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String appBarTitle = "Login";
  bool isLogin = true;

  final String loginLogo = "images/placeholder.png";
  final String regLogo = "images/placeholder.png";
  final String googleLogo = "images/google_logo.png";
  final String flutterLogo = "images/flutter_logo.png";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController regNameController = TextEditingController();
  TextEditingController regEmailController = TextEditingController();
  TextEditingController regPasswordController = TextEditingController();

  var _loginFormKey = GlobalKey<FormState>();
  var _regFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE7DE),
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        child: buildView(),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildView() {
    return SafeArea(
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.lightGreen, Colors.green]),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
              height: 80.0,
              child: Image.asset(flutterLogo),
            ),
            Text(
              appBarTitle.toUpperCase(),
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            isLogin ? buildLogin() : buildRegistration()
          ],
        ),
      ),
    );
  }

  Widget buildLogin() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            validator: (input) {
              if (input.isEmpty) {
                return "Please enter a valid email";
              }
              return null;
            },
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
              fillColor: Colors.white.withOpacity(0.1),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: passwordController,
            validator: (input) {
              if (input.isEmpty) {
                return "Please enter a valid password";
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
              prefixIcon: Container(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(10.0))),
                child: Icon(Icons.lock),
              ),
              hintText: "enter password",
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            obscureText: true,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.green,
                padding: EdgeInsets.all(20.0),
                child: Text("Login".toUpperCase()),
                onPressed: () {
                  if (_loginFormKey.currentState.validate()) {
                    signInWithEmailAndPass(
                        emailController.text, passwordController.text);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              )),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.green,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: Image.asset(googleLogo),
                    ),
                    Text(
                      "Sign in With Google",
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              )),
          //Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("create account".toLowerCase()),
                onPressed: () {
                  gotoRegistration();
                },
                textColor: Colors.white,
              ),
              VerticalDivider(
                color: Colors.white,
              ),
              FlatButton(
                child: Text("Forgot password".toLowerCase()),
                onPressed: () {},
                textColor: Colors.white,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildRegistration() {
    return Form(
      key: _regFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: regNameController,
            validator: (input) {
              if (input.isEmpty) {
                return "Please enter a valid name";
              }
              return null;
            },
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
                        bottomRight: Radius.circular(1.0)),
                  ),
                  child: Icon(Icons.person),
                ),
                hintText: "enter your name",
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1)),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: regEmailController,
            validator: (input) {
              if (input.isEmpty) {
                return "Please enter a valid email";
              }
              return null;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16.0),
                prefixIcon: Container(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(10.0)),
                  ),
                  child: Icon(Icons.mail),
                ),
                hintText: "enter your email",
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1)),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: regPasswordController,
            validator: (input) {
              if (input.isEmpty) {
                return "Please enter a valid password";
              }
              return null;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16.0),
                prefixIcon: Container(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(10.0)),
                  ),
                  child: Icon(Icons.lock),
                ),
                hintText: "enter password",
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1)),
            style: TextStyle(color: Colors.white),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
                color: Colors.white,
                textColor: Colors.green,
                padding: EdgeInsets.all(16.0),
                child: Text("Register"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () {
                  if (_regFormKey.currentState.validate()) {
                    createUserWithEmailAndPass(regNameController.text,
                        regEmailController.text, regPasswordController.text);
                  }
                }),
          )
        ],
      ),
    );
  }

  void signInWithEmailAndPass(email, pass) {
    print("email: " + email + " pass: " + pass);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterChatHome();
      }));
    }).catchError((e) {
      print(e);
    });
  }

  void createUserWithEmailAndPass(name, email, pass) {
    print("email: " + email + " name: " + name + " pass: " + pass);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((signedInUser) {
      UserManagement().storeNewUser(context, signedInUser.user, name);
    }).catchError((e) {
      print(e);
    });
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
      return null;
    } else {
      return Future.value(true);
    }
  }
}
