import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/person.dart';

class CropImage extends StatefulWidget {
  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  File selectedImage;
  bool wait = false;
  Future<void> pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: selected.path,
          aspectRatio: CropAspectRatio(ratioX: 0.1, ratioY: 0.1),
          compressQuality: 100,
          maxWidth: 200,
          maxHeight: 200);
      this.setState(() {
        selectedImage = cropped;
      });
      setState(() {
        wait = true;
      });
      String email = FirebaseAuth.instance.currentUser.email;
      StorageReference reference = FirebaseStorage.instance
          .ref()
          .child("users/" + email + "/" + "user.png");
      StorageUploadTask uploadTask =
          reference.putData(cropped.readAsBytesSync());
      String url = await (await uploadTask.onComplete).ref.getDownloadURL();
      navigate(email, context);
    }
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
          Navigator.pushNamed(myContext, "/student_home");
        } else {
          Navigator.pushNamed(myContext, "/professor_home");
        }
      });
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (wait == false) {
      return Scaffold(
        key: scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getImageWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  color: Colors.green,
                  child: Text(
                    "gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      wait = true;
                    });
                    String email = FirebaseAuth.instance.currentUser.email;
                    Uint8List file =
                        (await rootBundle.load("assets/images/user.png"))
                            .buffer
                            .asUint8List();
                    StorageReference reference = FirebaseStorage.instance
                        .ref()
                        .child("users/" + email + "/" + "user.png");
                    StorageUploadTask uploadTask = reference.putData(file);
                    String url = await (await uploadTask.onComplete)
                        .ref
                        .getDownloadURL();
                    navigate(email, context);
                  },
                  color: Colors.green,
                  child: Text(
                    "Default Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Scaffold(
          key: scaffoldKey,
          body: Center(
            child: CircularProgressIndicator(),
          ));
    }
  }

  Widget getImageWidget() {
    if (selectedImage == null) {
      return Image.asset(
        "assets/images/user.png",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        selectedImage,
        width: 300,
        height: 300,
      );
    }
  }
}
