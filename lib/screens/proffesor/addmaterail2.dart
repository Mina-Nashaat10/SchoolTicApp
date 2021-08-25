import 'dart:io';

import 'package:SchoolTic/models/material.dart';
import 'package:SchoolTic/screens/proffesor/pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddMaterial extends StatefulWidget {
  String name, dept;
  AddMaterial();
  AddMaterial.withData(this.name, this.dept);
  @override
  _AddMaterialState createState() => _AddMaterialState(name, dept);
}

class _AddMaterialState extends State<AddMaterial> {
  String name, dept;
  _AddMaterialState(this.name, this.dept);
  Future getPdf() async {
    try {
      File file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'png']);
      String filename = file.path.split('/').last;

      //Save File To Firebase FireStore
      var email = FirebaseAuth.instance.currentUser.email;
      CoursesMaterial material = CoursesMaterial();
      material.path =
          "materials/" + email + "/" + dept + "/" + name + "/" + filename;
      material.courseName = name;
      material.proEmail = email;
      await FirebaseFirestore.instance
          .collection("materials")
          .add(material.toMap(material));

      // Save File To Firebase Storage.
      StorageReference reference = FirebaseStorage.instance.ref().child(
          "materials/" + email + "/" + dept + "/" + name + "/" + filename);
      var snackbar = SnackBar(
        content: Text("File Upload in progress"),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
      StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());
      String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    } catch (error) {
      print(error.message);
    }
  }

  List<CoursesMaterial> materials = List<CoursesMaterial>();
  Future getFiles() async {
    List<CoursesMaterial> s = List<CoursesMaterial>();
    var email = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection("materials")
        .where('coursename', isEqualTo: name)
        .where('progmail', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        CoursesMaterial material = CoursesMaterial();
        s.add(material.toObject(element.data()));
      });
    });
    setState(() {
      materials = s;
    });
    return materials;
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFiles(),
      builder: (context, snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          if (materials.length == 0) {
            widget = Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text("Add Materail"),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  getPdf();
                },
                child: Icon(Icons.add),
              ),
              body: Center(
                child: Text(
                  "No Any Material",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          } else {
            widget = Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: Text("Add Materail"),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    getPdf();
                  },
                  child: Icon(Icons.add),
                ),
                body: ListView.builder(
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: type(snapshot.data[index].path),
                      title: Text(fileName(snapshot.data[index].path)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PdfViewer.withData(snapshot.data[index].path,
                              fileName(snapshot.data[index].path));
                        }));
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          var alertDialog = AlertDialog(
                            title: Text("Message"),
                            content: Text(
                                "do you want to delete this material " +
                                    snapshot.data[index].path
                                        .toString()
                                        .split("/")
                                        .last),
                            actions: [
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  deleteMaterial(snapshot.data[index].path);
                                  var snackBar = SnackBar(
                                    content: Text(snapshot.data[index].path
                                            .toString()
                                            .split("/")
                                            .last +
                                        " is Deleted...."),
                                  );
                                  scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                              )
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (context) => alertDialog,
                          );
                        },
                      ),
                    );
                  },
                ));
          }
        } else {
          widget = Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("Add Materail"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return widget;
      },
    );
  }

  void deleteMaterial(String path) async {
    await FirebaseStorage.instance.ref().child(path).delete();
    await FirebaseFirestore.instance
        .collection("materials")
        .where('path', isEqualTo: path)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("materials")
          .doc(value.docs[0].id)
          .delete();
    });
  }

  Icon type(String url) {
    String s = url.split("/").last;
    s = s.split(".").last;
    switch (s) {
      case 'pdf':
        return Icon(Icons.picture_as_pdf);
        break;
      case 'jpg':
        return Icon(Icons.image);
        break;
      case 'jpeg':
        return Icon(Icons.image);
        break;
      case 'png':
        return Icon(Icons.image);
        break;
    }
    return null;
  }

  String fileName(String url) {
    String s = url.split("/").last;
    return s;
  }
}
