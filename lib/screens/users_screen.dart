import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user.dart';
import 'package:flutter_chat/services/network_service.dart';

import 'chat_screen.dart';
import 'loading_screen.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final String placeholderImage = "images/user.png";

  var userSnapshot;

  @override
  void initState() {
    super.initState();

    setState(() {
      userSnapshot = NetworkService().getUsers();
    });
  }

  _getUserStream() {
    return StreamBuilder(
      stream: userSnapshot,
      builder: (context, snapshot) {
        return getListView(context, snapshot);
      },
    );
  }

  Widget getListView(context, snapshot) {
    return LoadingScreen(
      child: ListView.builder(
        itemCount: (snapshot.data == null) ? 0 : snapshot.data.documents.length,
        itemBuilder: (context, i) => Column(
          children: <Widget>[
            Divider(
              height: 10.0,
            ),
            ListTile(
              leading: ClipOval(
                  child: CachedNetworkImage(
                imageUrl: snapshot.data.documents[i].data["imageUrl"] ?? "",
                placeholder: (context, url) => Image.asset(
                  placeholderImage,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  placeholderImage,
                  fit: BoxFit.cover,
                ),
              )),
              title: Text(
                snapshot.data.documents[i].data["name"],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  snapshot.data.documents[i].data["email"],
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              onTap: () {
                navigateToChat(
                    context, User.fromJson(snapshot.data.documents[i].data));
              },
            )
          ],
        ),
      ),
      inAsyncCall: snapshot.data == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getUserStream();
  }

  void navigateToChat(BuildContext context, User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(peer: user);
    }));
  }
}
