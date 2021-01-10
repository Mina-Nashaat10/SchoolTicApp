import 'file:///F:/FCIH/AfterFaculty/FLUTTER/First%20App/1-school_tec/lib/screens/shared/iregistration.dart';
import 'file:///F:/FCIH/AfterFaculty/FLUTTER/First%20App/1-school_tec/lib/screens/shared/registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SchoolTic/models/course.dart';
import 'package:SchoolTic/models/person.dart';

class Professor extends Person implements IRegistration {
  Future<String> registration(person) async {
    var auth = FirebaseAuth.instance;
    var fireStore = FirebaseFirestore.instance;

    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: person.email, password: person.password);
      var user = result.user;
      if (user != null) {
        try {
          await user.sendEmailVerification();
          await fireStore
              .collection("users")
              .doc(person.email)
              .set(this.toMap(person));
          return "User Added Successfully...";
        } catch (e) {
          return "Error Message : " + e.message;
        }
      }
      return null;
    } catch (errorMsg) {
      return errorMsg;
    }
  }

  Future addCourse(Course course) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var c = Course();
    try {
      await firestore.collection("courses").add(c.toMap(course));
      return "Added Successfully";
    } catch (errormsg) {
      return errormsg.message;
    }
  }

  Future deleteCourse(String name) async {
    var user = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection("courses")
        .where("progmail", isEqualTo: user)
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("courses")
          .doc(value.docs[0].id)
          .delete();
    });
  }

  Future updateCourse(Course course) async {
    Course c = Course();
    await FirebaseFirestore.instance
        .collection("courses")
        .where("progmail", isEqualTo: course.professorEmail)
        .where("name", isEqualTo: course.name)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("courses")
          .doc(value.docs[0].id)
          .update(c.toMap(course));
    });
  }
}
