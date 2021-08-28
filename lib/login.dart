// import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailcontroller =
        TextEditingController(text: "fatimazubair@gmail.com");
    final TextEditingController passwordcontroller =
        TextEditingController(text: "12345678");

    void login() async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      final String email = emailcontroller.text;
      final String password = passwordcontroller.text;

      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        final DocumentSnapshot snapshot =
            await firestore.collection("users").doc(user.user.uid).get();
        print("user is logged in");
        final data = snapshot.data();
        print(data["username"]);
        print(data["email"]);

        Navigator.of(context).pushNamed("/home");
      } catch (e) {
        print("error");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(e.message),
              );
            });
        print(e.message);
      }
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SafeArea(
            child: Column(
          children: [
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordcontroller,
              decoration: InputDecoration(hintText: 'Enter Passcode'),
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: login, child: Text("login")),
                  ElevatedButton(onPressed: () {}, child: Text("register")),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
