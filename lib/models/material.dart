class CoursesMaterial {
  String path;
  String proEmail;
  String courseName;

  CoursesMaterial toObject(Map<String, dynamic> map) {
    CoursesMaterial material = CoursesMaterial();
    material.path = map['path'];
    material.proEmail = map['progmail'];
    material.courseName = map['coursename'];
    return material;
  }

  Map<String, dynamic> toMap(CoursesMaterial material) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['path'] = material.path;
    map['progmail'] = material.proEmail;
    map['coursename'] = material.courseName;
    return map;
  }
}
