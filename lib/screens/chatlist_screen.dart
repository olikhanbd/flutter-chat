import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    print("doc: timestamp   ${document.data["timestamp"]}");
    print("doc: lastmsg ${document.data["lastmsg"]}");
    return (document.data != null)
        ? Column(
            children: <Widget>[
              Divider(
                height: 10.0,
              ),
              ListTile(
                leading: (document.data["participents"][0] == user.uid)
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: document.data["participents"][5] ?? "",
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
                          imageUrl: document.data["participents"][2] ?? "",
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
                      (document.data["participents"][0] == user.uid)
                          ? document.data["participents"][4]
                          : document.data["participents"][1],
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
                  var id = (document.data["participents"][0] == user.uid)
                      ? document.data["participents"][3]
                      : document.data["participents"][0];
                  var name = (document.data["participents"][0] == user.uid)
                      ? document.data["participents"][4]
                      : document.data["participents"][1];
                  var imageUrl = (document.data["participents"][0] == user.uid)
                      ? document.data["participents"][5]
                      : document.data["participents"][2];
                  navigateToChat(context, id, name, imageUrl);
                },
              )
            ],
          )
        : Container();
  }

  void navigateToChat(
      BuildContext context, String peerId, String peerName, String avatarUrl) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(peerId: peerId, peerName: peerName, avatarUrl: avatarUrl);
    }));
  }
}
