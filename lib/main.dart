import 'package:flutter/material.dart';

import 'package:school_tic/screens/proffesor/addmaterail2.dart';
import 'package:school_tic/screens/proffesor/addmaterailpro1.dart';
import 'package:school_tic/screens/proffesor/coursedetailpro.dart';
import 'package:school_tic/screens/proffesor/mycoursespro.dart';
import 'package:school_tic/screens/proffesor/proffessorhome.dart';
import 'package:school_tic/screens/proffesor/showcoursedetail.dart';
import 'package:school_tic/screens/shared/login.dart';
import 'package:school_tic/screens/student/coursematerial.dart';
import 'package:school_tic/screens/student/registercourse.dart';
import 'package:school_tic/screens/student/studentcourses.dart';
import 'package:school_tic/screens/student/studenthome.dart';
import 'screens/proffesor/selectcoursespro.dart';
import 'screens/shared/imagecrop.dart';
import 'screens/shared/registration.dart';
import 'screens/shared/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "School Tic",
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => Login(),
        '/registration': (context) => Registration(),
        '/image_profile': (context) => CropImage(),

        //Professor Part
        '/professor_home': (context) => ProfessorHome(),
        '/select_courses': (context) => SelectCourses(),
        '/course_detail': (context) => CourseDetail(),
        '/MyCoursesPro': (context) => MyCoursesPro(),
        '/show_courses': (context) => ShowCourses(),
        '/add_material': (context) => AddMaterial(),
        '/show_course_detail': (context) => ShowCourseDetail(),

        //Student Part
        '/student_home': (context) => StudentHome(),
        '/register_course': (context) => RegisterCourse(),
        '/my_courses_student': (context) => MyCoursesStudent(),
        '/course_material': (context) => CoursesMaterials(),
      },
      home: SafeArea(
        child: SplashScreen(),
      ),
    );
  }
}
