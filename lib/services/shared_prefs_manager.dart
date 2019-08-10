import 'dart:convert';

import 'package:flutter_chat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  final String USER = "user";
  final String TAG = "oli_" + "SharedPrefsManager";

  Future<User> getUser() async {
    print(TAG + " inside get user");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey(USER)) {
      var s = sharedPreferences.getString(USER);
      print(TAG + " " + s);
      Map userMap = jsonDecode(s);

      return User.fromJson(userMap);
    }

    else return null;
  }

  Future setUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userString = jsonEncode(user);
    print(TAG + " " + userString);
    sharedPreferences.setString(USER, userString);

    return;
  }

  Future clearUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(USER);

    return;
  }
}
