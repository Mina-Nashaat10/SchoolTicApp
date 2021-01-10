import 'dart:io';

import 'file:///F:/FCIH/AfterFaculty/FLUTTER/First%20App/1-school_tec/lib/screens/shared/iregistration.dart';
import 'package:SchoolTic/models/studentcourse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SchoolTic/models/person.dart';
import 'package:SchoolTic/models/course.dart';

class Student extends Person implements IRegistration {
  @override
  Future<String> registration(person) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

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
    } catch (signUpError) {
      return signUpError.message;
    }
  }

  Future<String> registerCourse(Course course, String studentName) async {
    try {
      await FirebaseFirestore.instance
          .collection("courses")
          .where('name', isEqualTo: course.name)
          .where('progmail', isEqualTo: course.professorEmail)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          var course = Course();
          course = course.toObject(element.data());
          course.noOfStudents = course.noOfStudents + 1;
          FirebaseFirestore.instance
              .collection("courses")
              .doc(element.id)
              .update(course.toMap(course));
        });
      });
      String studentGmail = await FirebaseAuth.instance.currentUser.email;
      StudentCourse studentCourse = StudentCourse();
      studentCourse.studentName = studentName;
      studentCourse.studentEmail = studentGmail;
      studentCourse.professorName = course.professorName;
      studentCourse.professorEmail = course.professorEmail;
      studentCourse.courseName = course.name;
      await FirebaseFirestore.instance
          .collection("studentcourses")
          .add(studentCourse.toMap(studentCourse));
      return "Added Successfully";
    } catch (e) {
      return e.message;
    }
  }
}
