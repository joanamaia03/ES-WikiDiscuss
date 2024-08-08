import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wiki_discuss/resources/firestore_methods.dart';
import 'package:wiki_discuss/resources/notifications_methods.dart';
import 'package:wiki_discuss/widgets/icon_buttons.dart';
import '../resources/setting_methods.dart';
import '../utils/utils.dart';
import '../resources/storage_methods.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String id;
  const ChatScreen({Key? key,required this.name, required this.id}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;
  final FireStoreMethods _firestoreService = FireStoreMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mode.background,

        body: Column(
            children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                      color: mode.isLight? Colors.black12:Colors.black, // Set the shadow color
                      spreadRadius: 2, // Set the spread radius of the shadow
                      blurRadius: 5, // Set the blur radius of the shadow
                      offset: Offset(0, 2), // Set the offset of the shadow
                    ),
                  ],
                ),
                child:AppBar(
                  //iconTheme: IconThemeData(color: Colors.blue),
                  centerTitle: false,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      key: ValueKey("BackIconButton"),
                      color: Colors.blue,
                    ),
                    color: mode.letters,
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: mode.background,
                  elevation: 0,
                  leadingWidth: 60,
                  title: _AppBarTitle(name: widget.name,),
                  actions: [
                    StreamBuilder(
                      stream: firestore.collection('pages').doc(widget.id).collection('followers').where('uid', isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                              child:GestureDetector(
                                onTap: () async {
                                  await _firestoreService.addFollowerToChatPage(widget.id,widget.name, !(!snapshot.hasData || snapshot.data!.docs.isEmpty));
                                },
                                child: Icon(
                                  !snapshot.hasData || snapshot.data!.docs.isEmpty ? CupertinoIcons.bookmark : CupertinoIcons.bookmark_fill,
                                  color: Colors.blue,
                                ),
                              )
                          ),
                        );
                      },
                    )
                  ],
                ),),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('pages').where('title', isEqualTo: widget.name).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                      if (snap.hasData) {
                        if (snap.data!.docs.isNotEmpty) {
                          QueryDocumentSnapshot? data =snap.data!.docs.toList().first;
                          return data == null
                              ? Container()
                              : StreamBuilder(
                              stream: data.reference
                                  .collection('messages')
                                  .orderBy('datetime', descending: true)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snap) {
                                return !snap.hasData
                                    ? Container()
                                    : ListView.builder(
                                  itemCount: snap.data!.docs.length,
                                  reverse: true,
                                  itemBuilder: (context, i) {
                                    if (snap.data!.docs[i]['sent_by'] ==
                                        FirebaseAuth.instance.currentUser!
                                            .uid) {
                                      return _MessageOwnTile(
                                          message: snap.data!
                                              .docs[i]['message'],
                                          messageDate: snap.data!.docs[i]['datetime'].toDate()
                                      );
                                    } else {
                                      return _MessageTile(
                                          message: snap.data!.docs[i]['message'],
                                          messageDate: snap.data!.docs[i]['datetime'].toDate(),
                                          uid: snap.data!.docs[i]['sent_by']
                                      );
                                    }
                                  },
                                );
                              });
                        } else {
                          return const Center(
                            child: Text(
                              'No conversion found',
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.indigo,
                          ),
                        );
                      }
                    }),
              ),
            ),
            _MessageBar(roomId: widget.id,name: widget.name,),
          ],
        )
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  final String name;
  const _AppBarTitle({Key? key,required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mode.letters,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
    required this.messageDate,
    required this.uid,
  }) : super(key: key);

  final String message;
  final DateTime messageDate;
  final String uid;

  Future<String?> loadProfileImageUrl() async {
    return await StorageMethods().getDownloadUrl("profile_images/$uid");
  }

  Future<String> getAuthorName(String uid) async {
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data()?['username'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String?>(
            future: loadProfileImageUrl(),
            builder:
                (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!),
                  radius: 20.0,
                );
              } else {
                return const CircleAvatar(
                  backgroundImage:
                  AssetImage('lib/assets/profile_photo.jpg'),
                  radius: 20.0,
                );
              }
            },
          ),
          const SizedBox(width: 6.0),
          Expanded(
            child: FutureBuilder<String>(
              future: getAuthorName(uid),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: mode.widgets_grey,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: mode.letters,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${snapshot.hasData ? snapshot.data! : "Unknown"}: ${timePassed(messageDate)}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _MessageOwnTile extends StatelessWidget{
  const _MessageOwnTile({
    Key? key,
    required this.message,
    required this.messageDate,
  }) : super(key : key);

  final String message;
  final DateTime messageDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  timePassed(messageDate),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class _MessageBar extends StatefulWidget {
  var roomId;
  var name;
  _MessageBar({Key? key,required this.roomId,required this.name}) : super(key: key);

  @override
  __MessageBarState createState() => __MessageBarState();
}

class __MessageBarState extends State<_MessageBar> {
  final TextEditingController controller_ = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final FireStoreMethods _firestoreService = FireStoreMethods();
  final NotificationMethods notificationMethods= NotificationMethods();

  Future<void> _sendMessage() async {
    var roomId = widget.roomId;
    if (controller_.text.toString() != '') {
      await _firestoreService.addMessageToChatPage(
          roomId, controller_.text.toString());
    }
    QuerySnapshot snapshot = await firestore.collection('pages').doc(roomId).collection('followers').get();
    List<DocumentSnapshot> followers = snapshot.docs;
    for (int i = 0; i < followers.length; i++) {
      DocumentSnapshot follower = followers[i];
      if (follower is QueryDocumentSnapshot) {
        Map<String, dynamic> followerData = follower.data() as Map<String, dynamic>;
        if(followerData['notifications'] != null) {
          if (followerData['notifications']) {
            var userSnap = await FirebaseFirestore.instance.collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            var currentUserData = userSnap.data()!;
            if (followerData['email'] != null &&
                followerData['uid'] != currentUserData['uid'] && followerData['notifications']) {
              notificationMethods.showNotification(
                  currentUserData['username'], followerData['email'],
                  widget.name, controller_.text.toString());
            }
          }
        }
      }
    }
    controller_.clear();
  }

  @override
  void dispose() {
    controller_.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final singleLineHeight =
        Theme.of(context).textTheme.bodyText2?.fontSize ?? 14;
    return Container(
      decoration: BoxDecoration(
        color: mode.background,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: mode.widgets_grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: LimitedBox(
                      maxHeight: 10 * singleLineHeight,
                      child: TextField(
                        key: const ValueKey('SendTextField'),
                        controller: controller_,
                        maxLines: null,
                        style:
                        TextStyle(fontSize: 16, color: mode.letters),
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: "Send Message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: mode.letters,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ClipOval(
                child: Material(
                  color: Colors.blue,
                  child: InkWell(
                    splashColor: Colors.grey,
                    onTap: _sendMessage,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        key: ValueKey("SendIconButton"),
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
