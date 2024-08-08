import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/page.dart';

class FireStoreMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void incPage(String pid, String name) async {
    DocumentSnapshot snap = await _db.collection('pages').doc(pid).get();
    if (snap.exists) {
      await _db
          .collection('pages')
          .doc(pid)
          .update({'count': FieldValue.increment(1)});
    } else {
      createChatPage(pid, name);
    }
  }

  Future<void> createChatPage(String pid,String name) async {
    Page page = Page(
      count: 1,
      pid: pid,
      title: name,
    );
    await _db.collection("pages").doc(pid).set(page.toJson());
  }

  Future<void> addMessageToChatPage(String roomId, String messageContent) async {
    final firestore = FirebaseFirestore.instance;
    final messageData = {
      'message': messageContent,
      'sent_by': FirebaseAuth.instance.currentUser!.uid,
      'datetime': Timestamp.now(),
    };
    await firestore
        .collection('pages')
        .doc(roomId)
        .collection('messages')
        .add(messageData);
  }

  Future<void> addFollowerToChatPage(String roomId,String title,bool isFollowing) async {
    final firestore = FirebaseFirestore.instance;
    final Map<String, dynamic> userData = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'username': FirebaseAuth.instance.currentUser!.displayName,
      'email': FirebaseAuth.instance.currentUser!.email,
      'notifications':true,
    };
    final Map<String, dynamic> pageData = {
      'roomId': roomId,
      'title':title,
      'notifications':true,
    };
    if(isFollowing){
      await firestore
          .collection('pages')
          .doc(roomId)
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser!.uid).delete();
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('FollowedPages')
          .doc(roomId).delete();
    }else{
      await firestore
          .collection('pages')
          .doc(roomId)
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser!.uid).set(userData);
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('FollowedPages')
          .doc(roomId).set(pageData);
    }
  }

  Future<void> changeNotificationOption(String roomId, String title, bool notifications) async {
    final firestore = FirebaseFirestore.instance;
    final Map<String, dynamic> pageData = {
      'roomId': roomId,
      'title':title,
      'notifications':!notifications,
    };
    final Map<String, dynamic> userData = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'username': FirebaseAuth.instance.currentUser!.displayName,
      'email': FirebaseAuth.instance.currentUser!.email,
      'notifications':!notifications,
    };
    await firestore
        .collection('pages')
        .doc(roomId)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser!.uid).set(userData);
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('FollowedPages')
        .doc(roomId).set(pageData);
  }

  Future<void> deleteFollow(String roomId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('pages')
        .doc(roomId)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser!.uid).delete();
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('FollowedPages')
        .doc(roomId).delete();
  }
}
