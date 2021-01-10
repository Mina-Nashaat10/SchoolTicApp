import 'package:SchoolTic/models/course.dart';
import 'package:SchoolTic/screens/proffesor/coursedetailpro.dart';
import 'package:SchoolTic/screens/proffesor/showcoursedetail.dart';
import 'package:SchoolTic/screens/student/coursedetail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfessorHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfessorHome();
  }
}

class _ProfessorHome extends State<ProfessorHome> {
  String name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<String> getData() async {
    FirebaseMessaging _fcm = FirebaseMessaging();

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      if (message['data']['page'] == 'registercourse') {
        String email = FirebaseAuth.instance.currentUser.email;
        Course course = new Course();
        await FirebaseFirestore.instance
            .collection("courses")
            .where('name', isEqualTo: message['data']['name'])
            .where('progmail', isEqualTo: email)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            course = course.toObject(element.data());
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowCourseDetail.withData(
                    message['data']['name'], course.dept),
              ));
        });
      }
    }, onResume: (message) async {
      if (message['data']['page'] == 'registercourse') {
        String email = FirebaseAuth.instance.currentUser.email;
        Course course = new Course();
        await FirebaseFirestore.instance
            .collection("courses")
            .where('name', isEqualTo: message['data']['name'])
            .where('progmail', isEqualTo: email)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            course = course.toObject(element.data());
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowCourseDetail.withData(
                    message['data']['name'], course.dept),
              ));
        });
      }
    }, onLaunch: (message) async {
      if (message['data']['page'] == 'registercourse') {
        String email = FirebaseAuth.instance.currentUser.email;
        Course course = new Course();
        await FirebaseFirestore.instance
            .collection("courses")
            .where('name', isEqualTo: message['data']['name'])
            .where('progmail', isEqualTo: email)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            course = course.toObject(element.data());
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowCourseDetail.withData(
                    message['data']['name'], course.dept),
              ));
        });
      }
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    var result = auth.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: result.email)
        .get()
        .then((value) {
      Map<String, dynamic> map = value.docs.single.data();
      name = map['name'];
    });
    return name;
  }

  List<String> images = [
    "assets/images/educ5.jpg",
    "assets/images/educ1.jpg",
    "assets/images/educ2.jpg",
    "assets/images/educ3.jpg",
    "assets/images/educ4.jpg"
  ];
  String url;
  String email;
  Future<String> getImageProfile() async {
    email = FirebaseAuth.instance.currentUser.email;
    await FirebaseStorage.instance
        .ref()
        .child("users/" + email + "/user.png")
        .getDownloadURL()
        .then((value) {
      url = value;
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<String>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget widget;
        if (!snapshot.hasData) {
          widget = Scaffold(
            appBar: AppBar(
              title: Text("Home"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          widget = FutureBuilder(
            future: getImageProfile(),
            builder: (context, snapshot) {
              Widget widget;
              if (snapshot.hasData) {
                widget = Scaffold(
                    appBar: AppBar(
                      title: Text("Home"),
                    ),
                    drawer: Drawer(
                      child: ListView(
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/drawerheader.jpeg'),
                                    fit: BoxFit.cover)),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 75,
                                    height: 75,
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(url),
                                      backgroundColor: Colors.transparent,
                                    )),
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontFamily: "Lobster", fontSize: 18),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                      fontFamily: "Lobster", fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.home,
                              color: Colors.blue,
                            ),
                            title: Text("Home"),
                            onTap: () {
                              Navigator.pushNamed(context, "/professor_home");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.school,
                              color: Colors.blue,
                            ),
                            title: Text("Add Course"),
                            onTap: () {
                              Navigator.pushNamed(context, "/select_courses");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.school,
                              color: Colors.blue,
                            ),
                            title: Text("My Courses"),
                            onTap: () {
                              Navigator.pushNamed(context, "/MyCoursesPro");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.book,
                              color: Colors.blue,
                            ),
                            title: Text("Add Material"),
                            onTap: () {
                              Navigator.pushNamed(context, "/show_courses");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.exit_to_app,
                              color: Colors.blue,
                            ),
                            title: Text("Logout"),
                            onTap: () {
                              var alertdialog = AlertDialog(
                                  title: Text("Message"),
                                  content: Text("do you want logout "),
                                  actions: [
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        var auth = FirebaseAuth.instance;
                                        auth.signOut();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context, "/login");
                                      },
                                    )
                                  ]);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return alertdialog;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    body: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CarouselSlider(
                            height: MediaQuery.of(context).size.height - 100,
                            initialPage: 0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            items: images.map((e) {
                              return Builder(
                                builder: (context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration:
                                        BoxDecoration(color: Colors.blue),
                                    child: Image.asset(
                                      e,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ));
              } else {
                widget = Scaffold(
                  appBar: AppBar(
                    title: Text("Home"),
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
        return widget;
      },
    );
  }
}
