class Courses {
  final List<Course> courses;

  Courses({required this.courses});

  factory Courses.fromJsonCourses(List<dynamic> json) {
    List<Course> coursesList = json
        .where((courseJson) => courseJson != null)
        .map((courseJson) => Course.fromJsonCourses(courseJson ?? {}))
        .toList();

    return Courses(courses: coursesList);
  }
}

class Course {
  final int courseId;
  final String courseName;
  final String courseCode;
  final String courseType;
  final String courseYear;
  final int totalCredits;
  final int majorId;
  final String description;
  final String courseSeason;

  Course({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.courseType,
    required this.courseYear,
    required this.totalCredits,
    required this.majorId,
    this.description = '*',
    this.courseSeason = 'Намар, Өвөл, Хавар, Зун',
  });

  // Factory constructor to create a Course instance from JSON
  factory Course.fromJsonCourses(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseName: json['course_name'],
      courseCode: json['course_code'],
      courseType: json['course_type'],
      courseYear: json['course_year'],
      totalCredits: json['total_credits'],
      majorId: json['major_id'],
      description: json['description'] ?? '*',
      courseSeason: json['course_season'] ?? 'Намар, Өвөл, Хавар, Зун',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_name': courseName,
      'course_code': courseCode,
      'course_type': courseType,
      'course_year': courseYear,
      'total_credits': totalCredits,
      'major_id': majorId,
      'description': description,
      'course_season': courseSeason,
    };
  }
}
