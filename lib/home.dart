import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fbagain/post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class Multi extends StatefulWidget {
  @override
  _MultiState createState() => _MultiState();
}

class _MultiState extends State<Multi> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String imagepath;
  Stream PostStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    void pickimage() async {
      final ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.getImage(source: ImageSource.gallery);

      setState(() {
        imagepath = image.path;
      });
    }

    void submit() async {
      try {
        String title = titlecontroller.text;
        String description = descriptioncontroller.text;

        String imageurl = path.basename(imagepath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageurl');

        File file = File(imagepath);
        await ref.putFile(file);

        String dounlaodURL = await ref.getDownloadURL();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection("posts").add(
            {"url": dounlaodURL, "title": title, "description": description});

        print("posts successfully uploaded");
        titlecontroller.clear();
        descriptioncontroller.clear();
      } catch (e) {
        print(e.message);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(hintText: 'Enter title'),
            ),
            TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(hintText: 'Enter description'),
            ),
            ElevatedButton(onPressed: pickimage, child: Text("pick image")),
            ElevatedButton(onPressed: submit, child: Text("submit post")),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: PostStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map data = document.data();
                        String id = document.id;
                        data["id"] = id;

                        return Posts(
                          data: data,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
