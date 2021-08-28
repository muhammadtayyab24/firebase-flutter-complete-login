import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditDoilog extends StatefulWidget {
  final Map data;
  EditDoilog({this.data});
  @override
  _EditDoilogState createState() => _EditDoilogState();
}

class _EditDoilogState extends State<EditDoilog> {
  String imagepath;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titlecontroller.text = widget.data["title"];
    descriptioncontroller.text = widget.data["title"];
  }

  @override
  Widget build(BuildContext context) {
    void pickimage() async {
      final ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.getImage(source: ImageSource.gallery);

      setState(() {
        imagepath = image.path;
      });
    }

    void done() async {
      try {
        String imageurl = path.basename(imagepath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageurl');

        File file = File(imagepath);
        await ref.putFile(file);

        String dounlaodURL = await ref.getDownloadURL();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        Map<String, dynamic> newpost = {
          "title": titlecontroller.text,
          "description": descriptioncontroller.text,
          "url": dounlaodURL,
        };

        await firestore.collection("posts").doc(widget.data["id"]).set(newpost);
        Navigator.of(context).pop();
      } catch (e) {}
    }

    return Container(
        child: AlertDialog(
            content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Post Editing"),
        TextField(
          controller: titlecontroller,
          decoration: InputDecoration(hintText: 'Enter title'),
        ),
        TextField(
          controller: descriptioncontroller,
          decoration: InputDecoration(hintText: 'Enter description'),
        ),
        ElevatedButton(onPressed: pickimage, child: Text("pick image")),
        ElevatedButton(onPressed: done, child: Text("done")),
      ],
    )));
  }
}
