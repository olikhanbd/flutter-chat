import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user.dart';
import 'package:flutter_chat/services/network_service.dart';
import 'package:flutter_chat/services/shared_prefs_manager.dart';
import 'package:intl/intl.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var user;
  var chatRoomsSnapshot;

  var placeholderImage = "images/user.png";

  @override
  void initState() {
    super.initState();

    SharedPrefsManager().getUser().then((data) {
      user = data;

      setState(() {
        chatRoomsSnapshot = NetworkService().getChatRooms(user.uid);
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatRoomsSnapshot,
      builder: (context, snapshot) {
        return (snapshot.data != null)
            ? ListView.builder(
                itemCount: (snapshot.data == null)
                    ? 0
                    : snapshot.data.documents.length,
                itemBuilder: (context, i) =>
                    buildItem(context, snapshot.data.documents[i]))
            : Container();
      },
    );
  }

  Widget buildItem(context, document) {
    User peer1 =
        User.fromJson(document.data["participents"][0].cast<String, dynamic>());
    User peer2 =
        User.fromJson(document.data["participents"][1].cast<String, dynamic>());

    return (document.data != null)
        ? Column(
            children: <Widget>[
              Divider(
                height: 10.0,
              ),
              ListTile(
                leading: (peer1.uid == user.uid)
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: peer2.imageUrl ?? "",
                          placeholder: (context, url) => Image.asset(
                            placeholderImage,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            placeholderImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: peer1.imageUrl ?? "",
                          placeholder: (context, url) => Image.asset(
                            placeholderImage,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            placeholderImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      (peer1.uid == user.uid) ? peer2.name : peer1.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.MMMd().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (document.data["timestamp"] == null)
                                  ? 0
                                  : document.data["timestamp"]
                                      .millisecondsSinceEpoch)),
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    document.data["lastmsg"],
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
                onTap: () {
                  var peer = (peer1.uid == user.uid) ? peer2 : peer1;
                  navigateToChat(context, peer);
                },
              )
            ],
          )
        : Container();
  }

  void navigateToChat(BuildContext context, User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(peer: user);
    }));
  }
}
