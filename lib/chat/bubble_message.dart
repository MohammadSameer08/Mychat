import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userId;

  MessageBubble(this.message,this.userId, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("user")
                          .document(userId)
                          .snapshots(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading...");
                        }

                        return Text(
                          snapshot.data["userName"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.black : Colors.white,
                          ),
                        );
                      }),
                  Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        StreamBuilder(
            stream: Firestore.instance
                .collection("user")
                .document(userId)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Positioned(
                    top: -10,
                    left: isMe ? null : 120, //i.e 120 form left
                    right: isMe ? 120 : null, // i.e 120 from right
                    child: CircularProgressIndicator());
              }
              return Positioned(
                top: -10,
                left: isMe ? null : 120, //i.e 120 form left
                right: isMe ? 120 : null, // i.e 120 from right
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data["imageUrl"]),
                ),
              );
            })
      ],
      overflow: Overflow.visible,
    );
  }
}
/*
   StreamBuilder(
            stream: Firestore.instance
                .collection("user")
                .document(userId)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Positioned(
                    top: -10,
                    left: isMe ? null : 120, //i.e 120 form left
                    right: isMe ? 120 : null, // i.e 120 from right
                    child: CircularProgressIndicator());
              }
              return Positioned(
                top: -10,
                left: isMe ? null : 120, //i.e 120 form left
                right: isMe ? 120 : null, // i.e 120 from right
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data["imageUrl"]),
                ),
              );
            })
 */

/*
   StreamBuilder(
                      stream: Firestore.instance
                          .collection("user")
                          .document(userId)
                          .snapshots(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading...");
                        }

                        return Text(
                          snapshot.data["userName"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.black : Colors.white,
                          ),
                        );
                      }),

 */
