import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SchoolTic/models/person.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void checkImageProfile(BuildContext myContext) {
    Timer(Duration(seconds: 2), () {
      Firebase.initializeApp().whenComplete(() async {
        FirebaseAuth auth = FirebaseAuth.instance;
        var result = auth.currentUser;
        if (result == null) {
          Navigator.pushNamed(myContext, "/login");
        } else {
          String email = FirebaseAuth.instance.currentUser.email;
          try {
            await FirebaseStorage.instance
                .ref()
                .child("users/" + email + "/" + "user.png")
                .getDownloadURL();
            navigate(result.email, context);
          } on Exception catch (error) {
            Navigator.pushNamed(context, '/image_profile');
          }
        }
      });
    });
  }

  void navigate(String email, BuildContext myContext) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var person = Person();
        person = person.toObject(element.data());
        if (person.userType == "Student") {
          Navigator.pushNamedAndRemoveUntil(
              context, '/student_home', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/professor_home', (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    checkImageProfile(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: Image.asset('assets/images/splash1.png'),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "School Tic",
              style: TextStyle(
                  color: Colors.white, fontSize: 27, fontFamily: "Lobster"),
            ),
          ),
        ],
      ),
    );
  }
}
