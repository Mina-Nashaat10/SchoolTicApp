import 'package:school_tic/models/course.dart';
import 'package:school_tic/models/person.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentHome();
  }
}

class _StudentHome extends State<StudentHome> {
  String name;
  String email;
  List<Course> courses = [];
  double screenHeight;
  double screenWidth;

  Future getData() async {
    FirebaseMessaging _fcm = FirebaseMessaging();
    _fcm.configure(onMessage: (message) async {
      if (message['data']['page'] == 'material') {
        Navigator.pushNamed(context, '/coursematerial');
      } else if (message['data']['page'] == 'course') {
        Navigator.pushNamed(context, '/register_course');
      }
      print("onMessage " + message.toString());
    }, onResume: (message) async {
      if (message['data']['page'] == 'material') {
        Navigator.pushNamed(context, '/coursematerial');
      } else if (message['data']['page'] == 'course') {
        Navigator.pushNamed(context, '/register_course');
      }
      print("onResume " + message.toString());
    }, onLaunch: (message) async {
      if (message['data']['page'] == 'material') {
        Navigator.pushNamed(context, '/coursematerial');
      } else if (message['data']['page'] == 'course') {
        Navigator.pushNamed(context, '/register_course');
      }
    });
    _fcm.subscribeToTopic("student");
    FirebaseAuth auth = FirebaseAuth.instance;
    var result = auth.currentUser;
    email = result.email;
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var s = Person();
        s = s.toObject(element.data());
        name = s.fullName;
      });
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height - 100;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: getImageProfile(),
      builder: (context, snapshot1) {
        Widget widget;
        if (snapshot1.hasData) {
          widget = FutureBuilder(
            future: getData(),
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
                                    backgroundImage:
                                        NetworkImage(snapshot1.data.toString()),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontFamily: "Ranga",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontFamily: "Ranga",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.school,
                              color: Colors.blue,
                            ),
                            title: Text("Register to Courses"),
                            onTap: () {
                              Navigator.pushNamed(context, "/register_course");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.school,
                              color: Colors.blue,
                            ),
                            title: Text("My Courses"),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/my_courses_student");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.school,
                              color: Colors.blue,
                            ),
                            title: Text("Course Material"),
                            onTap: () {
                              Navigator.pushNamed(context, "/course_material");
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
                                  content: Text(
                                    "Do you want to logout ?",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
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
                            options: CarouselOptions(
                                height: screenHeight,
                                autoPlay: true,
                                initialPage: 0),
                            items: images.map((e) {
                              return Builder(
                                builder: (context) {
                                  return Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration:
                                        BoxDecoration(color: Colors.blue),
                                    child: Image.asset(
                                      e,
                                      fit: BoxFit.cover,
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

  Future<String> getImageProfile() async {
    String m;
    String email = FirebaseAuth.instance.currentUser.email;
    await FirebaseStorage.instance
        .ref()
        .child("users/" + email + "/user.png")
        .getDownloadURL()
        .then((value) {
      m = value;
    });
    return m;
  }
}
