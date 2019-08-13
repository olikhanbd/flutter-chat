import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user.dart';
import 'package:flutter_chat/services/network_service.dart';
import 'package:flutter_chat/services/shared_prefs_manager.dart';
import 'package:flutter_chat/utils/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatelessWidget {
  final User peer;

  Chat({Key key, @required this.peer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          peer.name,
        ),
        elevation: 0.7,
      ),
      body: ChatScreen(
        peer: peer,
      ),
      backgroundColor: Color(0xFFEEE7DE),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final User peer;

  ChatScreen({@required this.peer});

  @override
  _ChatScreenState createState() => _ChatScreenState(peer: peer);
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController editingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  var textColorBlack = Color(0xFF000000);
  var senderBgColor = Color(0xFFFFFFFF);
  var receiverBgColor = Color(0xFFE1FFC7);
  var uiBgColor = Color(0xFFEEE7DE);

  var roomId;
  User user;
  User peer;

  SharedPrefsManager spManager;
  var messageSnapshot;

  _ChatScreenState({@required this.peer});

  bool isShowSticker = false;

  @override
  void initState() {
    super.initState();

    spManager = SharedPrefsManager();
    spManager.getUser().then((userValue) {
      setState(() {
        user = userValue;
        roomId = _getRoomId(user.uid, peer.uid);
        messageSnapshot = NetworkService().getMessages(roomId);

        print("user: " + user.name);
        print("peer: " + peer.name);
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Column(
        children: <Widget>[
          //list of messages
          buildListMessage(),

          //Sticker
          (isShowSticker ? buildSticker() : Container()),

          //input
          buildInput(),
        ],
      ),

      //Loading
      //buildLoading(),

      onWillPop: onBackPress,
    );
  }

  String _getRoomId(String uid1, String uid2) {
    if (uid1.compareTo(uid2) < 0)
      return uid1 + uid2;
    else
      return uid2 + uid1;
  }

  _checkRoom(bool isRead, String msg) {
    NetworkService().roomRef(roomId).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        print("chat room exists");
        if (isRead) {
          //read chat messages

        } else {
          //update room
          _updateRoom(msg);
        }
      } else {
        print("chat room does not exists");
        _createRoom(msg);
      }
    }).catchError((e) {
      print(e);
    });
  }

  _createRoom(String msg) {
    Firestore.instance
        .collection(AppConstants.CHATROOMCOLLECTION_REF)
        .document(roomId)
        .setData({
      "participents": FieldValue.arrayUnion([user.toJson(), peer.toJson()]),
      "uids": FieldValue.arrayUnion([user.uid, peer.uid]),
      "lastmsg": msg,
      "timestamp": FieldValue.serverTimestamp()
    }).then((_) {
      print("chat room created");
    }).catchError((e) {
      print(e);
    });
  }

  _updateRoom(String msg) {
    Firestore.instance
        .collection(AppConstants.CHATROOMCOLLECTION_REF)
        .document(roomId)
        .updateData({
      "lastmsg": msg,
      "timestamp": FieldValue.serverTimestamp()
    }).then((_) {
      print("chat room updated");
    }).catchError((e) {
      print(e);
    });
  }

  _sendMessage(String msg, int type) {
    print("inside sendMessage");
    Firestore.instance
        .collection(AppConstants.MSGCOLLECTION_REF)
        .document()
        .setData({
      "roomid": roomId,
      "sender": user.uid,
      "receiver": peer.uid,
      "message": msg,
      "type": type,
      "timestamp": FieldValue.serverTimestamp()
    }).then((_) {
      _checkRoom(false, msg);
    }).catchError((e) {
      print(e);
    });
  }

  buildListMessage() {
    return StreamBuilder(
      stream: messageSnapshot,
      builder: (context, snapshot) {
        return Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: (snapshot.data == null)
                    ? 0
                    : snapshot.data.documents.length,
                reverse: true,
                controller: listScrollController,
                itemBuilder: (context, index) => buildItem(
                    (index == snapshot.data.documents.length - 1),
                    snapshot.data.documents[index])));
      },
    );
  }

  Widget buildItem(bool isLastItem, document) {
    if (document["sender"] == user.uid) {
      return Row(
        children: <Widget>[
          document["type"] == 0
              ? Container(
                  child: Text(
                    document["message"],
                    style: TextStyle(color: textColorBlack),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: receiverBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastItem ? 20.0 : 10.0, right: 10.0),
                )
              : document["type"] == 1

                  // image
                  ? Container(
                      child: Material(
                        child: CachedNetworkImage(
                          imageUrl: document["message"],
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                                color: receiverBgColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              "images/placeholder.png",
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastItem ? 20.0 : 10.0, top: 10.0),
                    )

                  // sticker
                  : Container(
                      child: Image.asset(
                        "images/${document["message"]}.gif",
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastItem ? 20.0 : 10.0, top: 10.0),
                    )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Row(
        children: <Widget>[
          document["type"] == 0
              ? Container(
                  child: Text(
                    document["message"],
                    style: TextStyle(color: textColorBlack),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: senderBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastItem ? 20.0 : 10.0, right: 10.0),
                )
              : document["type"] == 1

                  //image
                  ? Container(
                      child: Material(
                        child: CachedNetworkImage(
                          imageUrl: document["message"],
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                                color: senderBgColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              "images/placeholder.png",
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            clipBehavior: Clip.hardEdge,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastItem ? 20.0 : 10.0, top: 10.0),
                    )

                  //sticker
                  : Container(
                      child: Image.asset(
                        "images/${document["message"]}.gif",
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastItem ? 20.0 : 10.0, top: 10.0),
                    )
        ],
      );
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                  icon: Icon(
                    Icons.image,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: getImage),
            ),
            color: Colors.white,
          ),

          //button send sticker
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                  icon: Icon(Icons.face),
                  color: Theme.of(context).primaryColor,
                  onPressed: getSticker),
            ),
            color: Colors.white,
          ),

          //Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
                controller: editingController,
                decoration: InputDecoration.collapsed(
                    hintText: "type your message...",
                    hintStyle: TextStyle(color: Colors.grey)),
                focusNode: focusNode,
              ),
            ),
          ),

          //button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    _sendMessage(editingController.text, 0);
                    setState(() {
                      editingController.text = "";
                    });
                  }),
              color: Colors.white,
            ),
          )
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi1", 2);
                },
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi2", 2);
                },
                child: Image.asset(
                  "images/mimi2.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi3", 2);
                },
                child: Image.asset(
                  "images/mimi3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi4", 2);
                },
                child: Image.asset(
                  "images/mimi4.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi5", 2);
                },
                child: Image.asset(
                  "images/mimi5.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi6", 2);
                },
                child: Image.asset(
                  "images/mimi6.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi7", 2);
                },
                child: Image.asset(
                  "images/mimi7.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi8", 2);
                },
                child: Image.asset(
                  "images/mimi8.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () {
                  _sendMessage("mimi9", 2);
                },
                child: Image.asset(
                  "images/mimi9.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  Future getImage() async {
    debugPrint("inside getImage");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String path = image.path;
      debugPrint("path $path");
      //onSendMessage(path, 1);
    }
  }

  void getSticker() {
    debugPrint("inside getSticker");
    //hide keyboard
    focusNode.unfocus();

    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void exitScreen() {
    Navigator.pop(context, true);
  }
}
