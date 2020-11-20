import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enterMessage = " ";

  final _messageController = new TextEditingController();

  void _sendMessage() async {
    String userName;
    String imageUrl;
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();

 /*   StreamBuilder(
        stream: Firestore.instance
            .collection("user")
            .document(user.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          userName = snapshot.data["userName"];
          return null;
        });
    StreamBuilder(
        stream: Firestore.instance
            .collection("user")
            .document(user.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          imageUrl = snapshot.data["imageUrl"];
          return null;
        });*/

    Firestore.instance.collection("chat").add(
      {
        "text": _enterMessage,
        "createdAt": Timestamp.now(),
        "userId": user.uid,
        },
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _messageController,
            decoration: InputDecoration(labelText: "Enter a message..."),
            onChanged: (value) {
              setState(() {
                _enterMessage = value;
              });
            },
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _enterMessage.trim().isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
          ),
        ],
      ),
    );
  }
}
