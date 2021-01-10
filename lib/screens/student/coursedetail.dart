import 'package:SchoolTic/models/person.dart';
import 'package:SchoolTic/models/student.dart';
import 'package:SchoolTic/models/studentcourse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SchoolTic/models/course.dart';

// ignore: must_be_immutable
class CourseDetail extends StatefulWidget {
  Course course = Course();
  bool studentCourse;
  CourseDetail(this.course, [this.studentCourse]);
  @override
  _CourseDetailState createState() =>
      _CourseDetailState(this.course, this.studentCourse);
}

class _CourseDetailState extends State<CourseDetail> {
  Course course = Course();
  bool studentCourse = false;
  _CourseDetailState(this.course, [this.studentCourse]);

  @override
  Widget build(BuildContext context) {
    if (studentCourse) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Course Detail"),
        ),
        backgroundColor: Colors.blue[300],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/lang.jfif'),
                  radius: 80.0,
                ),
              ),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SourceSansPro',
                  color: Colors.red[400],
                  letterSpacing: 2.5,
                ),
              ),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.school,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Course : " + course.name,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.school,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Department : " + course.dept,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Proffessor : " + course.professorName,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Start Date : " +
                          course.startDay +
                          "/" +
                          course.startMonth +
                          "/" +
                          course.startYear,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "End Date : " +
                          course.endDay +
                          "/" +
                          course.endMonth +
                          "/" +
                          course.endYear,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Course Detail"),
        ),
        backgroundColor: Colors.blue[300],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/lang.jfif'),
                  radius: 80.0,
                ),
              ),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SourceSansPro',
                  color: Colors.red[400],
                  letterSpacing: 2.5,
                ),
              ),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.school,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Course : " + course.name,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.school,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Department : " + course.dept,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Proffessor : " + course.professorName,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "Start Date : " +
                          course.startDay +
                          "/" +
                          course.startMonth +
                          "/" +
                          course.startYear,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "End Date : " +
                          course.endDay +
                          "/" +
                          course.endMonth +
                          "/" +
                          course.endYear,
                      style: TextStyle(
                          fontFamily: 'Ranga',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  padding:
                      EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  onPressed: () {
                    Student s = Student();
                    getStudentName().then((value) {
                      s.registerCourse(course, value);
                    });
                    Navigator.pushNamed(context, "/student_home");
                  },
                  child: Text(
                    "Join",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<String> getStudentName() async {
    String name;
    String email = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var person = Person();
        person = person.toObject(element.data());
        name = person.fullName;
      });
    });
    return name;
  }
}
