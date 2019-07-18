import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String appBarTitle = "Login";
  bool isLogin = true;

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
    return Container(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                ///////////////////EMAIL INPUT//////////////////////////////////
                Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: emailController,
                      validator: (String value) {
                        if (value.isEmpty)
                          return "Please enter a valid email address";
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15.0),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0))),
                    )),

                /////////////////////////PASSWORD INPUT/////////////////////////
                Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (String value) {
                        if (value.isEmpty)
                          return "Please enter a valid password";
                      },
                      style: TextStyle(fontSize: 15.0),
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15.0),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0))),
                    )),

                /////////////////////////SUBMIT BUTTON//////////////////////////
                Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 0.7,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ))
              ],
            ),
          )),
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
