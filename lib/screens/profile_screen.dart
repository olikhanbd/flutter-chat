import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/shared_prefs_manager.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user;
  final String placeholder = "images/user.png";

  @override
  void initState() {
    super.initState();

    SharedPrefsManager().getUser().then((userValue) {
      setState(() {
        user = userValue;
      });
    }).catchError((e) {
      print("profile screen: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: (user == null) ? "" : user.imageUrl,
                width: 160.0,
                height: 160.0,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  placeholder,
                  width: 160.0,
                  height: 160.0,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  placeholder,
                  width: 160.0,
                  height: 160.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
              child: Text(
                (user == null) ? "name" : user.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24.0),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Text(
                  (user == null) ? "email" : user.email,
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ))
          ],
        ),
      ),
    );
  }
}
