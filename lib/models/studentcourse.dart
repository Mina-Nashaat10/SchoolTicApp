class StudentCourse {
  String studentName;
  String studentEmail;
  String professorName;
  String professorEmail;
  String courseName;

  Map<String, dynamic> toMap(StudentCourse studentCourse) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['studentname'] = studentCourse.studentName;
    map['studentgmail'] = studentCourse.studentEmail;
    map['proname'] = studentCourse.professorName;
    map['progmail'] = studentCourse.professorEmail;
    map['coursename'] = studentCourse.courseName;
    return map;
  }

  StudentCourse toObject(Map<String, dynamic> map) {
    StudentCourse studentCourse = StudentCourse();
    studentCourse.studentName = map['studentname'];
    studentCourse.studentEmail = map['studentgmail'];
    studentCourse.professorName = map['proname'];
    studentCourse.professorEmail = map['progmail'];
    studentCourse.courseName = map['coursename'];
    return studentCourse;
  }
}
