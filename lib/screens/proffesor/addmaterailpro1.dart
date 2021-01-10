import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SchoolTic/models/course.dart';

import 'addmaterail2.dart';

class ShowCourses extends StatefulWidget {
  @override
  _ShowCourses createState() => _ShowCourses();
}

class _ShowCourses extends State<ShowCourses> {
  Future<List<Course>> courses;
  int length;
  Future<List<Course>> getData() async {
    List<Course> myCourses = List<Course>();
    var fireStore = FirebaseFirestore.instance;
    var auth = FirebaseAuth.instance.currentUser;
    await fireStore
        .collection("courses")
        .where("progmail", isEqualTo: auth.email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var course = Course();
        course = course.toObject(element.data());
        myCourses.add(course);
      });
    });
    length = myCourses.length;
    return myCourses;
  }

  initialData() {
    courses = Future<List<Course>>(() => getData());
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialData(),
      builder: (context, snapshot) {
        Widget widget;
        if (length == 0) {
          widget = Scaffold(
            appBar: AppBar(
              title: Text("My Courses"),
            ),
            body: Center(
              child: Text(
                "No Found Any Materials",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          widget = Scaffold(
              appBar: AppBar(
                title: Text("My Courses"),
              ),
              body: Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading: Icon(Icons.school),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].dept),
                        trailing: Container(
                          width: 113,
                          height: 35,
                          child: RaisedButton(
                            color: Colors.lightBlueAccent,
                            child: Text("Add Material"),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return AddMaterial.withData(
                                    snapshot.data[index].name,
                                    snapshot.data[index].dept);
                              }));
                            },
                          ),
                        ));
                  },
                ),
              ));
        } else if (snapshot.hasError) {
          widget = Scaffold(
            appBar: AppBar(
              title: Text("My Courses"),
            ),
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else {
          widget = Scaffold(
            appBar: AppBar(
              title: Text("My Courses"),
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
