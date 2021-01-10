class Course {
  String name;
  String dept;
  String professorEmail;
  String professorName;
  int maxStudents;
  int noOfStudents;
  String startDay;
  String startMonth;
  String startYear;
  String endDay;
  String endMonth;
  String endYear;

  Map<String, dynamic> toMap(Course course) {
    var map = Map<String, dynamic>();
    map['name'] = course.name;
    map['progmail'] = course.professorEmail;
    // i need for notification
    map['proname'] = course.professorName;
    map['Noofstudent'] = course.noOfStudents;
    map['maxstudents'] = course.maxStudents;
    map['startday'] = course.startDay;
    map['startmonth'] = course.startMonth;
    map['startyear'] = course.startYear;
    map['endday'] = course.endDay;
    map['endmonth'] = course.endMonth;
    map['endyear'] = course.endYear;
    map['dept'] = course.dept;
    return map;
  }

  Course toObject(Map<String, dynamic> map) {
    var course = Course();
    course.name = map['name'];
    course.professorEmail = map['progmail'];
    course.professorName = map['proname'];
    course.maxStudents = map['maxstudents'];
    course.noOfStudents = map['Noofstudent'];
    course.startDay = map['startday'];
    course.startMonth = map['startmonth'];
    course.startYear = map['startyear'];
    course.endDay = map['endday'];
    course.endMonth = map['endmonth'];
    course.endYear = map['endyear'];
    course.dept = map['dept'];
    return course;
  }
}
