import 'package:SchoolTic/models/studentcourse.dart';
import 'package:SchoolTic/screens/student/showmaterial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoursesMaterials extends StatefulWidget {
  @override
  _CoursesMaterialsState createState() => _CoursesMaterialsState();
}

class _CoursesMaterialsState extends State<CoursesMaterials> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<StudentCourse> courses = List<StudentCourse>();
  String email = FirebaseAuth.instance.currentUser.email;
  Future getData() async {
    List<StudentCourse> co = List<StudentCourse>();
    await fireStore
        .collection("studentcourses")
        .where('studentgmail', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        StudentCourse student = StudentCourse();
        co.add(student.toObject(element.data()));
      });
      setState(() {
        courses = co;
      });
    });
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Courses Materials"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            if (courses.length == 0) {
              widget = Center(
                child: Text(
                  "No Found Any Materials...",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              );
            } else {
              widget = ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Icon(Icons.school),
                      title: Text(snapshot.data[index].courseName + " Course"),
                      subtitle: Text(
                          "Proffessor " + snapshot.data[index].professorName,
                          style: TextStyle(color: Colors.orangeAccent)),
                      trailing: RaisedButton(
                        color: Colors.lightBlueAccent,
                        child: Text(
                          "Materials",
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ShowMaterial(
                                  snapshot.data[index].professorEmail,
                                  snapshot.data[index].courseName);
                            },
                          ));
                        },
                      ));
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
