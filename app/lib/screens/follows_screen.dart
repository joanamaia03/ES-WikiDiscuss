import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wiki_discuss/screens/wiki_page_screen.dart';
import '../resources/setting_methods.dart';
import '../resources/firestore_methods.dart';
import '../widgets/icon_buttons.dart';

class FollowedScreen extends StatelessWidget {
  const FollowedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FireStoreMethods _firestoreService = FireStoreMethods();

    return Scaffold(
      backgroundColor: mode.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context, firestore, auth, _firestoreService),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mode.background,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          key: ValueKey("BackIconButton"),
        ),
        color: mode.letters,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Followed Pages',
        style: TextStyle(
          color: mode.letters,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FirebaseFirestore firestore, FirebaseAuth auth, FireStoreMethods _firestoreService) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').doc(auth.currentUser!.uid).collection('FollowedPages').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) {
            return Container();
          }
          return ListView.builder(
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, i) => _buildContainer(context, snap.data!.docs[i], _firestoreService),
          );
        },
      ),
    );
  }

  Widget _buildContainer(BuildContext context, DocumentSnapshot page, FireStoreMethods _firestoreService) {
    Map<String, dynamic> pageData = page.data() as Map<String, dynamic>;
    final roomId = pageData['roomId'];
    final title = pageData['title'];
    final notificationsOn = pageData['notifications'];

    return Container(
      margin: const EdgeInsets.only(bottom: 17.0),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(25),
          right: Radius.circular(25),
        ),
        color: mode.isLight ? Colors.grey[300] : Colors.grey[900],
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WikiPageScreen(
              title: title,
              id: roomId,
            ),
          ),
        ),
        title: _buildTitle(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNotificationIconButton(roomId, title, notificationsOn, _firestoreService),
            SizedBox(width: 12.0),
            _buildTrashIconButton(roomId, _firestoreService),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: mode.letters,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  IconBorder _buildNotificationIconButton(String roomId, String title, bool notificationsOn, FireStoreMethods _firestoreService) {
    return IconBorder(
      icon: notificationsOn ? CupertinoIcons.bell_fill : CupertinoIcons.bell,
      color: notificationsOn ? Colors.lightBlue : Colors.white,
      onTap: () async {
        _firestoreService.changeNotificationOption(roomId, title, notificationsOn);
      },
    );
  }

  IconBorder _buildTrashIconButton(String roomId, FireStoreMethods _firestoreService) {
    return IconBorder(
      icon: CupertinoIcons.trash,
      color: Colors.pink,
      onTap: () async {
        _firestoreService.deleteFollow(roomId);
      },
    );
  }
}