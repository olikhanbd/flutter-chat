class AppConstants {

  static const String TAG = "CHATAPP";

  /////////////////////////////////////ROUTE NAMES//////////////////////////////
  static const String LAUNCHER = "/";
  static const String ROUTEHOME = "/home";
  static const String ROUTEAUTH = "/auth";

  ////////////////////////////////////FIRESTORE REFS////////////////////////////
  static const String USERCOLLECTION_REF = "users";
  static const String CHATROOMCOLLECTION_REF = "chatrooms";
  static const String MSGCOLLECTION_REF = "messages";

  //////////////////////////////////HOME MENU ITEMS/////////////////////////////
  static const String MENU_SIGNOUT = "Log out";
  static const List<String> homeMenuList = <String>[MENU_SIGNOUT];
}
