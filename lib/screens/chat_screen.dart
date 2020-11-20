import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchat/chat/messages.dart';
import 'package:flutterchat/chat/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: <Widget>[
          DropdownButton(
              underline: Container(),
              //since we are getting a line under it to remove it we used here a empty container()
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Logout"),
                      ],
                    ),
                  ),
                  value: "Logout", // just an identifier
                ),
              ],
              onChanged: (itemIdentifiers) {
                if (itemIdentifiers == "Logout")
                  FirebaseAuth.instance.signOut(); // logout
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}

/* body: StreamBuilder(
          stream: Firestore.instance
              .collection("chats/0tLzzcN9xI4fvGbpD8C9/messages")
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = snapshot.data.documents;
            return ListView.builder(
              itemCount: document.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text(document[index]["text"]),
              ),
            );
          }),


 */
