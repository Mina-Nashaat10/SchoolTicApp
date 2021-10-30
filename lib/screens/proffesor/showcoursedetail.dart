import 'package:school_tic/models/course.dart';
import 'package:school_tic/models/proffessor.dart';
import 'package:school_tic/screens/proffesor/StudentCourse.dart';
import 'package:school_tic/screens/proffesor/updatecourse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowCourseDetail extends StatefulWidget {
  String name, dept;
  ShowCourseDetail();
  ShowCourseDetail.withData(this.name, this.dept);

  @override
  _ShowCourseDetailState createState() =>
      _ShowCourseDetailState.withData(name, dept);
}

class _ShowCourseDetailState extends State<ShowCourseDetail> {
  String name, dept;
  _ShowCourseDetailState();
  _ShowCourseDetailState.withData(this.name, this.dept);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var c;
  Future<Course> getData() async {
    c = ModalRoute.of(context).settings.arguments;
    if (c == null) {
      c = Course();
      var email = FirebaseAuth.instance.currentUser.email;
      await FirebaseFirestore.instance
          .collection("courses")
          .where("progmail", isEqualTo: email)
          .where("name", isEqualTo: name)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          c = c.toObject(element.data());
        });
      });
    }
    return c;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          widget = Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text("Course Detail")),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 20, left: 20),
                        color: Colors.pinkAccent,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UpdateCourse(c);
                          }));
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 20, left: 20),
                        color: Colors.pinkAccent,
                        onPressed: () {
                          var alertDialog = AlertDialog(
                            title: Text("Delete Course ?"),
                            content: Text("You Are Sure To Delete " +
                                snapshot.data.name.toString() +
                                " Course ?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  var pro = Professor();
                                  pro.deleteCourse(
                                      snapshot.data.name.toString());
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.redAccent),
                                ),
                              ),
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (context) => alertDialog,
                          );
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.school,
                          color: Colors.teal[900],
                        ),
                        title: Text(
                          snapshot.data.name.toString(),
                          style: TextStyle(
                              fontFamily: 'Ranga',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.category,
                          color: Colors.teal[900],
                        ),
                        title: Text(
                          snapshot.data.dept.toString(),
                          style: TextStyle(
                              fontFamily: 'Ranga',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.format_list_numbered,
                          color: Colors.teal[900],
                        ),
                        title: Text(
                          "Max No Of Student : " +
                              snapshot.data.maxStudents.toString(),
                          style: TextStyle(
                              fontFamily: 'Ranga',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.format_list_numbered,
                          color: Colors.teal[900],
                        ),
                        title: Text(
                          "Number Of Student : " +
                              snapshot.data.noOfStudents.toString(),
                          style: TextStyle(
                              fontFamily: 'Ranga',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            if (int.parse(
                                    snapshot.data.noOfStudents.toString()) ==
                                0) {
                              var snackbar = SnackBar(
                                content: Text(
                                    "No Students Registered to this Course"),
                              );
                              scaffoldKey.currentState.showSnackBar(snackbar);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowStudents(
                                        snapshot.data.professorEmail,
                                        snapshot.data.name),
                                  ));
                            }
                          },
                          icon: Icon(Icons.arrow_forward),
                        ),
                      )),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.timelapse,
                          color: Colors.teal[900],
                        ),
                        title: Text(
                          "Start : " +
                              snapshot.data.startDay.toString() +
                              "/" +
                              snapshot.data.startMonth.toString() +
                              "/" +
                              snapshot.data.startYear.toString(),
                          style: TextStyle(
                              fontFamily: 'Ranga',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.timelapse,
                          color: Colors.teal[900],
                        ),
                        title: Text(
                          "End : " +
                              snapshot.data.endDay.toString() +
                              "/" +
                              snapshot.data.endMonth.toString() +
                              "/" +
                              snapshot.data.endYear.toString(),
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
          widget = Scaffold(
            appBar: AppBar(
              title: Text("Course Detail"),
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
}
