import 'package:flutter/material.dart';
import 'package:flutter_chat/services/network_service.dart';

import 'chat_screen.dart';
import 'loading_screen.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final String placeholderImage = "images/placeholder.png";

  //List<User> userList = List();
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
              leading: snapshot.data.documents[i].data['imageUrl'] == null
                  ? CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(placeholderImage),
                    )
                  : CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          snapshot.data.documents[i].data["imageUrl"]),
                    ),
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
                    context,
                    "id",
                    snapshot.data.documents[i].data["name"],
                    snapshot.data.documents[i].data["imageUrl"]);
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

  void navigateToChat(
      BuildContext context, String peerId, String peerName, String avatarUrl) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(peerId: peerId, peerName: peerName, avatarUrl: avatarUrl);
    }));
  }
}
