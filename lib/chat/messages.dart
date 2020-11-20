import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/chat/bubble_message.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection("chat")
                  .orderBy(
                    "createdAt",
                    descending: true,
                  )
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else {
                  final document = chatSnapshot.data.documents;
                  return ListView.builder(
                    reverse: true,
                    // so that is should display the text from bottom
                    itemCount: document.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                      document[index]["text"],
                      document[index]["userId"],
                      document[index]["userId"] == futureSnapshot.data.uid,
                      key: ValueKey(document[index].documentID),
                    ),
                  );
                }
              });
        });
  }
}
