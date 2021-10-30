import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_tic/models/course.dart';
import 'package:school_tic/models/proffessor.dart';

// ignore: must_be_immutable
class UpdateCourse extends StatefulWidget {
  Course c;
  UpdateCourse(this.c);
  @override
  _UpdateCourseState createState() => _UpdateCourseState(this.c);
}

class _UpdateCourseState extends State<UpdateCourse> {
  Course course;
  _UpdateCourseState(this.course);

  initialData() {
    stuNo.text = course.maxStudents.toString();
    startSelectedDate = DateTime(int.parse(course.startYear),
        int.parse(course.startMonth), int.parse(course.startDay));
    endSelectedDate = DateTime(int.parse(course.endYear),
        int.parse(course.endMonth), int.parse(course.endDay));
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime startSelectedDate;
  DateTime endSelectedDate;
  var stuNo = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Update Course"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, right: 5, left: 5, bottom: 10),
                child: textField(
                    'Max Number of Student',
                    'Max Number Student',
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
                  initialDateTime: DateTime(int.parse(course.startYear),
                      int.parse(course.startMonth), int.parse(course.startDay)),
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
                  initialDateTime: DateTime(int.parse(course.endYear),
                      int.parse(course.endMonth), int.parse(course.endDay)),
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
                    "Update",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (stuNo.text.isEmpty) {
                      snackBar("Please Enter Number OF Student");
                    }
                    checkDate();
                  },
                ),
              )
            ],
          ),
        ));
  }

  void checkDate() {
    if (startSelectedDate.year < DateTime.now().year) {
      snackBar("Please Enter Legal Date...");
      return;
    } else if ((startSelectedDate.month < DateTime.now().month ||
            startSelectedDate.day < DateTime.now().day) &&
        startSelectedDate.year < DateTime.now().year) {
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

    var c = Course();
    c.name = course.name;
    c.professorEmail = course.professorEmail;
    c.professorName = course.professorName;

    c.startDay = startSelectedDate.day.toString();
    c.startMonth = startSelectedDate.month.toString();
    c.startYear = startSelectedDate.year.toString();

    c.endDay = endSelectedDate.day.toString();
    c.endMonth = endSelectedDate.month.toString();
    c.endYear = endSelectedDate.year.toString();
    c.dept = course.dept;
    c.noOfStudents = course.noOfStudents;
    c.maxStudents = int.parse(stuNo.text);
    var pro = Professor();
    pro.updateCourse(c);
    snackBar("Course Updated Successfully...");
    Navigator.pushReplacementNamed(context, "/show_course_detail",
        arguments: c);
  }

  void snackBar(String msg) {
    var snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
    );
    scaffoldKey.currentState.showSnackBar(snack);
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
}
