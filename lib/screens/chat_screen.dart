import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/chat_model.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerName;
  final String avatarUrl;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerName,
      @required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          peerName,
        ),
        elevation: 0.7,
      ),
      body: ChatScreen(),
      backgroundColor: Color(0xFFEEE7DE),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController editingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  var textColorBlack = Color(0xFF000000);
  var senderBgColor = Color(0xFFFFFFFF);
  var receiverBgColor = Color(0xFFE1FFC7);
  var uiBgColor = Color(0xFFEEE7DE);

  bool isShowSticker = false;
  List<ChatModel> chatList = List<ChatModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatList.addAll(dummyChat.reversed);
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

  Widget buildListMessage() {
    return Flexible(
        child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: chatList.length,
            reverse: true,
            controller: listScrollController,
            itemBuilder: (context, index) =>
                buildItem(index, chatList[index])));
  }

  Widget buildItem(int index, ChatModel model) {
    if (model.sender == "me") {
      return Row(
        children: <Widget>[
          chatList[index].doctype == 0
              ? Container(
                  child: Text(
                    model.message,
                    style: TextStyle(color: textColorBlack),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: receiverBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessage(index) ? 20.0 : 10.0, right: 10.0),
                )
              : chatList[index].doctype == 1

                  // image
                  ? Container(
                      child: Material(
                        child: CachedNetworkImage(
                          imageUrl: chatList[index].message,
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
                          bottom: isLastMessage(index) ? 20.0 : 10.0,
                          top: 10.0),
                    )

                  // sticker
                  : Container(
                      child: Image.asset(
                        "images/${chatList[index].message}.gif",
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessage(index) ? 20.0 : 10.0,
                          top: 10.0),
                    )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Row(
        children: <Widget>[
          chatList[index].doctype == 0
              ? Container(
                  child: Text(
                    model.message,
                    style: TextStyle(color: textColorBlack),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: senderBgColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessage(index) ? 20.0 : 10.0, right: 10.0),
                )
              : chatList[index].doctype == 1

                  //image
                  ? Container(
                      child: Material(
                        child: CachedNetworkImage(
                          imageUrl: chatList[index].message,
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
                          bottom: isLastMessage(index) ? 20.0 : 10.0,
                          top: 10.0),
                    )

                  //sticker
                  : Container(
                      child: Image.asset(
                        "images/${chatList[index].message}.gif",
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessage(index) ? 20.0 : 10.0,
                          top: 10.0),
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
                    onSendMessage(editingController.text, 0);
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
                  onSendMessage("mimi1", 2);
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
                  onSendMessage("mimi2", 2);
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
                  onSendMessage("mimi3", 2);
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
                  onSendMessage("mimi4", 2);
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
                  onSendMessage("mimi5", 2);
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
                  onSendMessage("mimi6", 2);
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
                  onSendMessage("mimi7", 2);
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
                  onSendMessage("mimi8", 2);
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
                  onSendMessage("mimi9", 2);
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

  void onSendMessage(String content, int doctype) {
    if (content.trim() != '') editingController.clear();

    setState(() {
      chatList.insert(0, ChatModel(content, "12:05", "me", "you", doctype));
    });
  }

  Future getImage() async {
    debugPrint("inside getImage");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String path = image.path;
      debugPrint("path $path");
      onSendMessage(path, 1);
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

  bool isLastMessage(int index) {
    return chatList.length - 1 == index;
  }

  void exitScreen() {
    Navigator.pop(context, true);
  }
}
