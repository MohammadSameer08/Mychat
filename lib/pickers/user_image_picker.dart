import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function imagePickerFn;

  UserImagePicker(this.imagePickerFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  Future<void> _selectImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: imageSource, imageQuality: 50, maxWidth: 150,);

    setState(() {
      _pickedImage = File(imageFile.path);
    });
    widget.imagePickerFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
          _pickedImage != null ? FileImage(_pickedImage) : null,
          radius: 40,
        ),
        FlatButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      AlertDialog(
                        title: Text("Image Picker"),
                        content: Text("Select mode for image picker "),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Gallery"),
                            onPressed: () {
                              _selectImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Camera"),
                            onPressed: () {
                              _selectImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
            },
            textColor: Theme
                .of(context)
                .primaryColor,
            icon: Icon(Icons.image),
            label: Text("Add Image")),
      ],
    );
  }
}
