import 'package:school_tic/models/studentcourse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowStudents extends StatefulWidget {
  String proEmail, courseName;
  ShowStudents(this.proEmail, this.courseName);
  @override
  _StudentCourseState createState() =>
      _StudentCourseState(this.proEmail, this.courseName);
}

class _StudentCourseState extends State<ShowStudents> {
  String proEmail, courseName;
  _StudentCourseState(this.proEmail, this.courseName);
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<StudentCourse> stu = List<StudentCourse>();
  Future getData() async {
    stu = List<StudentCourse>();
    await fireStore
        .collection("studentcourses")
        .where('progmail', isEqualTo: proEmail)
        .where('coursename', isEqualTo: courseName)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        StudentCourse studentcourse = StudentCourse();
        studentcourse = studentcourse.toObject(element.data());
        stu.add(studentcourse);
      });
    });
    return stu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = ListView.builder(
              itemCount: stu.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    snapshot.data[index].studentName.toString().toUpperCase(),
                    style: TextStyle(fontFamily: "Ranga", fontSize: 25),
                  ),
                );
              },
            );
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
