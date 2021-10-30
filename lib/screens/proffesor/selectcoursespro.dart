import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_tic/models/course.dart';
import 'coursedetailpro.dart';

class SelectCourses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectCourses();
  }
}

class Languages {
  String key;
  String value;
}

class _SelectCourses extends State<SelectCourses> {
  Languages lang;
  List<Languages> list = List<Languages>();
  var myCourses = List<Course>();

  var courses = [
    'C',
    'C++',
    'Java',
    'C#',
    'Php',
    'Dart',
    'JavaScript',
    'Swift',
    'Scala',
    'Go',
    'Python',
    'Ruby',
    'Rust'
  ];
  List<Languages> isChecked = List<Languages>();
  var courses1 = [
    'Data Structure',
    'Algorithm',
    'Software Enginerring -1',
    'Software Enginerring -2',
    'Operation System -1',
    'Operation System -2',
    'Data Mining',
    'Data Warehouese',
    'Compiler',
    'Artificial Intelligence',
  ];

  List<Languages> getMyCourses() {
    list.clear();
    courses.forEach((element) {
      lang = Languages();
      lang.key = "Programming Language";
      lang.value = element;
      list.add(lang);
    });
    courses1.forEach((element) {
      lang = Languages();
      lang.key = "Computer Science";
      lang.value = element;
      list.add(lang);
    });
    return list;
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Courses"),
        ),
        body: Column(
          children: [
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      String key = list[index].key;
                      String val = list[index].value;
                      return CheckboxListTile(
                          secondary: Icon(Icons.school),
                          value: isExists(list[index]),
                          title: Text(
                            val,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(key),
                          onChanged: (value) {
                            bool x = isExists(list[index]);
                            if (!x) {
                              setState(() {
                                isChecked.add(list[index]);
                              });
                            } else {
                              setState(() {
                                for (int i = 0; i < isChecked.length; i++) {
                                  if (isChecked[i].value == val) {
                                    isChecked.removeAt(i);
                                  }
                                }
                              });
                            }
                          });
                    }),
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.only(right: 50, left: 50),
              color: Colors.blueAccent,
              child: Text(
                "Next",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                if (isChecked.length == 0) {
                  var snackBar = SnackBar(
                    content: Text("Please Choose one Course only"),
                  );
                  scaffoldKey.currentState.showSnackBar(snackBar);
                } else if (isChecked.length > 1) {
                  var snackBar = SnackBar(
                    content: Text("Please Choose one Course only"),
                  );
                  scaffoldKey.currentState.showSnackBar(snackBar);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return CourseDetail.withData(
                        isChecked[0].value, isChecked[0].key);
                  }));
                }
              },
            ),
          ],
        ));
  }

  bool isExists(Languages l) {
    bool x = false;
    isChecked.forEach((element) {
      if (element.value == l.value) {
        x = true;
      }
    });
    return x;
  }
}
