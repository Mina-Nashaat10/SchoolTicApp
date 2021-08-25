import 'package:SchoolTic/models/course.dart';
import 'package:SchoolTic/models/person.dart';
import 'package:SchoolTic/models/proffessor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CourseDetail extends StatefulWidget {
  String courseName, courseCategory;
  CourseDetail();
  CourseDetail.withData(this.courseName, this.courseCategory);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CourseDetail(this.courseName, this.courseCategory);
  }
}

class _CourseDetail extends State<CourseDetail> {
  String courseName, courseCategory;
  _CourseDetail(this.courseName, this.courseCategory);
  var stuNo = TextEditingController();
  DateTime startSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Course Detail"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, right: 5, left: 5, bottom: 10),
                child: textField(
                    'Max Number of Student',
                    'Max Number of Student',
                    'Max Number of Student is Required',
                    TextInputType.number,
                    Icon(Icons.format_list_numbered),
                    stuNo),
              ),
              Text(
                "Start Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                margin: EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 15),
                child: CupertinoDatePicker(
                  maximumYear: startSelectedDate.year + 10,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(startSelectedDate.year,
                      startSelectedDate.month, startSelectedDate.day),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      startSelectedDate = newDateTime;
                    });
                  },
                ),
              ),
              Text(
                "End Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                margin: EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 25),
                child: CupertinoDatePicker(
                  maximumYear: endSelectedDate.year + 10,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(endSelectedDate.year,
                      endSelectedDate.month, endSelectedDate.day),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      endSelectedDate = newDateTime;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  color: Colors.lightBlue,
                  padding:
                      EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 10),
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (stuNo.text.isEmpty) {
                      snackBar("Please Enter Number OF Student");
                    } else
                      checkDate();
                  },
                ),
              )
            ],
          ),
        ));
  }

  Widget textField(String hintMsg, String label, String errorMsg,
      TextInputType inputType, Icon icon, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        keyboardType: inputType,
        cursorColor: Colors.black,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintMsg,
          labelText: label,
          hintStyle: TextStyle(color: Colors.black, fontSize: 10),
          prefixIcon: icon,
          labelStyle: TextStyle(color: Colors.black, fontSize: 15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), gapPadding: 20),
          errorStyle: TextStyle(color: Colors.black),
        ),
        obscureText: false,
        validator: (value) {
          if (value.isEmpty) {
            return errorMsg;
          }
          return null;
        },
      ),
    );
  }

  void checkDate() async {
    DateTime dateTime = DateTime.now();
    if (startSelectedDate.year < dateTime.year) {
      snackBar("Please Enter Legal Date...");
      return;
    } else if (startSelectedDate.year == dateTime.year &&
        startSelectedDate.month < dateTime.month) {
      snackBar("Please Enter Legal Date...");
      return;
    } else if (startSelectedDate.year == dateTime.year &&
        startSelectedDate.month == dateTime.month &&
        startSelectedDate.day < dateTime.day) {
      snackBar("Please Enter Legal Date...");
      return;
    } else {
      if (endSelectedDate.year < startSelectedDate.year) {
        snackBar("Please Enter Legal Date...");
        return;
      } else {
        if (endSelectedDate.year == startSelectedDate.year) {
          if (endSelectedDate.month < startSelectedDate.month) {
            snackBar("Please Enter Legal Date...");
            return;
          } else if (endSelectedDate.month == startSelectedDate.month) {
            if (endSelectedDate.day <= startSelectedDate.day) {
              snackBar("Please Enter Legal Date...");
              return;
            }
          }
        }
      }
    }

    var auth = FirebaseAuth.instance.currentUser;
    String proname;
    await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: auth.email)
        .get()
        .then((value) {
      var person = Person();
      value.docs.forEach((element) {
        person = person.toObject(element.data());
        proname = person.fullName;
      });
    });
    var pro = Professor();
    var course = Course();
    course.name = courseName;
    course.professorEmail = auth.email;
    course.professorName = proname;
    course.noOfStudents = 0;
    course.startDay = startSelectedDate.day.toString();
    course.startMonth = startSelectedDate.month.toString();
    course.startYear = startSelectedDate.year.toString();

    course.endDay = endSelectedDate.day.toString();
    course.endMonth = endSelectedDate.month.toString();
    course.endYear = endSelectedDate.year.toString();
    course.dept = courseCategory;
    course.maxStudents = int.parse(stuNo.text);
    await pro.addCourse(course).then((value) {
      if (value == "Added Successfully") {
        snackBar("Course Added Successfully...");
        Navigator.pushNamedAndRemoveUntil(
            context, '/professor_home', (route) => false);
      } else {
        snackBar(value);
      }
    });
  }

  void snackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
