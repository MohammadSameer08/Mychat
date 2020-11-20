import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterchat/widgets/authWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  Future<void> _submitAuthForm(String userName, String userEmail,
      String password, File image, bool isLogin, BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });
    AuthResult authResult;

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: userEmail, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: userEmail, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(authResult.user.uid + ".jpg");

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection("user")
            .document(authResult.user.uid)
            .setData({
          "userName": userName,
          "userEmail": userEmail,
          "imageUrl": url
        }).then((value) {
          setState(() {
            isLoading = false;
          });
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occurs please check.";
      setState(() {
        isLoading = false;
      });
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthWidget(_submitAuthForm, isLoading),
    );
  }
}
