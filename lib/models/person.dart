import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class Person {
  String fullName;
  String email;
  String password;
  String address;
  String phone;
  String userType;
  String token;

  Future<String> login(person) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      var result = await auth.signInWithEmailAndPassword(
          email: person.email, password: person.password);
      var user = result.user;
      if (user != null) {
        return "Login Successful";
      }
      var res = await InternetAddress.lookup("google.com");
      if (res.isEmpty && res[0].rawAddress.isNotEmpty) {
        return "Please Turn on Wifi or Mobile data";
      }
      return null;
    } catch (error) {
      String errorMessage;
      switch (error.code.toString().toUpperCase()) {
        case "INVALID-EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "USER-NOT-FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "USER-DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "TOO-MANY-REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "OPERATION-NOT-ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Please Check Email and Password";
      }
      return errorMessage;
    }
  }

  Map<String, dynamic> toMap(Person person) {
    var map = Map<String, dynamic>();
    map['name'] = person.fullName;
    map['email'] = person.email;
    map['password'] = person.password;
    map['address'] = person.address;
    map['phone'] = person.phone;
    map['usertype'] = person.userType;
    map['token'] = person.token;
    return map;
  }

  Person toObject(Map<String, dynamic> map) {
    Person person = Person();
    person.fullName = map['name'];
    person.email = map['email'];
    person.password = map['password'];
    person.address = map['address'];
    person.phone = map['phone'];
    person.userType = map['usertype'];
    person.token = map['token'];
    return person;
  }
}
