import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernamecontroller = TextEditingController();
    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();

    void register() async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      final String username = usernamecontroller.text;
      final String email = emailcontroller.text;
      final String password = passwordcontroller.text;

      try {
        final UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await firestore
            .collection("users")
            .doc(user.user.uid)
            .set({"email": email, "username": username});

        print("user is registered");
      } catch (e) {}
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SafeArea(
            child: Column(
          children: [
            TextField(
              controller: usernamecontroller,
              decoration: InputDecoration(hintText: 'Enter username'),
            ),
            SizedBox(
              height: 10,
            ),
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
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: register, child: Text("Registered")),
          ],
        )),
      ),
    );
  }
}
