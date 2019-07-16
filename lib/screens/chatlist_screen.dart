import 'package:flutter/material.dart';
import 'package:flutter_chat/models/chat_list_model.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (context, i) => Column(
              children: <Widget>[
                Divider(
                  height: 10.0,
                ),
                ListTile(
                  leading: CircleAvatar(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(dummyData[i].avatarUrl),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        dummyData[i].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        dummyData[i].time,
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                    ],
                  ),
                  subtitle: Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      dummyData[i].message,
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    ),
                  ),
                  onTap: () {
                    navigateToChat(context, "id", dummyData[i].name,
                        dummyData[i].avatarUrl);
                  },
                )
              ],
            ));
  }

  void navigateToChat(
      BuildContext context, String peerId, String peerName, String avatarUrl) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(peerId: peerId, peerName: peerName, avatarUrl: avatarUrl);
    }));
  }
}
