import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/utils/app_constants.dart';

class NetworkService {
  getUsers() {
    return Firestore.instance
        .collection(AppConstants.USERCOLLECTION_REF)
        .snapshots();
  }

  DocumentReference roomRef(roomid) {
    return Firestore.instance
        .collection(AppConstants.CHATROOMCOLLECTION_REF)
        .document(roomid);
  }

  getMessages(String roomid) {
    return Firestore.instance
        .collection(AppConstants.MSGCOLLECTION_REF)
        .where("roomid", isEqualTo: roomid)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  getChatRooms(String uid) {
    return Firestore.instance
        .collection(AppConstants.CHATROOMCOLLECTION_REF)
        .where("participents", arrayContains: uid)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
