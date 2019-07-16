import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/status_screen.dart';

import 'calls_screen.dart';
import 'camera_screen.dart';
import 'chatlist_screen.dart';

class FlutterChatHome extends StatefulWidget {
  @override
  _FlutterChatHomeState createState() => _FlutterChatHomeState();
}

class _FlutterChatHomeState extends State<FlutterChatHome>
    with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChat"),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.camera_alt),),
              Tab(text: "CHATS",),
              Tab(text: "STATUS"),
              Tab(text: "CALLS",)
            ]
        ),
        actions: <Widget>[
          Icon(Icons.search),
          Icon(Icons.more_vert)
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          CameraScreen(),
          ChatListScreen(),
          StatusScreen(),
          CallsScreen()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.message, color: Colors.white,),
          tooltip: "Open chat",
          onPressed: ()=> print("open chat")
      ),
    );
  }
}
