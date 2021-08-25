import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SchoolTic/models/student.dart';

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Registration();
  }
}

class _Registration extends State<Registration> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();

  FocusNode fullNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  bool test = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var userType = ['Choose User Type', 'Professor', 'Student'];
  String itemSelected = 'Choose User Type';
  @override
  Widget build(BuildContext context) {
    var form1key = GlobalKey<FormState>();

    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/login1.jpg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.only(top: 100, left: 10, right: 10),
            child: Form(
              key: form1key,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Registration Form",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 45,
                        fontFamily: "Lobster",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  textField(
                      "Enter Your FullName",
                      "Full Name",
                      "FullName is Required",
                      TextInputType.text,
                      Icon(Icons.person, color: Colors.white, size: 25),
                      fullName,
                      fullNameNode,
                      emailNode),
                  textField(
                      "Enter Your Email",
                      "Email",
                      "Email is Required",
                      TextInputType.emailAddress,
                      Icon(Icons.email, color: Colors.white, size: 25),
                      email,
                      emailNode,
                      passwordNode),
                  textField(
                      "Enter Your Password",
                      "Password",
                      "Password is Required",
                      TextInputType.text,
                      Icon(Icons.lock, color: Colors.white, size: 25),
                      password,
                      passwordNode,
                      addressNode),
                  textField(
                      "Enter Your Address",
                      "Address",
                      "Address is Required",
                      TextInputType.streetAddress,
                      Icon(Icons.location_on, color: Colors.white, size: 25),
                      address,
                      addressNode,
                      phoneNode),
                  textField(
                      "Enter Your Phone",
                      "Phone",
                      "Phone is Required",
                      TextInputType.number,
                      Icon(Icons.phone, color: Colors.white, size: 25),
                      phone,
                      phoneNode,
                      null),
                  Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: DropdownButton(
                      items: userType.map((String e) {
                        return DropdownMenuItem<String>(
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: e,
                        );
                      }).toList(),
                      dropdownColor: Colors.cyan,
                      iconEnabledColor: Colors.black,
                      onChanged: (String value) {
                        print("Change");
                        setState(() {
                          itemSelected = value;
                        });
                      },
                      value: itemSelected,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, right: 58, left: 58),
                      onPressed: () {
                        if (form1key.currentState.validate()) {
                          setState(() {
                            test = true;
                          });
                          register();
                        }
                      },
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        "Registration",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            fontFamily: "Ranga"),
                      ),
                    ),
                  ),
                  test == true ? CircularProgressIndicator() : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 40, bottom: 35),
                    child: Row(
                      children: [
                        Text(
                          "You have already Account? ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        GestureDetector(
                          child: Text("Login",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontSize: 15)),
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        ));
  }

  void register() async {
    FirebaseMessaging fcm = FirebaseMessaging();
    String token;
    await fcm.getToken().then((value) {
      token = value;
    });
    Student s = new Student();
    s.fullName = fullName.text.toString();
    s.email = email.text.toString();
    s.password = password.text.toString();
    s.address = address.text.toString();
    s.phone = phone.text.toString();
    s.userType = itemSelected;
    s.token = token;
    var result;
    if (itemSelected == "Choose User Type") {
      setState(() {
        test = false;
      });
      snackBar("Please Choose User Type");
    } else {
      await s.registration(s).then((value) {
        result = value;
        if (result == "User Added Successfully...") {
          snackBar(result);
          Navigator.pushNamed(context, '/image_profile');
        } else {
          snackBar(result);
          setState(() {
            test = false;
          });
        }
      });
    }
  }

  void snackBar(String result) {
    var snack = SnackBar(
      content: Text(result),
      duration: Duration(seconds: 8),
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  Widget textField(
      String hintMsg,
      String label,
      String errorMsg,
      TextInputType inputType,
      Icon icon,
      TextEditingController controller,
      FocusNode node,
      FocusNode nextNode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        focusNode: node,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
        keyboardType: inputType,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hintMsg,
          labelText: label,
          hintStyle: TextStyle(color: Colors.white, fontSize: 10),
          prefixIcon: icon,
          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), gapPadding: 20),
          errorStyle: TextStyle(color: Colors.white),
        ),
        obscureText: controller == password ? true : false,
        validator: (value) {
          if (value.isEmpty) {
            return errorMsg;
          }
          return null;
        },
        onFieldSubmitted: (_) => nextNode == null
            ? FocusScope.of(context).unfocus()
            : FocusScope.of(context).requestFocus(nextNode),
      ),
    );
  }
}
