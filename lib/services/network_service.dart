import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/utils/app_constants.dart';

class NetworkService {
  getUsers() {
    return Firestore.instance
        .collection(AppConstants.USERCOLLECTION_REF)
        .snapshots();
  }
}
