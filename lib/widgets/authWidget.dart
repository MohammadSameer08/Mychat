import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterchat/pickers/user_image_picker.dart';


class AuthWidget extends StatefulWidget {
  final Function submitFn;
  final bool isLoading;

  AuthWidget(this.submitFn, this.isLoading);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var isLogin = true;
  File userImageFile;
  final _formKey = GlobalKey<FormState>();

  void _imageFile(File imageFile) {
    userImageFile = imageFile;
  }

  void submit() {
    FocusScope.of(context).unfocus(); // keyboard will close
    final isValid = _formKey.currentState
        .validate(); // it will invoke validator: of all TextFormField()

    if (userImageFile == null && !isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please select an Image!"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userName.trim(),
        _userEmail.trim(),
        _userPassword.trim(),
        userImageFile,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: isLogin ? 310 : 380,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // so that it could not take full size,
                  children: <Widget>[
                    if (!isLogin) UserImagePicker(_imageFile),
                    TextFormField(
                      key: ValueKey("email"),
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@"))
                          return "Please Enter a valid email address";
                        else
                          return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email address",
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!isLogin)
                      TextFormField(
                        key: ValueKey("username"),
                        autocorrect: true,
                        validator: (value) {
                          if (value.isEmpty || value.length < 4)
                            return "Please enter at least 4 character's";
                          else
                            return null;
                        },
                        decoration: InputDecoration(labelText: "Username"),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey("password"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7)
                          return "Please enter a password having at least 7 digit's";
                        else
                          return null;
                      },
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading)
                      CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    if (!widget.isLoading)
                      RaisedButton(
                        child: Text(isLogin ? "Login" : "Signup"),
                        onPressed: () {
                          submit();
                        },
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(isLogin
                            ? "Create new account"
                            : "I already have an account"),
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
