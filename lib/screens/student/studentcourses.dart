import 'package:SchoolTic/models/course.dart';
import 'package:SchoolTic/screens/student/coursedetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SchoolTic/models/studentcourse.dart';

class MyCoursesStudent extends StatefulWidget {
  @override
  _StudentCoursesState createState() => _StudentCoursesState();
}

class _StudentCoursesState extends State<MyCoursesStudent> {
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

  Future<Course> getCourse(String proEmail, String name) async {
    Course c = Course();
    await fireStore
        .collection("courses")
        .where('progmail', isEqualTo: proEmail)
        .where('name', isEqualTo: name)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        c = c.toObject(element.data());
      });
    });
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("My Courses"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          Widget widget;
          if (courses.length == 0) {
            widget = Scaffold(
              body: Center(
                child: Text(
                  "No Found Any Courses",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            widget = ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Icon(Icons.school),
                    title: Text(snapshot.data[index].courseName + " Course"),
                    subtitle: Text(
                        "Professor " + snapshot.data[index].professorName,
                        style: TextStyle(color: Colors.orangeAccent)),
                    trailing: RaisedButton(
                      color: Colors.lightBlueAccent,
                      child: Text(
                        "Detail",
                      ),
                      onPressed: () {
                        getCourse(snapshot.data[index].professorEmail,
                                snapshot.data[index].courseName)
                            .then((value) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return CourseDetail(value, true);
                            },
                          ));
                        });
                      },
                    ));
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
