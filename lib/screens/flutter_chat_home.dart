import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/users_screen.dart';
import 'package:flutter_chat/services/shared_prefs_manager.dart';
import 'package:flutter_chat/utils/app_constants.dart';

import 'auth_screen.dart';
import 'camera_screen.dart';
import 'chatlist_screen.dart';

class FlutterChatHome extends StatefulWidget {
  @override
  _FlutterChatHomeState createState() => _FlutterChatHomeState();
}

class _FlutterChatHomeState extends State<FlutterChatHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  SharedPrefsManager spManager = SharedPrefsManager();
  String imgUrl = "";
  String placeHolder = "images/user.png";

  @override
  void initState() {
    spManager.getUser().then((user) {
      if (user != null) {
        setState(() {
          imgUrl = user.imageUrl;
        });
      }
    }).catchError((e) {
      print(e);
    });

    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
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
              Tab(
                icon: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    placeholder: (context, url) => Image.asset(
                      placeHolder,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      child: Image.asset(
                        placeHolder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                text: "CHATS",
              ),
              Tab(text: "USERS"),
            ]),
        actions: <Widget>[
          Icon(Icons.search),
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected,
            itemBuilder: (context) {
              return AppConstants.homeMenuList.map((choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          CameraScreen(),
          ChatListScreen(),
          UsersScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
          tooltip: "Open chat",
          onPressed: () => print("open chat")),
    );
  }

  void _onMenuItemSelected(String menuItem) {
    switch (menuItem) {
      case AppConstants.MENU_SIGNOUT:
        signOut();
        break;
    }
  }

  void signOut() async {
    SharedPrefsManager spManager = new SharedPrefsManager();
    spManager.clearUser().then((_) {
      navigateToAuth();
    }).catchError((e) {
      print(e);
      _showSnackBar(e.message);
    });
  }

  void navigateToAuth() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AuthScreen();
    }));
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
