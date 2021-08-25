import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SchoolTic/models/student.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State<Login> {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var email = TextEditingController();
  var password = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        key: scaffoldKey,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login1.jpg'),
                    fit: BoxFit.cover)),
            child: Container(
              margin: EdgeInsets.only(top: 150, left: 10, right: 10),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 35),
                      child: Text(
                        "Login Form",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 62,
                            fontFamily: "Lobster",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: TextFormField(
                        controller: email,
                        focusNode: emailNode,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Enter Your Email",
                          labelText: "Email",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15),
                          prefixIcon:
                              Icon(Icons.email, color: Colors.white, size: 25),
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              gapPadding: 20),
                          errorStyle: TextStyle(color: Colors.white),
                        ),
                        obscureText: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Email is Required";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(passwordNode),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: TextFormField(
                        controller: password,
                        focusNode: passwordNode,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Enter Your Password",
                          labelText: "Password",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15),
                          prefixIcon:
                              Icon(Icons.lock, color: Colors.white, size: 25),
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              gapPadding: 20),
                          errorStyle: TextStyle(color: Colors.white),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Password is Required";
                          } else if (value.length < 6) {
                            return "Password must large 6 character";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      child: RaisedButton(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, right: 58, left: 58),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            setState(() {
                              isClicked = true;
                              log();
                              // isClicked = false;
                            });
                          }
                        },
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              fontFamily: "Ranga"),
                        ),
                      ),
                    ),
                    isClicked == true
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                        : Container(),
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 60),
                      child: Row(
                        children: [
                          Text(
                            "Add New Account? ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          GestureDetector(
                            child: Text(
                              "Signin",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Lobster",
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/registration');
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  void log() async {
    Student student = new Student();
    student.email = email.text;
    student.password = password.text;
    var result;
    var g = Student();
    g.login(student).then((value) async {
      result = value;
      if (result == "Login Successful") {
        var snackBar = SnackBar(
          content: Text(result),
          duration: Duration(seconds: 5),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
        await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: email.text)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            element.data().forEach((key, value) {
              if (key == "usertype") {
                if (value == "Professor") {
                  Navigator.pushNamed(context, "/professor_home");
                } else {
                  Navigator.pushNamed(context, "/student_home");
                }
              }
            });
          });
        });
      } else {
        var snackBar = SnackBar(
          content: Text(result),
          duration: Duration(seconds: 5),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
      setState(() {
        isClicked = false;
      });
    });
  }
}
