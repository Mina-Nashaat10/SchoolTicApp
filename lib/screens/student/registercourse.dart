import 'package:school_tic/models/course.dart';
import 'package:school_tic/models/studentcourse.dart';
import 'package:school_tic/screens/student/coursedetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterCourse extends StatefulWidget {
  @override
  _RegisterCourseState createState() => _RegisterCourseState();
}

class _RegisterCourseState extends State<RegisterCourse> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Course> courses = List<Course>();
  Future getData() async {
    List<Course> c = List<Course>();
    await fireStore.collection("courses").get().then((value) {
      value.docs.forEach((element) {
        var course = Course();
        course = course.toObject(element.data());
        c.add(course);
      });
      courses = c;
    });
    return courses;
  }

  Future<List<StudentCourse>> registerCourses() async {
    List<StudentCourse> courses = List<StudentCourse>();
    String email = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection("studentcourses")
        .where('studentgmail', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var studentCourse = StudentCourse();
        courses.add(studentCourse.toObject(element.data()));
      });
    });
    return courses;
  }

  Future<bool> checkNumberOfStudent(
      String professorEmail, String courseName) async {
    bool isAvailable;
    await FirebaseFirestore.instance
        .collection("courses")
        .where('progmail', isEqualTo: professorEmail)
        .where('name', isEqualTo: courseName)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var course = Course();
        course = course.toObject(element.data());
        if (int.parse(course.noOfStudents.toString()) + 1 >
            int.parse(course.maxStudents.toString())) {
          isAvailable = false;
        } else {
          isAvailable = true;
        }
      });
    });
    return isAvailable;
  }

  Future<Course> getCourse(String progmail, String coursename) async {
    Course co = Course();
    await FirebaseFirestore.instance
        .collection("courses")
        .where('progmail', isEqualTo: progmail)
        .where('name', isEqualTo: coursename)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        co = co.toObject(element.data());
      });
    });
    return co;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Register Courses"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            if (courses.length == 0) {
              widget = Center(
                  child: Text(
                "No Found Any Courses To join...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ));
            } else {
              widget = ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.school),
                    title: Text(
                      snapshot.data[index].name + " Course",
                    ),
                    subtitle: Text(
                        "Add By Professor " +
                            snapshot.data[index].professorName
                                .toString()
                                .toUpperCase(),
                        style: TextStyle(color: Colors.orangeAccent)),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.blue,
                      iconSize: 28,
                      onPressed: () {
                        bool isRegistered = false;
                        registerCourses().then((value) {
                          value.forEach((element) {
                            if (element.professorEmail ==
                                    snapshot.data[index].professorEmail &&
                                element.courseName ==
                                    snapshot.data[index].name) {
                              isRegistered = true;
                            }
                          });
                          if (isRegistered == true) {
                            var snackBar = SnackBar(
                              content: Text(
                                  "This course has been previously registered"),
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            checkNumberOfStudent(
                                    snapshot.data[index].professorEmail,
                                    snapshot.data[index].name)
                                .then((value) {
                              if (value == true) {
                                getCourse(snapshot.data[index].professorEmail,
                                        snapshot.data[index].name)
                                    .then((value) {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return CourseDetail(value, false);
                                  }));
                                });
                              } else {
                                var snackbar = SnackBar(
                                  content: Text("The Course is Complete"),
                                );
                                scaffoldKey.currentState.showSnackBar(snackbar);
                              }
                            });
                          }
                        });
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
        future: getData(),
      ),
    );
  }
}
