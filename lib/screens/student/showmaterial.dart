import 'package:SchoolTic/models/material.dart';
import 'package:SchoolTic/screens/proffesor/pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowMaterial extends StatefulWidget {
  String proEmail, courseName;
  ShowMaterial(this.proEmail, this.courseName);
  @override
  _ShowMaterialState createState() =>
      _ShowMaterialState(this.proEmail, this.courseName);
}

class _ShowMaterialState extends State<ShowMaterial> {
  String proEmail, courseName;
  _ShowMaterialState(this.proEmail, this.courseName);
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<CoursesMaterial> materials = List<CoursesMaterial>();

  Future getData() async {
    List<CoursesMaterial> m = List<CoursesMaterial>();

    await fireStore
        .collection("materials")
        .where('coursename', isEqualTo: courseName)
        .where('progmail', isEqualTo: proEmail)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        CoursesMaterial material = CoursesMaterial();
        m.add(material.toObject(element.data()));
      });
      setState(() {
        materials = m;
      });
    });
    return materials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Course Material"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            if (materials.length == 0) {
              widget = Center(
                child: Text(
                  "No Found Any Materials...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            } else {
              widget = ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.school),
                    title: Text(snapshot.data[index].courseName),
                    subtitle: Text(
                        snapshot.data[index].path.toString().split('/').last),
                    trailing: IconButton(
                      icon: Icon(Icons.folder_open),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewer.withData(
                                  snapshot.data[index].path,
                                  snapshot.data[index].path
                                      .toString()
                                      .split('/')
                                      .last),
                            ));
                      },
                    ),
                  );
                },
              );
            }
          } else {
            widget = Center(
              child: CircularProgressIndicator(),
            );
          }

          return widget;
        },
      ),
    );
  }
}
