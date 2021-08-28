import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbagain/editpost.dart';
import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  final Map data;
  Posts({this.data});

  @override
  Widget build(BuildContext context) {
    void deletepost() async {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection("posts").doc(data["id"]).delete();
      } catch (e) {
        print(e.message);
      }
    }

    void editpost() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return EditDoilog(
              data: data,
            );
          });
    }

    return Container(
      child: Column(
        children: [
          Image.network(
            data["url"],
            width: 100,
            height: 100,
          ),
          Text(data["title"]),
          Text(data["description"]),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: deletepost, child: Text("delete")),
                ElevatedButton(onPressed: editpost, child: Text("edit"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
